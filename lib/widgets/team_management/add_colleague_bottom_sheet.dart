import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/add_colleague_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_team_member.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/job_selection_field.dart';

/// Add colleague invite form — Figma flow 3826:12378–12384.
class AddColleagueBottomSheet extends StatelessWidget {
  const AddColleagueBottomSheet({super.key});

  /// Matches default [Get.bottomSheet] / modal route close animation.
  static const Duration _closeAnimationDelay = Duration(milliseconds: 350);

  static Future<bool?> show() async {
    Get.put(AddColleagueController());

    try {
      return await Get.bottomSheet<bool>(
        const AddColleagueBottomSheet(),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        isDismissible: true,
        enableDrag: true,
        ignoreSafeArea: false,
      );
    } finally {
      // Let the sheet finish its exit animation before disposing controllers.
      await Future.delayed(_closeAnimationDelay);
      if (Get.isRegistered<AddColleagueController>()) {
        Get.delete<AddColleagueController>();
      }
    }
  }

  AddColleagueController get controller => Get.find<AddColleagueController>();

  @override
  Widget build(BuildContext context) {
    // final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.92,
        ),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _sheetHeader(),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _field(
                        label: tr(LanguageKeys.firstName),
                        controller: controller.firstNameController,
                        hint: tr(LanguageKeys.enterFirstName),
                        validator: (v) => controller.validateRequired(
                          v,
                          LanguageKeys.pleaseEnterFirstName,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _field(
                        label: tr(LanguageKeys.lastName),
                        controller: controller.lastNameController,
                        hint: tr(LanguageKeys.enterLastName),
                        validator: (v) => controller.validateRequired(
                          v,
                          LanguageKeys.pleaseEnterLastName,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _field(
                        label: tr(LanguageKeys.emailAddress),
                        controller: controller.emailController,
                        hint: tr(LanguageKeys.teamManagementColleagueEmailHint),
                        keyboardType: TextInputType.emailAddress,
                        validator: controller.validateEmail,
                      ),
                      const SizedBox(height: 16),
                      _field(
                        label: tr(LanguageKeys.phoneNumber),
                        controller: controller.phoneController,
                        hint: tr(LanguageKeys.teamManagementColleaguePhoneHint),
                        keyboardType: TextInputType.phone,
                        validator: (v) => controller.validateRequired(
                          v,
                          LanguageKeys.pleaseEnterPhoneNumber,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        tr(LanguageKeys.teamManagementAccessType),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.teamTitle,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Obx(() => _accessTypeRow()),
                      Obx(() {
                        if (controller.memberType.value != TeamMemberType.agency) {
                          return const SizedBox.shrink();
                        }
                        return Column(
                          children: [
                            const SizedBox(height: 16),
                            JobSelectionField(
                              controller: controller.positionController,
                              hintText: tr(LanguageKeys.teamManagementPositionHint),
                              label: tr(LanguageKeys.jobTitle),
                              isRequired: true,
                              style: JobSelectionFieldStyle.teamManagement,
                              onJobSelected: controller.onJobSelected,
                              validator: (v) =>
                                  v == null || v.trim().isEmpty ? tr(LanguageKeys.jobRequired) : null,
                            ),
                          ],
                        );
                      }),
                      const SizedBox(height: 16),
                      _field(
                        label: tr(LanguageKeys.city),
                        controller: controller.cityController,
                        hint: tr(LanguageKeys.teamManagementEnterCity),
                        validator: (v) => controller.validateRequired(
                          v,
                          LanguageKeys.pleaseEnterCity,
                        ),
                      ),
                      Obx(() {
                        if (controller.error.value.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            controller.error.value,
                            style: const TextStyle(color: AppColors.red600, fontSize: 13),
                          ),
                        );
                      }),
                      const SizedBox(height: 20),
                      Obx(() => _submitButton()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sheetHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
      child: Row(
        children: [
          const SizedBox(width: 40),
          Expanded(
            child: Text(
              tr(LanguageKeys.teamManagementAddNewColleague),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.teamTitle,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: AppColors.grey500, size: 24),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.teamBodyGrey,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(fontSize: 14, color: AppColors.teamTitle),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 14, color: AppColors.teamBodyGrey),
            filled: true,
            fillColor: AppColors.whiteColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.teamBorderGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.teamPurple, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.red600),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.red600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _accessTypeRow() {
    return Row(
      children: [
        Expanded(
          child: _accessChip(
            label: tr(LanguageKeys.teamManagementAgency),
            selected: controller.memberType.value == TeamMemberType.agency,
            onTap: () => controller.selectMemberType(TeamMemberType.agency),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _accessChip(
            label: tr(LanguageKeys.teamManagementIndependent),
            selected: controller.memberType.value == TeamMemberType.independent,
            onTap: () => controller.selectMemberType(TeamMemberType.independent),
          ),
        ),
      ],
    );
  }

  Widget _accessChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: selected ? AppColors.teamPurpleLightBg : AppColors.whiteColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppColors.teamPurple : AppColors.teamBorderGrey,
              width: selected ? 2 : 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: selected ? AppColors.teamPurple : AppColors.teamTitle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _submitButton() {
    final loading = controller.isSubmitting.value;
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: loading ? null : () => controller.sendInvitation(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.teamPurple,
          disabledBackgroundColor: AppColors.teamPurple.withOpacity(0.6),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: loading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                tr(LanguageKeys.teamManagementSendInvitation),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}
