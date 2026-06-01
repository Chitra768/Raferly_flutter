import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/controller/send_notification_controller.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/logo_loader.dart';

import '../resources/app_assets.dart';

class SendNotificationScreen extends GetView<SendNotificationController> {
  static String pageId = '/sendNotification';

  const SendNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.slate900),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          tr(LanguageKeys.sendNotification),
          style: const TextStyle(
            color: AppColors.slate900,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        surfaceTintColor: AppColors.whiteColor,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.textFieldColor),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: controller.formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _titleCard(),
                    const SizedBox(height: 16),
                    _descriptionCard(),
                    const SizedBox(height: 16),
                    _sendToCard(),
                    const SizedBox(height: 16),
                    _previewCard(),
                    const SizedBox(height: 16),
                    _summaryCard(),
                    // const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          _bottomBar(),
        ],
      ),
    );
  }

  Widget _titleCard() {
    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr(LanguageKeys.sendNotifCardTitle),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppColors.slate900,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller.titleController,
            maxLength: SendNotificationController.titleMax,
            buildCounter: (_, {required currentLength, maxLength, required isFocused}) =>
                const SizedBox.shrink(),
            decoration: InputDecoration(
              hintText: tr(LanguageKeys.sendNotifTitleHint),
              hintStyle: const TextStyle(
                color: AppColors.gray400,
                fontSize: 14,
              ),
              filled: true,
              fillColor: AppColors.gray50,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.textFieldColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.textFieldColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.purple500, width: 1.2),
              ),
            ),
            validator: controller.validateTitle,
          ),
          const SizedBox(height: 8),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tr(LanguageKeys.sendNotifTitleHelper),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.k6B7280,
                    ),
                  ),
                  Text(
                    '${controller.titleLen.value}/${SendNotificationController.titleMax}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.purple500,
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _descriptionCard() {
    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr(LanguageKeys.description),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppColors.slate900,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller.descriptionController,
            maxLength: SendNotificationController.descMax,
            minLines: 4,
            maxLines: 6,
            buildCounter: (_, {required currentLength, maxLength, required isFocused}) =>
                const SizedBox.shrink(),
            decoration: InputDecoration(
              hintText: tr(LanguageKeys.sendNotifDescHint),
              hintStyle: const TextStyle(
                color: AppColors.gray400,
                fontSize: 14,
              ),
              alignLabelWithHint: true,
              filled: true,
              fillColor: AppColors.gray50,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.textFieldColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.textFieldColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.purple500, width: 1.2),
              ),
            ),
            validator: controller.validateDescription,
          ),
          const SizedBox(height: 8),
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tr(LanguageKeys.sendNotifDescHelper),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.k6B7280,
                    ),
                  ),
                  Text(
                    '${controller.descLen.value}/${SendNotificationController.descMax}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.purple500,
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget _sendToCard() {
    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr(LanguageKeys.sendNotifSendTo),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppColors.slate900,
            ),
          ),
          const SizedBox(height: 16),
          _recipientOption(
            mode: SendNotificationRecipientMode.allNetwork,
            title: tr(LanguageKeys.sendNotifAllUsers),
            subtitle: tr(LanguageKeys.sendNotifAllUsersSub),
            icon: AppAssets.imgGroup,
          ),
          const SizedBox(height: 12),
          _recipientOption(
            mode: SendNotificationRecipientMode.specificDeals,
            title: tr(LanguageKeys.sendNotifDeals),
            subtitle: tr(LanguageKeys.sendNotifDealsSub),
            icon: AppAssets.imgHandShake,
          ),
          const SizedBox(height: 12),
          _recipientOption(
            mode: SendNotificationRecipientMode.specificUsers,
            title: tr(LanguageKeys.sendNotifUsers),
            subtitle: tr(LanguageKeys.sendNotifUsersSub),
            icon: AppAssets.imgSuccessfulLeads,
          ),
        ],
      ),
    );
  }

  void _onRecipientTap(SendNotificationRecipientMode mode) {
    if (controller.recipientMode.value == mode) {
      controller.reopenPickerForCurrentMode();
    } else {
      controller.setRecipientMode(mode);
    }
  }

  Widget _recipientOption({
    required SendNotificationRecipientMode mode,
    required String title,
    required String subtitle,
    required String icon,
  }) {
    return Obx(() {
      final selected = controller.recipientMode.value == mode;
      return Material(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _onRecipientTap(mode),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? AppColors.purple500 : Colors.transparent,
                width: 2,
              ),
            ),
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Radio<SendNotificationRecipientMode>(
                    value: mode,
                    groupValue: controller.recipientMode.value,
                    activeColor: AppColors.purple500,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    onChanged: (v) {
                      if (v != null) _onRecipientTap(v);
                    },
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.slate900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.35,
                          color: AppColors.k6B7280,
                        ),
                      ),
                    ],
                  ),
                ),
                // Icon(icon, color: AppColors.purple500, size: 22),
                SvgPicture.asset(icon,
                    width: 22,
                    height: 22,
                    colorFilter: const ColorFilter.mode(AppColors.purple500, BlendMode.srcIn)),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _previewCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFAF5FF),
            Color(0xFFF3E8FF),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9D5FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tr(LanguageKeys.sendNotifPreview),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF581C87),
                ),
              ),
              const Icon(
                Icons.visibility,
                size: 18,
                color: AppColors.purple500,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListenableBuilder(
            listenable: Listenable.merge([
              controller.titleController,
              controller.descriptionController,
            ]),
            builder: (context, _) {
              final t = controller.titleController.text.trim();
              final d = controller.descriptionController.text.trim();
              final titleText = t.isEmpty ? tr(LanguageKeys.sendNotifPreviewTitleEmpty) : t;
              final bodyText = d.isEmpty ? tr(LanguageKeys.sendNotifPreviewBodyEmpty) : d;
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.purple500,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titleText,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: AppColors.slate900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            bodyText,
                            style: const TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              color: AppColors.detailsTextColor,
                            ),
                          ),
                          // const SizedBox(height: 4),
                          // Text(
                          //   tr(LanguageKeys.sendNotifPreviewJustNow),
                          //   style: const TextStyle(
                          //     fontSize: 12,
                          //     color: AppColors.gray400,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _summaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF5FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9D5FF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFF3E8FF),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              AppAssets.imgInfoSvg,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(AppColors.purple500, BlendMode.srcIn),
            ),
            // child: const Icon(
            //   Icons.info_outline_rounded,
            //   color: AppColors.purple500,
            //   size: 20,
            // ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr(LanguageKeys.sendNotifSummaryTitle),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xFF581C87),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.recipientSummaryText(),
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.35,
                        color: Color(0xFF7E22CE),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget _bottomBar() {
    return Material(
      color: Colors.white,
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.purple500,
                        shadowColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: controller.isLoading.value ? null : controller.submit,
                      child: controller.isLoading.value
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: LogoLoader(color: AppColors.whiteColor),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.send_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  tr(LanguageKeys.sendNotifSendCta),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  )),
              const SizedBox(height: 12),
              Text(
                tr(LanguageKeys.sendNotifDisclaimer),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.k6B7280,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _whiteCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }
}
