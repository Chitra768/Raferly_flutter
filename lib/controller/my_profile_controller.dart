import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_profile.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/custom_toast_msg.dart';

class MyProfileController extends GetxController {
  final Rx<ModelProfile?> profile = Rx<ModelProfile?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  Future<void> getProfile() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await RESTAuth.getProfile();

      if (response is ApiSuccess<ModelProfile>) {
        if (response.data.status == true) {
          profile.value = response.data;
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
  String get userType => profile.value?.data?.companyType ?? '';
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
}
