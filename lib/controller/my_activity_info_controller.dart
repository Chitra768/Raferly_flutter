import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/models/model_coworkerlist_deal.dart';
import 'package:referaly/models/model_network_response.dart';

class MyActivityInfoController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final Rx<ModelNetworkResponse?> networkList = Rx<ModelNetworkResponse?>(null);

  @override
  void onInit() {
    super.onInit();
    getNetworkList();
  }

  Future<void> getNetworkList() async {
    try {
      isLoading.value = true;
      error.value = '';
      final response = await RESTAuth.getNetworkList();
      if (response is ApiSuccess<ModelNetworkResponse>) {
        if (response.data.status == true) {
          networkList.value = response.data;
        } else {
          error.value = response.data.message ?? 'Failed to get network data';
        }
      } else if (response is ApiFailure) {
        error.value = response.error.message ?? 'Something went wrong';
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

   final RxBool isUserDealLoading = false.obs;
  final RxString userDealError = ''.obs;
  final Rx<ModelCoworkerlistDeal?> userDealList =
      Rx<ModelCoworkerlistDeal?>(null);

  Future<void> getUserDealList() async {
    try {
      isUserDealLoading.value = true;
      userDealError.value = '';

      final response = await RESTAuth.getUserDealList();

      if (response is ApiSuccess<ModelCoworkerlistDeal>) {
        if (response.data.status == true) {
          userDealList.value = response.data;
        } else {
          userDealError.value = response.data.message ?? 'Failed to get Leads';
        }
      } else if (response is ApiFailure) {
        userDealError.value = response.error.message ?? 'Something went wrong';
      }
    } catch (e) {
      userDealError.value = e.toString();
    } finally {
      isUserDealLoading.value = false;
    }
  }

}
