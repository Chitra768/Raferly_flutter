import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_busniess_referral_lead.dart';
import 'package:referaly/models/model_common.dart';
import 'package:referaly/models/model_contact_response.dart';
import 'package:referaly/models/model_coworkerlist_deal.dart';
import 'package:referaly/models/model_network_response.dart';
import 'package:referaly/models/model_read_otification.dart';
import 'package:referaly/models/model_receive_lead_delete.dart';
import 'package:referaly/models/model_upload_document.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/success_popup.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

enum MyNetworkStatusFilter { all, activeOnly, pendingOnly }

enum MyNetworkSortType { none, aToZ, zToA, mostLeads, conversionRate, turnover }

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
    readActivityNotification();
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
  final RxBool isNetworkLoading = false.obs;

  final Rx<MyNetworkStatusFilter> myNetworkStatusFilter = MyNetworkStatusFilter.all.obs;
  // Default: Most leads sent (as per product requirement).
  final Rx<MyNetworkSortType> myNetworkSortType = MyNetworkSortType.mostLeads.obs;
  final RxString myNetworkFilterBy = ''.obs;
  final RxString myNetworkSearchQuery = ''.obs;
  final RxnInt myNetworkDealIdFilter = RxnInt();
  final RxString myNetworkDealNameFilter = ''.obs;

  /// API-supported single filter key (only one at a time).
  /// Values: active, pending, a_z, z_a, most_leads_sent, conversion_rate, turn_over_generated
  String myNetworkEffectiveFilterBy() {
    final explicit = myNetworkFilterBy.value.trim();
    if (explicit.isNotEmpty) return explicit;

    if (myNetworkStatusFilter.value == MyNetworkStatusFilter.activeOnly) return 'active';
    if (myNetworkStatusFilter.value == MyNetworkStatusFilter.pendingOnly) return 'pending';

    switch (myNetworkSortType.value) {
      case MyNetworkSortType.aToZ:
        return 'a_z';
      case MyNetworkSortType.zToA:
        return 'z_a';
      case MyNetworkSortType.mostLeads:
        return 'most_leads_sent';
      case MyNetworkSortType.conversionRate:
        return 'conversion_rate';
      case MyNetworkSortType.turnover:
        return 'turn_over_generated';
      case MyNetworkSortType.none:
        return '';
    }
  }

  /// Human-readable label for the current filter (empty = none).
  String myNetworkAppliedFilterLabel() {
    switch (myNetworkEffectiveFilterBy()) {
      case 'active':
        return tr(LanguageKeys.myNetworkFilterActive);
      case 'pending':
        return tr(LanguageKeys.myNetworkFilterPending);
      case 'a_z':
        return tr(LanguageKeys.myNetworkFilterAZ);
      case 'z_a':
        return tr(LanguageKeys.myNetworkFilterZA);
      case 'most_leads_sent':
        return tr(LanguageKeys.myNetworkFilterMostLeadsSent);
      case 'conversion_rate':
        return tr(LanguageKeys.myNetworkFilterConversionRate);
      case 'turn_over_generated':
        return tr(LanguageKeys.myNetworkFilterTurnoverGenerated);
      default:
        return '';
    }
  }

  Future<void> setMyNetworkFilterBy(String filterBy) async {
    myNetworkFilterBy.value = filterBy.trim();

    // Keep legacy flags in sync (so UI selection highlights correctly).
    switch (myNetworkFilterBy.value) {
      case 'active':
        myNetworkStatusFilter.value = MyNetworkStatusFilter.activeOnly;
        myNetworkSortType.value = MyNetworkSortType.none;
        break;
      case 'pending':
        myNetworkStatusFilter.value = MyNetworkStatusFilter.pendingOnly;
        myNetworkSortType.value = MyNetworkSortType.none;
        break;
      case 'a_z':
        myNetworkStatusFilter.value = MyNetworkStatusFilter.all;
        myNetworkSortType.value = MyNetworkSortType.aToZ;
        break;
      case 'z_a':
        myNetworkStatusFilter.value = MyNetworkStatusFilter.all;
        myNetworkSortType.value = MyNetworkSortType.zToA;
        break;
      case 'most_leads_sent':
        myNetworkStatusFilter.value = MyNetworkStatusFilter.all;
        myNetworkSortType.value = MyNetworkSortType.mostLeads;
        break;
      case 'conversion_rate':
        myNetworkStatusFilter.value = MyNetworkStatusFilter.all;
        myNetworkSortType.value = MyNetworkSortType.conversionRate;
        break;
      case 'turn_over_generated':
        myNetworkStatusFilter.value = MyNetworkStatusFilter.all;
        myNetworkSortType.value = MyNetworkSortType.turnover;
        break;
      default:
        myNetworkStatusFilter.value = MyNetworkStatusFilter.all;
        myNetworkSortType.value = MyNetworkSortType.none;
        myNetworkFilterBy.value = '';
        break;
    }

    await getNetworkList();
  }

  /// Active referrers: API `active_business_referrers`, then `total_business_referrers`, else list count.
  int myNetworkActiveCount() {
    final d = networkList.value?.data;
    if (d?.activeBusinessReferrers != null) return d!.activeBusinessReferrers!;
    if (d?.totalBusinessReferrers != null) return d!.totalBusinessReferrers!;
    final list = d?.businessReferrers ?? [];
    return list.where((b) => !(b.isPendingInvitation ?? false)).length;
  }

  /// Pending: API `pending_business_referrers` (or legacy pending count keys), else list count.
  int myNetworkPendingCount() {
    final d = networkList.value?.data;
    if (d?.pendingBusinessReferrers != null) return d!.pendingBusinessReferrers!;
    final list = d?.businessReferrers ?? [];
    return list.where((b) => b.isPendingInvitation ?? false).length;
  }

  List<BusinessReferrers> myNetworkDisplayReferrers() {
    final raw = networkList.value?.data?.businessReferrers ?? <BusinessReferrers>[];
    // Display exactly what API returns. (No local filtering/sorting.)
    return List<BusinessReferrers>.from(raw);
  }

  void setMyNetworkDealFilter({int? dealId, String dealName = ''}) {
    myNetworkDealIdFilter.value = dealId;
    myNetworkDealNameFilter.value = dealName.trim();
    getNetworkList();
  }

  Future<void> getNetworkList() async {
    try {
      isNetworkLoading.value = true;
      isLoading.value = true;
      error.value = '';

      final response = await RESTAuth.getNetworkList(
        filterBy: myNetworkEffectiveFilterBy(),
        dealId: myNetworkDealIdFilter.value,
      );

      if (response is ApiSuccess<ModelNetworkResponse>) {
        if (response.data.status == true) {
          networkList.value = response.data;
        } else {
          error.value = response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        error.value = response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
      isNetworkLoading.value = false;
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
          contactError.value = response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        contactList.value?.data?.clear();
        contactError.value = response.error.message ?? tr(LanguageKeys.somethingWentWrong);
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
        contactError.value = response.data.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    }
  }

  final RxBool isDeletingNetwork = false.obs;
  final RxString deleteNetworkError = ''.obs;

  Future<void> deleteNetwork(int refererId) async {
    try {
      isDeletingNetwork.value = true;
      deleteNetworkError.value = '';

      final response = await RESTAuth.deleteNetwork(refererId: refererId);
      if (response is ApiSuccess<ModelCommon>) {
        if (response.data.status == true) {
          await getNetworkList();
          // Show success popup
          if (Get.context != null) {
            await showDialog(
              context: Get.context!,
              builder: (context) => SuccessPopup(
                message: response.data.message ?? 'Network deleted successfully',
                onOk: () {},
              ),
              barrierDismissible: false,
            );
          }
        } else {
          deleteNetworkError.value = response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        deleteNetworkError.value = response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      deleteNetworkError.value = e.toString();
    } finally {
      isDeletingNetwork.value = false;
    }
  }

  final RxBool isUserDealLoading = false.obs;
  final RxString userDealError = ''.obs;
  final Rx<ModelCoworkerlistDeal?> userDealList = Rx<ModelCoworkerlistDeal?>(null);

  Future<void> getUserDealList() async {
    try {
      isUserDealLoading.value = true;
      userDealError.value = '';

      final response = await RESTAuth.getUserDealList();

      if (response is ApiSuccess<ModelCoworkerlistDeal>) {
        if (response.data.status == true) {
          userDealList.value = response.data;
          print("userDealList.value?.data?.length: ${userDealList.value?.data?.length}");
        } else {
          userDealList.value = response.data;
          userDealError.value = response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        userDealError.value = response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      userDealError.value = e.toString();
    } finally {
      isUserDealLoading.value = false;
    }
  }

  void openPdfBottomSheet(BuildContext context, String pdfUrl) {
    if (pdfUrl.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF link is not available')),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
        error.value = response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
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
          error.value = response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        error.value = response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  final RxBool isUploading = false.obs;
  final RxString uploadError = ''.obs;

  Future<void> uploadDocument(String id, String uploadNotify, List<File> pdfFiles,
      {Map<String, String>? renamedFiles}) async {
    try {
      isUploading.value = true;
      uploadError.value = '';

      final response = await RESTAuth.uploadDocument(id, uploadNotify, pdfFiles, renamedFiles: renamedFiles);
      if (response is ApiSuccess<ModelUploadDocument>) {
        if (response.data.status == true) {
          // Show success popup
          if (Get.context != null) {
            await showDialog(
              context: Get.context!,
              builder: (context) => SuccessPopup(
                message: response.data.message ?? '',
                onOk: () {},
              ),
              barrierDismissible: false,
            );
          }
        } else {
          uploadError.value = response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        uploadError.value = response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      uploadError.value = e.toString();
    } finally {
      isUploading.value = false;
    }
  }
}
