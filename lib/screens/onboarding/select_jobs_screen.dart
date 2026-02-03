import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/select_jobs_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_categories.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';

class SelectJobsScreen extends StatelessWidget {
  final bool isSingleSelection;

  const SelectJobsScreen({super.key, this.isSingleSelection = false});

  static String pageId = '/selectJobs';

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(SelectJobsController(isSingleSelection: isSingleSelection));

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        surfaceTintColor: AppColors.whiteColor,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Icon(
                Icons.arrow_back,
                size: 24.sp,
                color: AppColors.fontBlack,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                tr(LanguageKeys.selectJobs),
                style: stylePoppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.fontBlack,
                ),
              ),
            ),
            if (!isSingleSelection)
              TextButton(
                onPressed: controller.done,
                child: Text(
                  tr(LanguageKeys.done),
                  style: stylePoppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Container(
            height: 1.h,
            color: AppColors.grey200,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Container(
                height: 48.h,
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.grey300,
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: controller.searchController,
                  style: stylePoppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.fontBlack,
                  ),
                  decoration: InputDecoration(
                    hintText: tr(LanguageKeys.searchJobs),
                    hintStyle: stylePoppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey600,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20.sp,
                      color: AppColors.grey600,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                  ),
                ),
              ),
            ),

            // Selection Summary (only show if not single selection)
            if (!isSingleSelection)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => Text(
                          '${controller.selectedJobsCount} ${tr(LanguageKeys.jobsSelected)}',
                          style: stylePoppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.grey600,
                          ),
                        )),
                    GestureDetector(
                      onTap: controller.clearAllSelections,
                      child: Text(
                        tr(LanguageKeys.clearAll),
                        style: stylePoppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (!isSingleSelection) SizedBox(height: 16.h),
            SizedBox(height: 16.h),

            // Categories List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  );
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.errorMessage.value,
                          style: stylePoppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.redColor,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: controller.fetchCategories,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            tr(LanguageKeys.retry),
                            style: stylePoppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.filteredCategories.isEmpty) {
                  return Center(
                    child: Text(
                      tr(LanguageKeys.noJobsFound),
                      style: stylePoppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey600,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  itemCount: controller.filteredCategories.length,
                  itemBuilder: (context, index) {
                    final category = controller.filteredCategories[index];
                    return _buildCategoryItem(controller, category);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(
      SelectJobsController controller, CategoryData category) {
    return Obx(() {
      final isExpanded = controller.isCategoryExpanded(category.id ?? 0);

      return Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.grey300,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // Category Header
            GestureDetector(
              onTap: () => controller.toggleCategory(category.id ?? 0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Row(
                  children: [
                    // Category Icon
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: _getCategoryIcon(category.title ?? ''),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Category Title
                    Expanded(
                      child: Text(
                        category.title ?? '',
                        style: stylePoppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.fontBlack,
                        ),
                      ),
                    ),
                    // Expand/Collapse Icon
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 24.sp,
                      color: AppColors.grey600,
                    ),
                  ],
                ),
              ),
            ),

            // Subcategories List
            if (isExpanded && category.subCategories != null)
              ...category.subCategories!.map((subCategory) {
                return Obx(() {
                  final isSelected =
                      controller.isJobSelected(subCategory.id ?? 0);
                  return _buildSubCategoryItem(
                    controller,
                    subCategory,
                    isSelected,
                  );
                });
              }).toList(),
          ],
        ),
      );
    });
  }

  Widget _buildSubCategoryItem(
    SelectJobsController controller,
    SubCategory subCategory,
    bool isSelected,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.grey100.withOpacity(0.5),
        border: Border(
          top: BorderSide(
            color: AppColors.grey200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              subCategory.title ?? '',
              style: stylePoppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.fontBlack,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: () => controller.toggleJobSelection(subCategory.id ?? 0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.primary.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSelected ? Icons.check : Icons.add,
                    size: 16.sp,
                    color:
                        isSelected ? AppColors.whiteColor : AppColors.primary,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    isSelected ? tr(LanguageKeys.added) : tr(LanguageKeys.add),
                    style: stylePoppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color:
                          isSelected ? AppColors.whiteColor : AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getCategoryIcon(String categoryTitle) {
    // Map category titles to icons
    final iconMap = {
      'Real Estate': Icons.home,
      'Brokers': Icons.account_balance,
      'Advisory & Management': Icons.business_center,
      'Business Services & Consulting': Icons.business_center,
      'Legal Services': Icons.gavel,
      'Construction & Design': Icons.build,
      'Marketing & IT Services': Icons.computer,
      'Personal Services & Lifestyle': Icons.person,
      'Health & Wellness': Icons.local_hospital,
      'Transport & Mobility': Icons.directions_car,
      'Specialized Finance': Icons.account_balance_wallet,
      'Tech & Data': Icons.data_object,
      'Training & Coaching': Icons.school,
    };

    final icon = iconMap[categoryTitle] ?? Icons.category;
    return Icon(
      icon,
      size: 20.sp,
      color: AppColors.primary,
    );
  }
}
