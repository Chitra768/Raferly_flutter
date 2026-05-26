import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/utils/translations.dart';

/// Card selector for Professional vs Individual. [selectedIsProfessional] is null when nothing is selected.
class RoleTypeCardSelector extends StatelessWidget {
  final RxnBool selectedIsProfessional;
  final VoidCallback onSelectProfessional;
  final VoidCallback onSelectIndividual;
  final bool showError;
  final String? errorText;

  const RoleTypeCardSelector({
    super.key,
    required this.selectedIsProfessional,
    required this.onSelectProfessional,
    required this.onSelectIndividual,
    this.showError = false,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selection = selectedIsProfessional.value;
      final isPro = selection == true;
      final isIndividual = selection == false;
      final hasError = showError && selection == null;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _RoleCard(
                  isSelected: isPro,
                  onTap: onSelectProfessional,
                  iconAsset: AppAssets.imgJobActivity,
                  label: tr(LanguageKeys.professional),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _RoleCard(
                  isSelected: isIndividual,
                  onTap: onSelectIndividual,
                  iconAsset: AppAssets.imgPersonactivity,
                  label: tr(LanguageKeys.individual),
                ),
              ),
            ],
          ),
          if (hasError && errorText != null && errorText!.isNotEmpty) ...[
            SizedBox(height: 6.h),
            Text(
              errorText!,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.redColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ],
      );
    });
  }
}

class _RoleCard extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final String iconAsset;
  final String label;

  const _RoleCard({
    required this.isSelected,
    required this.onTap,
    required this.iconAsset,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 16.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.roleCardSelectedBg : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (isSelected)
              Positioned(
                top: -16.w,
                right: -29.w,
                child: Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 14.w,
                    color: Colors.white,
                  ),
                ),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  iconAsset,
                  height: 20.w,
                  width: 20.w,
                  colorFilter: ColorFilter.mode(
                    isSelected ? AppColors.primary : AppColors.greyFontColor,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(height: 10.w),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.w,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? AppColors.primary : AppColors.blackColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
