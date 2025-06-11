import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

import '../../controller/controller_archeivvelist.dart';
import '../../widgets/custom_app_bar.dart';

class ArchiveList extends GetView<ArcheiveListController> {
  const ArchiveList({super.key});
  static String pageId = '/screenArcheiev';

  String _formatCreatedAt(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  String _extractLostReason(String? lostReasonStr) {
    if (lostReasonStr == null || lostReasonStr.isEmpty) return '';
    try {
      final List<dynamic> reasons = (lostReasonStr.startsWith('['))
          ? List<dynamic>.from(jsonDecode(lostReasonStr))
          : [];
      if (reasons.isNotEmpty && reasons[0]['reason'] != null) {
        return reasons[0]['reason'];
      }
      return '';
    } catch (e) {
      return '';
    }
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: stylePoppins(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          if ((label == tr(LanguageKeys.email) &&
                  value.isNotEmpty &&
                  value != "Not Provided") ||
              (label == tr(LanguageKeys.phoneNumber) && value.isNotEmpty))
            GestureDetector(
              onTap: () async {
                if (label == tr(LanguageKeys.email)) {
                  final Uri emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: value,
                  );
                  if (await canLaunchUrl(emailLaunchUri)) {
                    await launchUrl(emailLaunchUri);
                  }
                } else if (label == tr(LanguageKeys.phoneNumber)) {
                  final Uri phoneLaunchUri = Uri(
                    scheme: 'tel',
                    path: value,
                  );
                  if (await canLaunchUrl(phoneLaunchUri)) {
                    await launchUrl(phoneLaunchUri);
                  }
                }
              },
              child: Text(
                value,
                style: stylePoppins(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            )
          else
            Text(
              value,
              style: stylePoppins(
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(
        title: tr(LanguageKeys.archive),
        actions: [
          PopupMenuButton<bool>(
            icon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SvgPicture.asset(
                controller.isAssending.value
                    ? AppAssets.imgSortAes
                    : AppAssets.imgSortDes,
                colorFilter:
                    ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                height: 32,
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: AppColors.whiteColor,
            offset: const Offset(0, 40),
            itemBuilder: (context) => [
              PopupMenuItem<bool>(
                value: false,
                child: Text(
                  tr(LanguageKeys.newest),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: !controller.isAssending.value
                        ? AppColors.primary
                        : AppColors.fontBlack,
                  ),
                ),
              ),
              PopupMenuItem<bool>(
                value: true,
                child: Text(
                  tr(LanguageKeys.oldest),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: controller.isAssending.value
                        ? AppColors.primary
                        : AppColors.fontBlack,
                  ),
                ),
              ),
            ],
            onSelected: (value) {
              controller.isAssending.value = value;
              controller.getArchiveList(order: value ? "desc" : "asc");
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => controller.isLoading.value
              ? Center(
                  child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2.5,
                      )))
              : (controller.archiveList.value?.data?.length == 0
                  ? Center(
                      child: Text(
                      tr(LanguageKeys.noArchive),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ))
                  : ListView.builder(
                      itemCount:
                          controller.archiveList.value?.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final item = controller.archiveList.value?.data?[index];
                        final isLost = item?.isLost == '1';
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            color: const Color(0xFFF8FBFD),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: AppColors.primary,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8))),
                                        child: Icon(Icons.person,
                                            color: Colors.white, size: 32),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "${item?.firstName ?? ''} ${item?.lastName ?? ''}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              "${item?.user?.firstName ?? ''} ${item?.user?.lastName ?? ''}",
                                              style: const TextStyle(
                                                  color: Colors.grey)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Text('Label:- ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Icon(
                                        isLost
                                            ? Icons.cancel
                                            : Icons.check_circle,
                                        color:
                                            isLost ? Colors.red : Colors.green,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        isLost
                                            ? "Lost"
                                            : tr(LanguageKeys.success),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Text('Date:-   ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          _formatCreatedAt(
                                              item?.createdAt ?? ''),
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                  if (isLost) ...[
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Text('Reason:-   ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Expanded(
                                          child: Text(
                                              _extractLostReason(
                                                  item?.lostReason),
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w600)),
                                        ),
                                      ],
                                    ),
                                  ],
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment: isLost
                                        ? MainAxisAlignment.spaceBetween
                                        : MainAxisAlignment.center,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () {
                                          showModalBottomSheet(
                                            backgroundColor: Colors.white,
                                            context: context,
                                            isScrollControlled: true,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(30)),
                                            ),
                                            builder: (context) {
                                              return SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.4,
                                                width: Get.width,
                                                child: Padding(
                                                  padding: EdgeInsets.all(24.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          Center(
                                                            child: Text(
                                                              tr(LanguageKeys
                                                                  .description),
                                                              style: stylePoppins(
                                                                  fontSize: 24,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          Positioned(
                                                            right: 0,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(),
                                                              child: Icon(
                                                                Icons.close,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      _infoRow(
                                                          tr(LanguageKeys
                                                              .phoneNumber),
                                                          item?.phoneNumber ??
                                                              ''),
                                                      _infoRow(
                                                          tr(LanguageKeys
                                                              .email),
                                                          "${item?.email ?? ''} ${item?.lastName ?? ''}"),
                                                      _infoRow(
                                                          tr(LanguageKeys
                                                              .fullName),
                                                          "${item?.firstName ?? ''} ${item?.lastName ?? ''}"),
                                                      _infoRow(
                                                          tr(LanguageKeys
                                                              .description),
                                                          item?.description ??
                                                              ''),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                            color: AppColors.primary,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                            tr(LanguageKeys.seeDescription),
                                            style: stylePoppins(
                                                color: AppColors.primary,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                      if (isLost) ...[
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: () {
                                              controller.recoverArchiveLead(
                                                  leadId: item?.id ?? '');
                                            },
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(
                                                color: AppColors.primary,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: Obx(
                                              () => controller.loadingStates[
                                                          item?.id] ==
                                                      true
                                                  ? const Center(
                                                      child: SizedBox(
                                                          height: 24,
                                                          width: 24,
                                                          child:
                                                              CircularProgressIndicator()),
                                                    )
                                                  : Text("Recover",
                                                      style: stylePoppins(
                                                          color:
                                                              AppColors.primary,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600)),
                                            ),
                                          ),
                                        ),
                                      ]
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )),
        ),
      ),
    );
  }
}
