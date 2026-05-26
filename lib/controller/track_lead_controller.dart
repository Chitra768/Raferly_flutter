import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/helpers/agency_colleague_access_helper.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_common.dart';
import 'package:referaly/models/model_read_otification.dart';
import 'package:referaly/models/model_receive_lead_delete.dart';
import 'package:referaly/models/model_received_lead.dart';
import 'package:referaly/models/model_send_lead.dart' as send_lead;
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/mark_lead_success_popup.dart';
import 'package:referaly/widgets/dialog/success_popup.dart';

class TrackLeadsController extends GetxController {
  RxBool isLeadsReceived = true.obs;
  RxDouble buttonScale = 1.0.obs;

  RxInt currentStep = RxInt(0);
  final mainController = Get.find<ControllerMainProfessional>();
  void toggleLeadType(bool isReceived) async {
    isLeadsReceived.value = isReceived;
    if (isReceived) {
      readReceivedLeadNotification();
      await getLeads();
      await Future.delayed(const Duration(milliseconds: 100)); // Small delay
      receivedLead.refresh(); // Explicitly refresh the reactive variable
      update(); // Force UI update
    } else {
      readSendLeadNotification();
      await getSendLeads();
      await Future.delayed(const Duration(milliseconds: 100)); // Small delay
      sendLead.refresh(); // Explicitly refresh the reactive variable
      update(); // Force UI update
    }
  }

  @override
  void onInit() {
    super.onInit();
    getLeads();
    getSendLeads();
  }

  @override
  void onClose() {
    super.onClose();
  }

  final Rx<ModelReceivedLead?> receivedLead = Rx<ModelReceivedLead?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxBool isReceivedAccessDenied = false.obs;
  Future<void> getLeads() async {
    try {
      isLoading.value = true;
      error.value = '';
      isReceivedAccessDenied.value = false;

      final response = await RESTAuth.getLeads(limit: 20, page: 1);

      if (response is ApiSuccess<ModelReceivedLead>) {
        if (response.data.status == true) {
          receivedLead.value = response.data;
        } else {
          error.value =
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        if (AgencyColleagueAccessHelper.isAgencyAccessDenied(response)) {
          isReceivedAccessDenied.value = true;
          receivedLead.value = null;
        }
        error.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  final Rx<send_lead.ModelSendLead?> sendLead =
      Rx<send_lead.ModelSendLead?>(null);
  final RxBool isLoadingSendLeads = false.obs;
  final RxString errorSendLeads = ''.obs;
  final RxBool isSentAccessDenied = false.obs;

  final RxBool isLoadingComment = false.obs;
  final RxString errorComment = ''.obs;

  Future<void> getSendLeads() async {
    try {
      isLoadingSendLeads.value = true;
      errorSendLeads.value = '';
      isSentAccessDenied.value = false;

      final response = await RESTAuth.getSendLeads();

      if (response is ApiSuccess<send_lead.ModelSendLead>) {
        if (response.data.status == true) {
          sendLead.value = response.data;
        } else {
          errorSendLeads.value =
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        if (AgencyColleagueAccessHelper.isAgencyAccessDenied(response)) {
          isSentAccessDenied.value = true;
          sendLead.value = null;
        }
        errorSendLeads.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      errorSendLeads.value = e.toString();
    } finally {
      isLoadingSendLeads.value = false;
    }
  }

  final RxBool isLoadingDeleteLead = false.obs;
  final RxString errorDeleteLead = ''.obs;
  final Rx<ModelReceiveLeadDelete?> receiveLeadDelete =
      Rx<ModelReceiveLeadDelete?>(null);

  Future<void> deleteReceivedLead(
      {int? leadId, required List<Map<String, Object?>> lostReasons}) async {
    if (!AgencyColleagueAccessHelper.guardEdit(
        mainController.profile.value?.data,
        AgencyPermission.leadsReceived)) {
      return;
    }
    try {
      isLoadingDeleteLead.value = true;
      errorDeleteLead.value = '';

      final response = await RESTAuth.deleteReceivedLead(
        leadId: leadId,
        lostReasons: lostReasons,
      );

      if (response is ApiSuccess<ModelReceiveLeadDelete>) {
        if (response.data.status == true) {
          receiveLeadDelete.value = response.data;

          // await getLeads();
        } else {
          errorDeleteLead.value =
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        errorDeleteLead.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      errorDeleteLead.value = e.toString();
    } finally {
      isLoadingDeleteLead.value = false;
    }
  }

  Future<void> deleteSentLead({required int leadId}) async {
    if (!AgencyColleagueAccessHelper.guardEdit(
        mainController.profile.value?.data, AgencyPermission.leadsSent)) {
      return;
    }
    try {
      isLoadingDeleteLead.value = true;
      errorDeleteLead.value = '';

      final response = await RESTAuth.deleteSentLead(leadId: leadId);

      if (response is ApiSuccess<ModelCommon>) {
        if (response.data.status != true) {
          errorDeleteLead.value =
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        errorDeleteLead.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      errorDeleteLead.value = e.toString();
    } finally {
      isLoadingDeleteLead.value = false;
    }
  }

  final RxBool isLoadingRequestToUpdateLead = false.obs;
  final RxString errorRequestToUpdateLead = ''.obs;
  Future<void> requestToUpdateLead({
    int? leadId,
  }) async {
    if (!AgencyColleagueAccessHelper.guardEdit(
        mainController.profile.value?.data, AgencyPermission.leadsSent)) {
      return;
    }
    try {
      isLoadingRequestToUpdateLead.value = true;
      errorRequestToUpdateLead.value = '';

      final response = await RESTAuth.requestToUpdateLead(
        leadId: leadId,
      );

      if (response is ApiSuccess<ModelCommon>) {
        if (response.data.status == true) {
          if (Get.context != null) {
            showDialog(
              context: Get.context!,
              builder: (context) => SuccessPopup(
                message: response.data.message ?? '',
                onOk: () async {
                  await getSendLeads();
                  Get.back();
                },
              ),
              barrierDismissible: false,
            );
          }

          // await getLeads();
        } else {
          showDialog(
            context: Get.context!,
            builder: (context) => SuccessPopup(
              message: response.data.message ?? '',
              onOk: () async {
                await getSendLeads();
                Get.back();
              },
            ),
            barrierDismissible: false,
          );
          errorRequestToUpdateLead.value =
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        errorRequestToUpdateLead.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      errorRequestToUpdateLead.value = e.toString();
    } finally {
      isLoadingRequestToUpdateLead.value = false;
    }
  }

  Future<void> sendLeadComment({
    required int id,
    required String comment,
    required int leadId,
    String? name,
    required int leadLength,
    required int parentIndex,
    required int stepIndex,
  }) async {
    final permission = isLeadsReceived.value
        ? AgencyPermission.leadsReceived
        : AgencyPermission.leadsSent;
    if (!AgencyColleagueAccessHelper.guardEdit(
        mainController.profile.value?.data, permission)) {
      return;
    }
    try {
      isLoadingComment.value = true;
      errorComment.value = '';

      final response = await RESTAuth.sendLeadComment(
        id: id,
        comment: comment,
        leadId: leadId,
        name: name,
      );

      if (response is ApiSuccess) {
        if (response.data.status == true) {
          readRequestToUpdateLeadNotification();
          if (comment.trim().isNotEmpty) {
            _updateLocalLeadTrackComment(trackId: id, comment: comment);
          }
          final bool isLastStep =
              leadLength > 0 && stepIndex >= 0 && stepIndex == leadLength - 2;

          if (isLastStep) {
            showStepCompletedFlow(
              stepId: id,
              leadId: leadId,
              successMessage: response.data.message ?? '',
              parentIndex: parentIndex,
              stepIndex: stepIndex,
            );
          }
        } else {
          errorComment.value =
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        errorComment.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      errorComment.value = e.toString();
    } finally {
      isLoadingComment.value = false;
    }
  }

  void showStepCompletedFlow({
    required int stepId,
    required int leadId,
    required String successMessage,
    int? parentIndex,
    int? stepIndex,
  }) {
    final context = Get.context;
    if (context == null) {
      return;
    }

    final currencySymbol =
        (AppPreference.readString(AppPreference.paymentCurrency) ?? '€').trim();
    final resolvedSymbol = currencySymbol.isNotEmpty ? currencySymbol : '€';

    String? existingRevenue;
    String? existingCommission;
    String? businessReferrerName;
    String? referrerAvatarUrl;

    if (receivedLead.value?.data != null) {
      for (var lead in receivedLead.value!.data!) {
        if (lead.id == leadId.toString()) {
          // Get business referrer name and avatar URL
          if (lead.user != null) {
            final name =
                '${lead.user!.firstName ?? ''} ${lead.user!.lastName ?? ''}'
                    .trim();
            businessReferrerName = name.isEmpty ? null : name;
            referrerAvatarUrl = lead.user!.avatarUrl;
          }

          if (lead.leadTrack != null) {
            for (var track in lead.leadTrack!) {
              if (track.commisionValue != null &&
                  track.commisionValue!.isNotEmpty &&
                  track.commisionValue != 'null' &&
                  track.revenue != null &&
                  track.revenue!.isNotEmpty &&
                  track.revenue != 'null') {
                existingRevenue = track.revenue;
                existingCommission = track.commisionValue;
                break;
              }
            }
          }
          break;
        }
      }
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => MarkLeadSuccessPopup(
              currencySymbol: resolvedSymbol,
              stepId: stepId,
              leadId: leadId,
              initialRevenue: existingRevenue,
              initialCommission: existingCommission,
              businessReferrerName: businessReferrerName,
              referrerAvatarUrl: referrerAvatarUrl,
              onSubmit:
                  (turnover, commission, netIncome, markLeadSuccessMessage) {
                _getLeadTrackMeta(stepId: stepId);
                sendLeadComment(
                  id: int.parse(receivedLead.value?.data?[parentIndex!]
                          .leadTrack?[stepIndex! + 1].id
                          .toString() ??
                      '0'),
                  comment: "",
                  leadId: int.parse(receivedLead.value?.data?[parentIndex!]
                          .leadTrack?[stepIndex! + 1].leadId
                          .toString() ??
                      '0'),
                  leadLength: receivedLead
                          .value?.data?[parentIndex!].leadTrack?.length ??
                      0,
                  parentIndex: parentIndex!,
                  stepIndex: stepIndex! + 1,
                ).then((value) {
                  Get.dialog(
                    SuccessPopup(
                      message: markLeadSuccessMessage,
                      onOk: () {
                        Get.back();
                        getLeads();
                      },
                    ),
                    barrierDismissible: false,
                  );
                });
              },
            )
        //  StepCompletedPopup(
        //   onMarkAsSuccessful: () {
        //     Future.microtask(() {
        //       final nextContext = Get.context;
        //       if (nextContext == null) return;
        //       AppHelper.showLog("stepId: ${receivedLead
        //                                           .value
        //                                           ?.data?[parentIndex!]
        //                                           .leadTrack?[stepIndex!+1]
        //                                           .id
        //                                           .toString() }");
        //       AppHelper.showLog("leadId: ${receivedLead
        //                                           .value
        //                                           ?.data?[parentIndex!]
        //                                           .leadTrack?[stepIndex!+1]
        //                                           .leadId
        //                                           .toString() }");

        //       showDialog(
        //         context: nextContext,
        //         barrierDismissible: false,
        //         builder: (_) => MarkLeadSuccessPopup(
        //           currencySymbol: resolvedSymbol,
        //           stepId: stepId,
        //           leadId: leadId,
        //           initialRevenue: existingRevenue,
        //           initialCommission: existingCommission,
        //           onSubmit:
        //               (turnover, commission, netIncome, markLeadSuccessMessage) {
        //             final trackMeta = _getLeadTrackMeta(stepId: stepId);
        //           sendLeadComment(
        //                                   id: int.parse(receivedLead
        //                                           .value
        //                                           ?.data?[parentIndex!]
        //                                           .leadTrack?[stepIndex!+1]
        //                                           .id
        //                                           .toString() ??
        //                                       '0'),
        //                                   comment: "",
        //                                   leadId: int.parse(receivedLead
        //                                           .value
        //                                           ?.data?[parentIndex!]
        //                                           .leadTrack?[stepIndex!+1]
        //                                           .leadId
        //                                           .toString() ??
        //                                       '0'),
        //                                   leadLength:receivedLead
        //                                           .value
        //                                           ?.data?[parentIndex!]
        //                                           .leadTrack
        //                                           ?.length ??
        //                                       0,
        //                                   parentIndex: parentIndex!,
        //                                   stepIndex: stepIndex!+1,
        //                                 ).then((value) {
        //               Get.dialog(
        //                 SuccessPopup(
        //                   message: markLeadSuccessMessage,
        //                   onOk: () {
        //                     Get.back();
        //                     getLeads();
        //                   },
        //                 ),
        //                 barrierDismissible: false,
        //               );
        //             });
        //           },
        //         ),
        //       );
        //     });
        //   },
        //   onNotNow: () {
        //     if (successMessage.isNotEmpty) {
        //       Get.dialog(
        //         SuccessPopup(
        //           message: successMessage,
        //           onOk: () {
        //             getLeads();
        //             Get.back();
        //           },
        //         ),
        //         barrierDismissible: false,
        //       );
        //     } else {
        //       getLeads();
        //     }
        //   },
        // ),
        );
  }

  void _updateLocalLeadTrackComment({
    required int trackId,
    required String comment,
    bool replaceLatest = false,
  }) {
    final leads = receivedLead.value?.data;
    if (leads == null || comment.trim().isEmpty) {
      return;
    }

    final trackIdStr = trackId.toString();
    final now = DateTime.now().toUtc();
    final formattedTime = '${now.toIso8601String().split('.').first}.000000Z';

    for (final lead in leads) {
      final trackList = lead.leadTrack;
      if (trackList == null) continue;

      for (final track in trackList) {
        if (track.id == trackIdStr) {
          track.comments ??= [];
          final shouldReplaceLatest =
              replaceLatest && (track.comments?.isNotEmpty ?? false);

          if (shouldReplaceLatest) {
            final latest = track.comments!.last;
            latest.comment = comment;
            latest.createdAt = formattedTime;
          } else {
            track.comments!.add(
              Comments(
                id: null,
                leadTrackId: int.tryParse(track.id ?? ''),
                comment: comment,
                createdAt: formattedTime,
              ),
            );
          }
          receivedLead.refresh();
          return;
        }
      }
    }
  }

  _LeadTrackMeta? _getLeadTrackMeta({required int stepId}) {
    final leads = receivedLead.value?.data;
    if (leads == null) {
      return null;
    }

    for (int parentIndex = 0; parentIndex < leads.length; parentIndex++) {
      final trackList = leads[parentIndex].leadTrack;
      if (trackList == null || trackList.isEmpty) {
        continue;
      }

      for (int stepIndex = 0; stepIndex < trackList.length; stepIndex++) {
        final track = trackList[stepIndex];
        final parsedId = int.tryParse(track.id ?? '');
        if (parsedId == stepId) {
          return _LeadTrackMeta(
            leadLength: trackList.length,
            parentIndex: parentIndex,
            stepIndex: stepIndex,
          );
        }
      }
    }

    return null;
  }

  Future<void> editLeadComment({
    required int id,
    required String comment,
    required int leadId,
    String? name,
  }) async {
    try {
      isLoadingComment.value = true;
      errorComment.value = '';

      final response = await RESTAuth.editLeadComment(
        id: id,
        comment: comment,
        leadId: leadId,
        name: name,
      );

      if (response is ApiSuccess) {
        if (response.data.status == true) {
          readRequestToUpdateLeadNotification();
          _updateLocalLeadTrackComment(
            trackId: id,
            comment: comment,
            replaceLatest: true,
          );

          if (Get.context != null) {
            showDialog(
              context: Get.context!,
              builder: (context) => SuccessPopup(
                message: response.data.message ?? '',
                onOk: () async {
                  Get.back();
                  // Refresh data after dialog closes
                  await getLeads();
                },
              ),
              barrierDismissible: false,
            );
          }
        } else {
          if (Get.context != null) {
            showDialog(
              context: Get.context!,
              builder: (context) => SuccessPopup(
                message: response.data.message ?? '',
                onOk: () async {
                  Get.back();
                  // Refresh data after dialog closes
                  await getLeads();
                },
              ),
              barrierDismissible: false,
            );
          }
          errorComment.value =
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        errorComment.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      errorComment.value = e.toString();
    } finally {
      isLoadingComment.value = false;
    }
  }

  Future<void> addCommisionAmount({
    required int id,
    required String amount,
    required int leadId,
    required String revenue,
    String? name,
  }) async {
    try {
      isLoadingComment.value = true;
      errorComment.value = '';

      final response = await RESTAuth.addCommisionAmount(
        id: id,
        amount: amount,
        leadId: leadId,
        revenue: revenue,
        name: "Payment received",
      );

      if (response is ApiSuccess) {
        if (response.data.status == true) {
          readRequestToUpdateLeadNotification();
          // Update local state directly instead of calling getLeads()
          // Find and update the specific step's commission value in the local data
          if (receivedLead.value?.data != null) {
            for (int i = 0; i < receivedLead.value!.data!.length; i++) {
              final lead = receivedLead.value!.data![i];
              if (lead.leadTrack != null) {
                for (int j = 0; j < lead.leadTrack!.length; j++) {
                  final step = lead.leadTrack![j];
                  if (step.id == id) {
                    step.commisionValue = amount;
                    receivedLead.refresh();
                    break;
                  }
                }
              }
            }
          }

          if (Get.context != null) {
            showDialog(
              context: Get.context!,
              builder: (context) => SuccessPopup(
                message: response.data.message ?? '',
                onOk: () {
                  Get.back();
                },
              ),
              barrierDismissible: false,
            );
          }
        } else {
          errorComment.value =
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        errorComment.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      errorComment.value = e.toString();
    } finally {
      isLoadingComment.value = false;
    }
  }

  Future<void> updateLeadStatus({
    required int leadId,
    required int currentStep,
  }) async {
    try {
      isLoadingComment.value = true;
      errorComment.value = '';

      final response = await RESTAuth.updateLeadStatus(
        leadId: leadId,
        currentStep: currentStep + 1, // Move to next step
      );

      if (response is ApiSuccess) {
        if (response.data.status == true) {
          readRequestToUpdateLeadNotification();
          // Refresh the leads list after successful status update
          await getLeads();
          await getSendLeads();
        } else {
          errorComment.value =
              response.data.message ?? tr(LanguageKeys.somethingWentWrong);
        }
      } else if (response is ApiFailure) {
        errorComment.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      errorComment.value = e.toString();
    } finally {
      isLoadingComment.value = false;
    }
  }

  Future<void> readReceivedLeadNotification() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await RESTAuth.readNotification(type: "lead_receive");

      if (response is ApiSuccess<ModelReadNotification>) {
        if (response.data.status == true) {
          await mainController.getDashboard();
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

  Future<void> readSendLeadNotification() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await RESTAuth.readNotification(type: "lead_sent");

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

  Future<void> readRequestToUpdateLeadNotification() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response =
          await RESTAuth.readNotification(type: "request_to_update_lead");

      if (response is ApiSuccess<ModelReadNotification>) {
        if (response.data.status == true) {
          // Immediately hide badges locally for a responsive UI
          if (receivedLead.value?.data != null) {
            for (final lead in receivedLead.value!.data!) {
              lead.notificationCount = "0";
            }
            receivedLead.refresh();

            update();
          }
          await getLeads();
          await mainController.getDashboard();
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

  final RxBool isLoadingLeadOpened = false.obs;
  final RxString errorLeadOpened = ''.obs;

  Future<void> leadOpened(int leadId) async {
    try {
      isLoadingLeadOpened.value = true;
      errorLeadOpened.value = '';
      final response = await RESTAuth.leadOpened(leadId: leadId.toString());
      if (response is ApiSuccess) {
        await getLeads();
      } else if (response is ApiFailure) {
        errorLeadOpened.value =
            response.error.message ?? tr(LanguageKeys.somethingWentWrong);
      }
    } catch (e) {
      errorLeadOpened.value = e.toString();
    } finally {
      isLoadingLeadOpened.value = false;
    }
  }
}

class _LeadTrackMeta {
  final int leadLength;
  final int parentIndex;
  final int stepIndex;

  const _LeadTrackMeta({
    required this.leadLength,
    required this.parentIndex,
    required this.stepIndex,
  });
}
