import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_team_management.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_team_member.dart';
import 'package:referaly/utils/translations.dart';

class TeamMemberContentController extends GetxController {
  /// Full-screen load only on first paint (no data yet).
  final RxBool isLoading = false.obs;

  /// Tab switch in progress — keep list visible, show light overlay.
  final RxBool isRefreshing = false.obs;
  final RxString error = ''.obs;
  final Rx<TeamMemberContentModel?> content = Rx<TeamMemberContentModel?>(null);

  /// Profile header (name, avatar, stats) — set once; tab switches do not replace it.
  final Rx<TeamMemberContentModel?> profileSnapshot = Rx<TeamMemberContentModel?>(null);

  final Rx<TeamMemberContentTab> selectedTab = TeamMemberContentTab.leads.obs;

  final Map<TeamMemberContentTab, TeamMemberContentModel> _tabCache = {};

  int? memberId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      memberId = args['memberId'] as int? ?? int.tryParse('${args['memberId']}');
      final tabIndex = args['initialTab'] as int?;
      if (tabIndex != null && tabIndex >= 0 && tabIndex < TeamMemberContentTab.values.length) {
        selectedTab.value = TeamMemberContentTab.values[tabIndex];
      }
    }
    if (memberId != null) {
      loadContent();
    } else {
      error.value = tr(LanguageKeys.somethingWentWrong);
    }
  }

  Future<void> selectTab(TeamMemberContentTab tab) async {
    if (selectedTab.value == tab) return;
    selectedTab.value = tab;

    final cached = _tabCache[tab];
    if (cached != null) {
      error.value = '';
      profileSnapshot.value ??= cached;
      content.value = cached;
      return;
    }

    await loadContent();
  }

  Future<void> loadContent() async {
    if (memberId == null) return;

    final tab = selectedTab.value;
    final cached = _tabCache[tab];

    if (cached != null) {
      content.value = cached;
      return;
    }

    final showFullLoader = content.value == null;
    if (showFullLoader) {
      isLoading.value = true;
    } else {
      isRefreshing.value = true;
    }
    error.value = '';

    try {
      final response = await RESTTeamManagement.getTeamMemberContent(
        memberId: memberId!,
        tab: tab.apiValue,
      );
      if (response is ApiSuccess<TeamMemberContentResponse>) {
        final data = response.data.data;
        if (data != null) {
          _tabCache[tab] = data;
          profileSnapshot.value ??= data;
          if (selectedTab.value == tab) {
            content.value = data;
          }
        } else if (selectedTab.value == tab) {
          error.value = response.data.message ?? tr(LanguageKeys.somethingWentWrong);
          if (showFullLoader) {
            content.value = null;
          }
        }
      } else if (response is ApiFailure) {
        if (selectedTab.value == tab) {
          error.value = response.error.message ?? tr(LanguageKeys.somethingWentWrong);
          if (showFullLoader) {
            content.value = null;
          }
        }
      }
    } catch (e) {
      if (selectedTab.value == tab) {
        error.value = e.toString();
        if (showFullLoader) {
          content.value = null;
        }
      }
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }
}
