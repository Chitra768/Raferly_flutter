import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:referaly/fcm/notification_router.dart';
import 'package:referaly/fcm/pending_notification_store.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_log.dart';
import 'package:referaly/resources/app_preference.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initialize() async {
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    String? token = await _fcm.getToken();
    AppLog.d("FCM: Token => $token");
    if (token != null) {
      await AppPreference.writeString(AppPreference.fcmToken, token);
    }

    await _createNotificationChannel();
    await _initLocalNotification();
    _setupListeners();

    final initial = await _fcm.getInitialMessage();
    if (initial != null) {
      AppLog.d('FCM: getInitialMessage => ${initial.data}');
      await PendingNotificationStore.save(initial.data);
    }
  }

  Future<void> requestPermissions() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    AppLog.d("FCM: Permission status => ${settings.authorizationStatus}");
  }

  void _setupListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      AppLog.d("FCM: onMessage => ${message.data}");
      final json = const JsonEncoder.withIndent('  ').convert(message.toMap());
      AppLog.d('FCM: onMessage json =>\n$json');

      if (Platform.isAndroid) {
        _showNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      AppLog.d("FCM: onMessageOpenedApp => ${message.data}");
      NotificationRouter.handle(message.data);
    });
  }

  Future<void> _initLocalNotification() async {
    const androidInit = AndroidInitializationSettings('app_icon');
    const iosInit = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          final decoded = jsonDecode(response.payload!);
          if (decoded is Map<String, dynamic>) {
            NotificationRouter.handle(decoded);
          } else if (decoded is Map) {
            NotificationRouter.handle(Map<String, dynamic>.from(decoded));
          }
        }
      },
    );
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Used for important notifications.',
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
      showBadge: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _showNotification(RemoteMessage message) async {
    final data = message.data;
    final title = message.notification?.title ?? '';
    final body = message.notification?.body ?? '';

    BigPictureStyleInformation? bigPicture;

    if (data.containsKey('image') && data['image'].toString().isNotEmpty) {
      final imageBytes = await _getImageFromUrl(data['image']);
      final image = ByteArrayAndroidBitmap(imageBytes);
      bigPicture = BigPictureStyleInformation(
        image,
        contentTitle: title,
        summaryText: body,
        htmlFormatContentTitle: true,
        htmlFormatSummaryText: true,
      );
    }

    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'Used for important notifications.',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@drawable/app_icon',
        color: AppColors.primary,
        styleInformation: bigPicture,
        enableVibration: true,
        playSound: true,
        showWhen: true,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      data.hashCode,
      title,
      body,
      notificationDetails,
      payload: jsonEncode(data),
    );
  }

  Future<Uint8List> _getImageFromUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }
}

// Initialize globally
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
