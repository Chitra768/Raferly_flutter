import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/share_popup.dart';
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
                                        child: Image.asset(
                                          AppAssets.imgDefaultPerson,
                                          width: 32,
                                          height: 32,
                                          fit: BoxFit.cover,
                                        ),
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
                                      Text(
                                          tr(LanguageKeys.lableArchive) + ':- ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Icon(
                                        isLost
                                            ? Icons.cancel
                                            : Icons.check_circle,
                                        color:
                                            isLost ? Colors.red : Colors.green,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        isLost
                                            ? tr(LanguageKeys.lost)
                                            : tr(LanguageKeys.success),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                          tr(LanguageKeys.dateArchive) +
                                              ':-   ',
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
                                        Text(tr(LanguageKeys.reason) + ':-',
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
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom,
                                                ),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                    30)),
                                                  ),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        // Top bar with title and close button
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const SizedBox(
                                                                width:
                                                                    40), // For alignment
                                                            Text(
                                                              tr(LanguageKeys
                                                                  .description),
                                                              style: stylePoppins(
                                                                  fontSize: 24,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            IconButton(
                                                              icon: const Icon(
                                                                  Icons.close,
                                                                  color: Colors
                                                                      .grey),
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 16),
                                                        // Action buttons
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Container(
                                                                  height: 48,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: AppColors
                                                                        .primary,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .person_add,
                                                                        color: AppColors
                                                                            .whiteColor,
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Text(
                                                                        tr(LanguageKeys
                                                                            .addContact),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        maxLines:
                                                                            2,
                                                                        style: stylePoppins(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                      ),
                                                                    ],
                                                                  )),
                                                            ),
                                                            const SizedBox(
                                                                width: 12),
                                                            Expanded(
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  Get.dialog(
                                                                    SharePopup(
                                                                      title:
                                                                          item?.firstName ??
                                                                              '',
                                                                      link: item
                                                                              ?.firstName ??
                                                                          '',
                                                                    ),
                                                                  );
                                                                },
                                                                child:
                                                                    Container(
                                                                        height:
                                                                            48,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              AppColors.primary,
                                                                          borderRadius:
                                                                              BorderRadius.circular(12),
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Icon(
                                                                              Icons.share,
                                                                              color: AppColors.whiteColor,
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Text(
                                                                              tr(LanguageKeys.share),
                                                                              textAlign: TextAlign.center,
                                                                              maxLines: 2,
                                                                              style: stylePoppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                                                                            ),
                                                                          ],
                                                                        )),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 24),
                                                        // Card with details
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(20),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                Colors.grey[50],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            boxShadow: const [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black12,
                                                                blurRadius: 8,
                                                                offset: Offset(
                                                                    0, 2),
                                                              ),
                                                            ],
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              _infoTile(
                                                                  Icons.person,
                                                                  tr(LanguageKeys
                                                                      .name),
                                                                  "${item?.firstName ?? ''} ${item?.lastName ?? ''}"),
                                                              const Divider(),
                                                              _infoTile(
                                                                  Icons
                                                                      .business,
                                                                  tr(LanguageKeys
                                                                      .nameOfTheBusinessReferrer),
                                                                  "${item?.user?.firstName ?? ''} ${item?.user?.lastName ?? ''}"),
                                                              const Divider(),
                                                              _infoTile(
                                                                  Icons.phone,
                                                                  tr(LanguageKeys
                                                                      .phoneNumber),
                                                                  item?.phoneNumber ??
                                                                      ''),
                                                              const Divider(),
                                                              _infoTile(
                                                                  Icons.email,
                                                                  tr(LanguageKeys
                                                                      .email),
                                                                  item?.email ??
                                                                      ''),
                                                              const Divider(),
                                                              _infoTile(
                                                                  Icons
                                                                      .description,
                                                                  tr(LanguageKeys
                                                                      .description),
                                                                  item?.description ??
                                                                      ''),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
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
                                                fontSize: 13,
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
                                                  : Text(
                                                      tr(LanguageKeys.recover),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: stylePoppins(
                                                          color:
                                                              AppColors.primary,
                                                          fontSize: 13,
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

// Helper widget for info row
  Widget _infoTile(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: stylePoppins(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 2),
              if (label == tr(LanguageKeys.phoneNumber) &&
                  value.isNotEmpty &&
                  value != "Not Provided")
                GestureDetector(
                  onTap: () async {
                    final Uri phoneLaunchUri = Uri(
                      scheme: 'tel',
                      path: value,
                    );
                    if (await canLaunchUrl(phoneLaunchUri)) {
                      await launchUrl(phoneLaunchUri);
                    }
                  },
                  child: Text(
                    value,
                    style: stylePoppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: AppColors.primary,
                    ).copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              else if (label == tr(LanguageKeys.email) &&
                  value.isNotEmpty &&
                  value != "Not Provided")
                GestureDetector(
                  onTap: () async {
                    final Uri emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: value,
                    );
                    if (await canLaunchUrl(emailLaunchUri)) {
                      await launchUrl(emailLaunchUri);
                    }
                  },
                  child: Text(
                    value,
                    style: stylePoppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: AppColors.primary,
                    ).copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                )
              else
                Text(
                  value,
                  style: stylePoppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
