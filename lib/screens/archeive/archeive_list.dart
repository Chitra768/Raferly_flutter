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

import '../../controller/controller_archeivvelist.dart';
import '../../widgets/custom_app_bar.dart';

class ArchiveList extends GetView<ArcheiveListController> {
  const ArchiveList({super.key});
  static String pageId = '/screenArcheiev';

  String _formatCreatedAt(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM d | hh:mm a').format(date);
    } catch (e) {
      return dateStr;
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
          if (label == tr(LanguageKeys.email) &&
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
              ? const Center(child: CircularProgressIndicator())
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
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              controller
                                                      .archiveList
                                                      .value
                                                      ?.data?[index]
                                                      .firstName ??
                                                  '',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              controller.archiveList.value
                                                      ?.data?[index].email ??
                                                  '',
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
                                      Icon(Icons.check_circle,
                                          color: Colors.green),
                                      SizedBox(width: 4),
                                      Text(tr(LanguageKeys.success),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Text('Date:-   ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          _formatCreatedAt(controller
                                                  .archiveList
                                                  .value
                                                  ?.data?[index]
                                                  .createdAt ??
                                              ''),
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Center(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          backgroundColor: Colors.white,
                                          context: context,
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
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
                                                      CrossAxisAlignment.start,
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
                                                        controller
                                                                .archiveList
                                                                .value
                                                                ?.data?[index]
                                                                .phoneNumber ??
                                                            ''),
                                                    _infoRow(
                                                        tr(LanguageKeys.email),
                                                        "${controller.archiveList.value?.data?[index].email ?? ''} ${controller.archiveList.value?.data?[index].lastName ?? ''}"),
                                                    _infoRow(
                                                        tr(LanguageKeys
                                                            .fullName),
                                                        "${controller.archiveList.value?.data?[index].firstName ?? ''} ${controller.archiveList.value?.data?[index].lastName ?? ''}"),
                                                    _infoRow(
                                                        tr(LanguageKeys
                                                            .description),
                                                        controller
                                                                .archiveList
                                                                .value
                                                                ?.data?[index]
                                                                .description ??
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
                                          style: TextStyle(
                                              color: AppColors.primary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600)),
                                    ),
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
