import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/models/model_profile.dart';
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
        } else {
          error.value = response.data.message ?? 'Failed to get profile';
          CustomToast.show(Get.overlayContext!, error.value);
        }
      } else if (response is ApiFailure) {
        error.value = response.error.message ?? 'Something went wrong';
        CustomToast.show(Get.overlayContext!, error.value);
      }
    } catch (e) {
      error.value = e.toString();
      CustomToast.show(Get.overlayContext!, error.value);
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
  String get language => profile.value?.data?.lang ?? '';
  String get profileImage => profile.value?.data?.avatarUrl ?? '';
}
