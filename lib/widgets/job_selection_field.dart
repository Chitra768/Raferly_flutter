import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:referaly/bindings/binding_select_jobs.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/onboarding/select_jobs_screen.dart';
import 'package:referaly/utils/translations.dart';

enum JobSelectionFieldStyle {
  registration,
  dashboard,
  /// Matches team management bottom sheet fields ([AddColleagueBottomSheet]).
  teamManagement,
  /// Matches [MyProfileScreen] personal info text fields.
  profile,
}

/// Tappable job field that opens [SelectJobsScreen] for single selection.
class JobSelectionField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String label;
  final bool isRequired;
  final String? Function(String?)? validator;
  final void Function(int id, String title)? onJobSelected;
  final JobSelectionFieldStyle style;
  /// Pre-selects a job in the picker when it exists in the catalog.
  final int? initialJobId;

  const JobSelectionField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.label,
    this.isRequired = true,
    this.validator,
    this.onJobSelected,
    this.style = JobSelectionFieldStyle.registration,
    this.initialJobId,
  });

  Future<void> _openJobPicker() async {
    final result = await Get.to(
      () => const SelectJobsScreen(isSingleSelection: true),
      binding: BindingSelectJobs(
        isSingleSelection: true,
        initialJobId: initialJobId,
      ),
    );
    if (result != null && result is Map) {
      if (result.containsKey('id') && result.containsKey('title')) {
        final jobId = result['id'];
        final jobTitle = result['title']?.toString() ?? '';
        controller.text = jobTitle;
        if (jobId is int) {
          onJobSelected?.call(jobId, jobTitle);
        } else if (jobId != null) {
          final parsed = int.tryParse(jobId.toString());
          if (parsed != null) {
            onJobSelected?.call(parsed, jobTitle);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, isRequired: isRequired),
        if (style == JobSelectionFieldStyle.registration) const SizedBox(height: 0),
        if (style == JobSelectionFieldStyle.dashboard) const SizedBox(height: 6),
        if (style == JobSelectionFieldStyle.teamManagement) const SizedBox(height: 8),
        if (style == JobSelectionFieldStyle.profile) const SizedBox(height: 8),
        GestureDetector(
          onTap: _openJobPicker,
          child: AbsorbPointer(
            child: switch (style) {
              JobSelectionFieldStyle.registration => _RegistrationJobField(
                  controller: controller,
                  hintText: hintText,
                  validator: validator,
                ),
              JobSelectionFieldStyle.dashboard => _DashboardJobField(
                  controller: controller,
                  hintText: hintText,
                  validator: validator,
                ),
              JobSelectionFieldStyle.teamManagement => _TeamManagementJobField(
                  controller: controller,
                  hintText: hintText,
                  validator: validator,
                ),
              JobSelectionFieldStyle.profile => _ProfileJobField(
                  controller: controller,
                  hintText: hintText,
                  validator: validator,
                ),
            },
          ),
        ),
        if (style == JobSelectionFieldStyle.profile) const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildLabel(String text, {bool isRequired = false}) {
    if (style == JobSelectionFieldStyle.teamManagement) {
      return Row(
        children: [
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.teamBodyGrey,
              ),
            ),
          ),
          if (isRequired)
            const Text(
              ' *',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.red600,
              ),
            ),
        ],
      );
    }
    if (style == JobSelectionFieldStyle.profile) {
      return Row(
        children: [
          Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
          if (isRequired) ...[
            const SizedBox(width: 4),
            const Text('*', style: TextStyle(color: Colors.red)),
          ],
        ],
      );
    }
    if (style == JobSelectionFieldStyle.dashboard) {
      return RichText(
        text: TextSpan(
          style: stylePoppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
          children: [
            TextSpan(text: text),
            if (isRequired)
              TextSpan(
                text: ' *',
                style: stylePoppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.error300,
                ),
              ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.blackColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (isRequired)
            Text(
              ' *',
              style: TextStyle(color: AppColors.redColor, fontSize: 16),
            ),
        ],
      ),
    );
  }
}

class _RegistrationJobField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;

  const _RegistrationJobField({
    required this.controller,
    required this.hintText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: controller,
        validator: validator ??
            (value) => value == null || value.trim().isEmpty
                ? tr(LanguageKeys.pleaseSelectJobType)
                : null,
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        decoration: InputDecoration(
          hintText: hintText,
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          hintStyle: TextStyle(color: AppColors.greyFontColor),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.redColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.redColor, width: 2),
          ),
        ),
      ),
    );
  }
}

class _ProfileJobField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;

  const _ProfileJobField({
    required this.controller,
    required this.hintText,
    this.validator,
  });

  static const _borderColor = Color(0XFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator ??
          (value) => value == null || value.trim().isEmpty
              ? tr(LanguageKeys.pleaseEnterJob)
              : null,
      decoration: InputDecoration(
        filled: false,
        fillColor: _borderColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _borderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _borderColor, width: 1),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _borderColor, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        hintText: hintText,
      ),
    );
  }
}

class _TeamManagementJobField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;

  const _TeamManagementJobField({
    required this.controller,
    required this.hintText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator ??
          (value) => value == null || value.trim().isEmpty
              ? tr(LanguageKeys.jobRequired)
              : null,
      style: const TextStyle(fontSize: 14, color: AppColors.teamTitle),
      decoration: InputDecoration(
        hintText: hintText,
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
    );
  }
}

class _DashboardJobField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;

  const _DashboardJobField({
    required this.controller,
    required this.hintText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator ??
          (value) => value == null || value.trim().isEmpty
              ? tr(LanguageKeys.jobRequired)
              : null,
      style: stylePoppins(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.blackColor,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: stylePoppins(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.grey600,
        ),
        filled: true,
        fillColor: AppColors.whiteColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grey300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.redColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.redColor, width: 1.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grey300),
        ),
      ),
    );
  }
}
