import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/controller/track_lead.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_common.dart';
import 'package:referaly/models/model_error.dart';
import 'package:referaly/models/model_profile.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/screens/auth/screen_initial_language.dart';
import 'package:referaly/screens/auth/screen_welcome.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/custom_toast_msg.dart';
import 'package:referaly/widgets/dialog/success_popup.dart';

class MyProfileController extends GetxController {
  final Rx<ModelProfile?> profile = Rx<ModelProfile?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxBool isProfileLoaded = false.obs;

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  Future<void> getProfile() async {
    if (isLoading.value) return; // Prevent multiple simultaneous calls

    try {
      isLoading.value = true;
      error.value = '';

      final response = await RESTAuth.getProfile();

      if (response is ApiSuccess<ModelProfile>) {
        if (response.data.status == true) {
          profile.value = response.data;
          isProfileLoaded.value = true;
          await AppPreference.writeString(
              AppPreference.isPaid, response.data.data!.isPaid.toString());
          await AppPreference.writeString(AppPreference.productId,
              response.data.data!.productId.toString());
        } else {
          error.value =
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        error.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Convenience getters for profile data
  String get firstName => profile.value?.data?.firstName ?? '';
  String get lastName => profile.value?.data?.lastName ?? '';
  String get email => profile.value?.data?.email ?? '';
  String get phone => profile.value?.data?.phoneNumber ?? '';
  String get userType {
    final type = profile.value?.data?.companyType?.toLowerCase() ?? '';
    final lang = profile.value?.data?.lang?.toLowerCase() ?? '';
    if (lang == 'fr' || lang == 'french') {
      if (type == 'professional') return tr(LanguageKeys.professional);
      if (type == 'individual') return tr(LanguageKeys.individual);
    } else if (lang == 'es' || lang == 'spanish') {
      if (type == 'professional') return tr(LanguageKeys.professional);
      if (type == 'individual') return 'Particular';
    } else {
      // Default to English
      if (type == 'professional') return tr(LanguageKeys.professional);
      if (type == 'individual') return tr(LanguageKeys.individual);
    }
    return type;
  }

  String get job => profile.value?.data?.job ?? '';
  String get city => profile.value?.data?.city ?? '';
  String get language {
    final lang = profile.value?.data?.lang?.toLowerCase() ?? '';
    if (lang == 'es' || lang == 'spanish' || lang == 'Spanish') {
      return 'Español';
    } else if (lang == 'en' || lang == 'english' || lang == 'English') {
      return 'English';
    } else if (lang == 'fr' || lang == 'french' || lang == 'French') {
      return 'Français';
    }
    return lang;
  }

  String get profileImage => profile.value?.data?.avatarUrl ?? '';
  String get countryCode => profile.value?.data?.countryCode ?? '';
  int get isPaid => profile.value?.data?.isPaid ?? 0;

  final RxBool isDeleteAccountLoading = false.obs;
  final RxString deleteAccountErrorMessage = ''.obs;

  Future<void> deleteAccount() async {
    try {
      isDeleteAccountLoading.value = true;

      final response = await RESTAuth.deleteAccount();

      if (response is ApiSuccess<ModelCommon>) {
        if (response.data.status == true) {
          if (Get.context != null) {
            await Get.dialog(
              SuccessPopup(
                message: response.data.message ?? '',
                onOk: () async {
                  isDeleteAccountLoading.value = false;
                  // Cleaxcr all SharedPreferences data
                  // Clear controller cached data first
                  if (Get.isRegistered<ControllerMainProfessional>()) {
                    Get.find<ControllerMainProfessional>().clearCachedData();
                  }
                  if (Get.isRegistered<TrackLeadsController>()) {
                    Get.delete<TrackLeadsController>();
                  }

                  await AppPreference.clearPreferences();

                  // Clear any cached data
                  await AppPreference.clearLoginData();

                  // Clear access token specifically
                  await AppPreference.clearAccessToken();

                  // Clear all routes and navigate to initial language screen
                  Get.until((route) => false);
                  Get.offAllNamed(ScreenInitialLanguage.pageId);
                  Get.back();
                },
              ),
              barrierDismissible: false,
            );
          }
        }
      }
    } catch (e) {
      // Handle error appropriately
    } finally {
      isDeleteAccountLoading.value = false;
    }
  }
}
