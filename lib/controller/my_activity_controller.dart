import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_busniess_referral_lead.dart';
import 'package:referaly/models/model_contact_response.dart';
import 'package:referaly/models/model_coworkerlist_deal.dart';
import 'package:referaly/models/model_network_response.dart';
import 'package:referaly/models/model_read_otification.dart';
import 'package:referaly/models/model_receive_lead_delete.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/success_popup.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class MyActivityController extends GetxController {
  late PageController pageController;
  int initialPage = 0;

  // Observable variables
  final RxBool isMyContractsSelected = true.obs;
  final RxInt selectedNavIndex = 1.obs;
  final RxList<String> referrerNames = <String>[].obs;
  final mainController = Get.find<ControllerMainProfessional>();

  MyActivityController({this.initialPage = 0});

  // Toggle tab selection
  void toggleTabSelection(bool isContractsSelected) {
    isMyContractsSelected.value = isContractsSelected;
    if (pageController.hasClients) {
      pageController.animateToPage(
        isContractsSelected ? 0 : 1,
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
      );
    }

    // Call read notification API when My Network tab is selected
    if (!isContractsSelected) {
      readActivityNotification();
    }
  }

  // Set selected navigation item
  void setNavIndex(int index) {
    selectedNavIndex.value = index;
  }

  // Add a new referrer
  void addReferrer(String name) {
    if (referrerNames.length < 5) {
      referrerNames.add(name);
    }
  }

  // Remove a referrer
  void removeReferrer(int index) {
    if (index >= 0 && index < referrerNames.length) {
      referrerNames.removeAt(index);
    }
  }

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(
      initialPage: initialPage,
    );

    isMyContractsSelected.value = initialPage == 0;
    updateInit();
  }

  updateInit() {
    getNetworkList();
    getContactList();
    getUserDealList();
  }

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final Rx<ModelNetworkResponse?> networkList = Rx<ModelNetworkResponse?>(null);
  Future<void> getNetworkList() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await RESTAuth.getNetworkList();

      if (response is ApiSuccess<ModelNetworkResponse>) {
        if (response.data.status == true) {
          networkList.value = response.data;
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

  final RxBool isContactLoading = false.obs;
  final RxString contactError = ''.obs;
  final Rx<ModelContactResponse?> contactList = Rx<ModelContactResponse?>(null);

  Future<void> getContactList() async {
    try {
      isContactLoading.value = true;
      contactError.value = '';

      final response = await RESTAuth.getContactList();

      if (response is ApiSuccess<ModelContactResponse>) {
        if (response.data.status == true) {
          contactList.value = response.data;
          update();
        } else {
          contactError.value =
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        contactList.value?.data?.clear();
        contactError.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      contactList.value?.data?.clear();
      contactError.value = e.toString();
    } finally {
      isContactLoading.value = false;
    }
  }

  Future<void> deleteContract(String id) async {
    final response = await RESTAuth.deleteDeal(id: id);
    if (response is ApiSuccess<ModelReceiveLeadDelete>) {
      if (response.data.status == true) {
        await getContactList();
        // Show success popup
        if (Get.context != null) {
          showDialog(
            context: Get.context!,
            builder: (context) => SuccessPopup(
              message: response.data.message ?? '',
              onOk: () {},
            ),
            barrierDismissible: false,
          );
        }
      } else {
        contactError.value =
            response.data.message ?? tr(LanguageKeys.somethingWentWrong);
      }
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
          print(
              "userDealList.value?.data?.length: ${userDealList.value?.data?.length}");
        } else {
          userDealList.value = response.data;
          userDealError.value =
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        userDealError.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      userDealError.value = e.toString();
    } finally {
      isUserDealLoading.value = false;
    }
  }

  void openPdfBottomSheet(BuildContext context, String pdfUrl) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              // Header
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  color: Colors.white,
                  boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black12)],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
              ),
              // PDF Viewer
              const Divider(height: 1),
              Expanded(
                child: SfPdfViewer.network(pdfUrl),
              ),
            ],
          ),
        );
      },
    );
  }

  RxList<BusinessReferralLeadData> referrers = <BusinessReferralLeadData>[].obs;
  Future<void> fetchReferrers({String search = '', String id = ''}) async {
    try {
      final response = await RESTAuth.businessReferralLead(search, id);
      if (response is ApiSuccess<ModelBusinessReferralLead>) {
        referrers.value = response.data.data ?? [];
      } else if (response is ApiFailure) {
        error.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
    } finally {}
  }

  Future<void> readActivityNotification() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await RESTAuth.readNotification(type: "activity");

      if (response is ApiSuccess<ModelReadNotification>) {
        if (response.data.status == true) {
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
}
