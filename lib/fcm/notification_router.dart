import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/controller/my_activity_controller.dart';
import 'package:referaly/controller/search_professionals_controller.dart';
import 'package:referaly/controller/track_lead_controller.dart';
import 'package:referaly/fcm/pending_notification_store.dart';
import 'package:referaly/resources/app_log.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/screens/archeive/archeive_list.dart';
import 'package:referaly/screens/dashboard/my_activity_screen.dart';
import 'package:referaly/screens/deals/invited_deals_screen.dart';
import 'package:referaly/screens/home/screen_main.dart';
import 'package:referaly/screens/search/search_professionals_screen.dart';

/// Parsed FCM `data` payload for navigation.
class NotificationPayload {
  NotificationPayload({
    required this.type,
    this.leadId,
    this.dealId,
    this.finderRequestId,
  });

  final String type;
  final String? leadId;
  final String? dealId;
  final String? finderRequestId;

  factory NotificationPayload.fromMap(Map<String, dynamic> data) {
    final rawType = data['type']?.toString().trim() ?? '';
    return NotificationPayload(
      type: _normalizeType(rawType),
      leadId: _stringOrNull(data['lead_id']),
      dealId: _stringOrNull(data['deal_id']),
      finderRequestId: _stringOrNull(data['finder_request_id']),
    );
  }

  static String _normalizeType(String raw) {
    final upper = raw.toUpperCase();
    switch (upper) {
      case 'LEAD_SENT':
        return 'LEAD_SENT_LEGACY';
      case 'LEAD_RECEIVED':
        return 'LEAD_RECEIVED_LEGACY';
      default:
        return upper;
    }
  }

  static String? _stringOrNull(dynamic value) {
    if (value == null) return null;
    final s = value.toString().trim();
    return s.isEmpty ? null : s;
  }
}

/// Routes notification taps to the correct screen.
class NotificationRouter {
  NotificationRouter._();

  static bool _isUserLoggedIn() {
    final loggedIn = AppPreference.readInt(AppPreference.isLoggedIn) == 1;
    final token = AppPreference.readString(AppPreference.accessToken);
    return loggedIn && token != null && token.isNotEmpty;
  }

  static void handle(Map<String, dynamic> data, {bool fromColdStart = false}) {
    if (!_isUserLoggedIn()) {
      PendingNotificationStore.save(data);
      AppLog.d('FCM: saved pending notification (not logged in)');
      return;
    }

    void run() {
      try {
        final payload = NotificationPayload.fromMap(data);
        AppLog.d('FCM: route type=${payload.type} data=$data');
        _route(payload);
      } catch (e, st) {
        AppLog.d('FCM: route error $e\n$st');
      }
    }

    if (fromColdStart) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 500), run);
      });
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) => run());
    }
  }

  static void _route(NotificationPayload payload) {
    switch (payload.type) {
      case 'LEAD_RECEIVE':
      case 'LEAD_RECOVERED_NOTIFICATION':
      case 'LEAD_RECEIVED_LEGACY':
        _goToTrackLeads(received: true, leadId: payload.leadId);
        break;

      case 'REQUEST_TO_UPDATE_LEAD':
        _goToTrackLeads(received: true, leadId: payload.leadId);
        break;

      case 'LEAD_COMMENT_UPDATE_NOTIFICATION':
      case 'LEAD_NEXT_STEP_NOTIFICATION':
      case 'LEAD_COMMENT_NOTIFICATION':
      case 'LEAD_SENT_LEGACY':
        _goToTrackLeads(received: false, leadId: payload.leadId);
        break;

      case 'LEAD_DELETE_NOTIFICATION':
      case 'LEAD_COMPLETED_NOTIFICATION':
      case 'LEAD_COMMISSION_NOTIFICATION':
        _goToArchiveSent();
        break;

      case 'DEAL_ACCEPT_OUT_OF_REFERALY':
      case 'DEAL_UPDATE':
      case 'DEAL_DOCUMENT_UPLOADED':
        _goToInvitedDeals();
        break;

      case 'DEAL_ACCEPT':
      case 'DEAL_LEAVE':
        _goToMyNetwork(dealId: payload.dealId);
        break;

      case 'FINDER_REQUEST_NOTIFICATION':
      case 'FINDER_REQUEST_ACCEPTED':
        _goToFinder(finderRequestId: payload.finderRequestId);
        break;

      case 'DEAL_CREATE':
      case 'YOU_DEAL_ACCEPT':
        break;

      default:
        AppLog.d('FCM: unhandled notification type ${payload.type}');
        break;
    }
  }

  static Future<void> _ensureMainScreen() async {
    if (Get.currentRoute != ScreenMain.pageId) {
      if (!Get.isRegistered<ControllerMainProfessional>()) {
        Get.put(ControllerMainProfessional());
      }
      await Get.offAllNamed(ScreenMain.pageId);
      await Future.delayed(const Duration(milliseconds: 300));
    } else if (!Get.isRegistered<ControllerMainProfessional>()) {
      Get.put(ControllerMainProfessional());
    }
  }

  static TrackLeadsController _trackController() {
    if (!Get.isRegistered<TrackLeadsController>()) {
      return Get.put(TrackLeadsController());
    }
    return Get.find<TrackLeadsController>();
  }

  static Future<void> _goToTrackLeads({
    required bool received,
    String? leadId,
  }) async {
    await _ensureMainScreen();
    final main = Get.find<ControllerMainProfessional>();
    final track = _trackController();

    if (leadId != null) {
      track.pendingOpenLeadId = leadId;
    }

    main.changeTab(1);
    await track.toggleLeadType(received);
    track.applyPendingLeadOpen();
  }

  static Future<void> _goToArchiveSent() async {
    await _ensureMainScreen();
    await Get.toNamed(
      ArchiveList.pageId,
      arguments: <String, dynamic>{'type': 'send'},
    );
  }

  static Future<void> _goToInvitedDeals() async {
    await _ensureMainScreen();
    await Get.toNamed(InvitedDealsScreen.pageId);
  }

  static Future<void> _goToMyNetwork({String? dealId}) async {
    await _ensureMainScreen();
    await Get.toNamed(
      MyActivityScreen.pageId,
      arguments: <String, dynamic>{'initialPage': 1},
    );

    if (dealId == null) return;

    final parsed = int.tryParse(dealId);
    if (parsed == null) return;

    Future.delayed(const Duration(milliseconds: 400), () {
      if (!Get.isRegistered<MyActivityController>()) return;
      Get.find<MyActivityController>().setMyNetworkDealFilter(dealId: parsed);
    });
  }

  static Future<void> _goToFinder({String? finderRequestId}) async {
    await _ensureMainScreen();
    await Get.toNamed(SearchProfessionalsScreen.pageId);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!Get.isRegistered<SearchProfessionalsController>()) return;
      final finder = Get.find<SearchProfessionalsController>();
      if (finderRequestId != null) {
        finder.pendingFinderRequestId = finderRequestId;
      }
      finder.setSelectedTab(0);
      finder.applyPendingFinderRequest();
    });
  }
}
