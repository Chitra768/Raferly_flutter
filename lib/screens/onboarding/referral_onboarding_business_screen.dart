import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/controller/profile_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/home/screen_main.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/logo_loader.dart';

/// Step 3 of 3: Business/Company Information for referral onboarding.
/// Prefilled from profile when available. On Complete → Main with dealId.
/// Uses its own TextEditingControllers so they are not used after ProfileController is disposed during navigation.
class ReferralOnboardingBusinessScreen extends StatefulWidget {
  const ReferralOnboardingBusinessScreen({super.key});

  static String pageId = '/referralOnboardingBusiness';

  @override
  State<ReferralOnboardingBusinessScreen> createState() =>
      _ReferralOnboardingBusinessScreenState();
}

class _ReferralOnboardingBusinessScreenState
    extends State<ReferralOnboardingBusinessScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _addressController;
  late final TextEditingController _businessCodeController;
  bool _isUpdateLoading = false;
  bool _didSyncFromProfile = false;
  Worker? _profilePrefillWorker;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _addressController = TextEditingController();
    _businessCodeController = TextEditingController();
    if (Get.isRegistered<ProfileController>()) {
      final pc = Get.find<ProfileController>();
      if (pc.isProfileLoaded.value) {
        _syncLocalControllersFromProfile(pc);
        _didSyncFromProfile = true;
      } else {
        _profilePrefillWorker = ever(pc.isProfileLoaded, (loaded) {
          if (loaded == true && !_didSyncFromProfile && mounted) {
            _syncLocalControllersFromProfile(pc);
            _didSyncFromProfile = true;
            setState(() {});
          }
        });
      }
    }
  }

  void _syncLocalControllersFromProfile(ProfileController pc) {
    final data = pc.profile.value?.data;
    if (data != null) {
      _nameController.text = data.companyName?.trim() ?? '';
      _descriptionController.text = data.companyDescription?.trim() ?? '';
      _addressController.text = data.companyAddress?.trim() ?? '';
      _businessCodeController.text = data.companyNumber?.trim() ?? '';
      return;
    }
    _nameController.text = pc.nameController.text;
    _descriptionController.text = pc.descriptionController.text;
    _addressController.text = pc.addressController.text;
    _businessCodeController.text = pc.businessCodeController.text;
  }

  @override
  void dispose() {
    _profilePrefillWorker?.dispose();
    // Do not dispose the text controllers here. Get.offAllNamed disposes this
    // State before the route transition finishes, so the outgoing route's
    // TextFormFields can still be in the tree and trigger "used after disposed".
    // Controllers are left for GC once the route is fully removed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ProfileController>()) {
      return const Scaffold(body: SizedBox.shrink());
    }
    final controller = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: _buildAppBar(),
      body: Obx(() {
        if (!controller.isProfileLoaded.value) {
          return const Center(
            child: SizedBox(width: 24, height: 24, child: LogoLoader()),
          );
        }
        return SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tr(LanguageKeys.businessInformation),
                style: stylePoppins(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.fontBlack,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                tr(LanguageKeys.completeYourCompanyProfile),
                style: stylePoppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey600,
                ),
              ),
              SizedBox(height: 32.h),
              _buildLabel(tr(LanguageKeys.companyLogo)),
              SizedBox(height: 8.h),
              // Company logo upload area - no Obx to avoid "dependent is not our descendant" on route replace
              GestureDetector(
                onTap: () =>
                    _showImagePicker(context, controller, onPicked: () {
                  if (mounted) setState(() {});
                }),
                child: _buildLogoUploadContent(controller),
              ),
              SizedBox(height: 24.h),
              _buildLabel(tr(LanguageKeys.companyName), isRequired: true),
              SizedBox(height: 8.h),
              _buildTextField(_nameController,
                  hint: tr(LanguageKeys.companyName),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? tr(LanguageKeys.pleaseEnterCompanyName)
                      : null),
              SizedBox(height: 24.h),
              _buildLabel(tr(LanguageKeys.companyDescription),
                  isRequired: true),
              SizedBox(height: 8.h),
              _buildTextField(_descriptionController,
                  hint: tr(LanguageKeys.companyDescription),
                  maxLines: 4,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? tr(LanguageKeys.pleaseEnterDescription)
                      : null),
              SizedBox(height: 24.h),
              _buildLabel(tr(LanguageKeys.companyAddress), isRequired: true),
              SizedBox(height: 8.h),
              _buildTextField(_addressController,
                  hint: tr(LanguageKeys.companyAddress),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? tr(LanguageKeys.pleaseEnterCompanyAddress)
                      : null),
              SizedBox(height: 24.h),
              _buildLabel(
                  '${tr(LanguageKeys.companyPhoneNumber)} (${tr(LanguageKeys.comapnyLabel)})'),
              SizedBox(height: 8.h),
              _buildTextField(_businessCodeController,
                  hint: tr(LanguageKeys.comapnyLabel),
                  keyboardType: TextInputType.number),
              SizedBox(height: 40.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: _isUpdateLoading
                      ? null
                      : () async {
                          if (_descriptionController.text.trim().isEmpty) {
                            Get.snackbar(
                              tr(LanguageKeys.error),
                              tr(LanguageKeys.pleaseEnterDescription),
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }
                          if (!mounted) return;
                          setState(() => _isUpdateLoading = true);
                          final success =
                              await controller.updateCompanyProfileWithData(
                            name: _nameController.text.trim(),
                            description: _descriptionController.text.trim(),
                            address: _addressController.text.trim(),
                            businessCode: _businessCodeController.text.trim(),
                          );
                          if (mounted) {
                            setState(() => _isUpdateLoading = false);
                            if (success) _navigateToMainWithDeal();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: _isUpdateLoading
                      ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.whiteColor),
                          ),
                        )
                      : Text(
                          tr(LanguageKeys.completeButton),
                          style: stylePoppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.whiteColor,
                          ),
                        ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    tr(LanguageKeys.back),
                    textAlign: TextAlign.center,
                    style: stylePoppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      }),
    );
  }

  void _navigateToMainWithDeal() {
    final pendingDealId = AppPreference.readString('pending_deal_id');
    final pendingCampaign = AppPreference.readString('pending_campaign');
    final pendingStage = AppPreference.readString('pending_stage');
    AppPreference.writeString('pending_deal_id', '');
    AppPreference.writeString('pending_campaign', '');
    AppPreference.writeString('pending_stage', '');
    if (Get.isRegistered<ControllerMainProfessional>()) {
      Get.delete<ControllerMainProfessional>();
    }
    Get.offAllNamed(
      ScreenMain.pageId,
      arguments: {
        'dealId': pendingDealId,
        'campaign': pendingCampaign,
        'stage': pendingStage,
      },
    );
  }

  void _showImagePicker(BuildContext context, ProfileController controller,
      {VoidCallback? onPicked}) {
    showModalBottomSheet(
      backgroundColor: AppColors.whiteColor,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    await controller.pickImageFromCamera(isCompanyLogo: true);
                    onPicked?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    tr(LanguageKeys.takePicture),
                    style:
                        TextStyle(fontSize: 18.sp, color: AppColors.whiteColor),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    await controller.pickImageFromGallery(isCompanyLogo: true);
                    onPicked?.call();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    tr(LanguageKeys.choosefromlib),
                    style: TextStyle(fontSize: 18.sp, color: AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLogoUploadContent(ProfileController controller) {
    final imagePath = controller.getDisplayImage(isCompanyLogo: true);
    final pickedFile = controller.pickedCompanyLogo.value;
    final hasImage = imagePath.isNotEmpty || pickedFile != null;

    return DottedBorder(
      color: AppColors.grey300,
      strokeWidth: 1.5,
      borderType: BorderType.RRect,
      radius: Radius.circular(12.r),
      dashPattern: const [8, 4],
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: hasImage
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: pickedFile != null
                    ? Image.file(
                        pickedFile,
                        height: 120.h,
                        fit: BoxFit.contain,
                      )
                    : Image.network(
                        imagePath,
                        height: 120.h,
                        fit: BoxFit.contain,
                      ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 56.w,
                    height: 56.w,
                    decoration: BoxDecoration(
                      color: AppColors.grey200,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.cloud_upload,
                      size: 28.sp,
                      color: AppColors.grey600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Upload your logo',
                    style: stylePoppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Choose a file',
                    style: stylePoppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ).copyWith(
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
        ],
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(20.h),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tr(LanguageKeys.step3Of3),
                    style: stylePoppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey600,
                    ),
                  ),
                  Text(
                    '100%',
                    style: stylePoppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Container(
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, {bool isRequired = false}) {
    return Row(
      children: [
        Text(
          text,
          style: stylePoppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.fontBlack,
          ),
        ),
        if (isRequired)
          Text(' *',
              style: TextStyle(color: AppColors.redColor, fontSize: 16.sp)),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController controller, {
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: stylePoppins(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.grey600,
        ),
        filled: true,
        fillColor: AppColors.whiteColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.grey300, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.grey300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      ),
      style: stylePoppins(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.fontBlack,
      ),
    );
  }
}
