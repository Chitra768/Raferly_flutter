import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:referaly/controller/controller_registration.dart';
import 'package:referaly/controller/edit_profile_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/auth/screen_choose_language.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/dialog/show_welcome_to_professional_dialog.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});
  static String pageId = '/screenEditProfile';

  final EditProfileController controller = Get.put(EditProfileController());
  Widget _buildCountryPickerBottomSheet({
    required List<Country> countryList,
    required Rx<Country> selectedCountry,
  }) {
    return SafeArea(
      child: Container(
        height: Get.height,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              ),
              alignment: Alignment.centerLeft,
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: ListView.separated(
                itemCount: countryList.length,
                separatorBuilder: (_, __) => Divider(color: AppColors.grey200),
                itemBuilder: (context, index) {
                  final country = countryList[index];
                  return ListTile(
                    minVerticalPadding: 0,
                    minTileHeight: 40,
                    onTap: () {
                      selectedCountry.value = country;
                      Get.back();
                    },
                    leading: Text(country.emoji,
                        style: const TextStyle(fontSize: 20)),
                    title: Text(country.name),
                    // trailing: Text(country.code),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfessionalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => Text(
                    tr(LanguageKeys.youAreNotPaidUser),
                    textAlign: TextAlign.center,
                    style:
                        stylePoppins(fontSize: 16, color: AppColors.fontBlack),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8E2DE2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                      },
                      child: Obx(
                        () => Text(tr(LanguageKeys.okay),
                            style: stylePoppins(color: AppColors.whiteColor)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          // Background Image
          Positioned(
            top: -29,
            child: Image.asset(
              AppAssets.imgCircle,
              fit: BoxFit.fitWidth,
              height: 220,
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 50),
              // Custom App Bar
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Container(
                        height: 42,
                        width: 42,
                        // padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      tr(LanguageKeys.editprofile),
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 46),
                        // Profile image with edit button
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Avatar with white border
                            Obx(() {
                              final imagePath = controller.getDisplayImage();
                              if (imagePath.isEmpty) {
                                return const CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey,
                                  child: Icon(
                                    Icons.account_circle,
                                    size: 80,
                                    color: Colors.white,
                                  ),
                                );
                              }
                              return CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey[200],
                                backgroundImage: controller.pickedImage.value !=
                                        null
                                    ? FileImage(controller.pickedImage.value!)
                                    : NetworkImage(imagePath) as ImageProvider,
                              );
                            }),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  showImagePickerSheet(
                                    context,
                                    controller.pickImageFromCamera,
                                    controller.pickImageFromGallery,
                                  );
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      border: Border.all(
                                          color: AppColors.primary, width: 3),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: SvgPicture.asset(
                                      AppAssets.imgEditIcon,
                                      color: Colors.white,
                                      height: 18,
                                    )),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        Form(
                          key: controller.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel(tr(LanguageKeys.firstName),
                                  isRequired: true),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: controller.firstNameController,
                                decoration: _inputDecoration(
                                    tr(LanguageKeys.firstName)),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? tr(LanguageKeys.pleaseEnterFirstName)
                                        : null,
                              ),
                              const SizedBox(height: 16),
                              _buildLabel(tr(LanguageKeys.lastName),
                                  isRequired: true),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: controller.lastNameController,
                                decoration:
                                    _inputDecoration(tr(LanguageKeys.lastName)),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? tr(LanguageKeys.pleaseEnterLastName)
                                        : null,
                              ),
                              const SizedBox(height: 16),
                              _buildLabel(tr(LanguageKeys.email)),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: controller.emailController,
                                decoration:
                                    _inputDecoration(tr(LanguageKeys.email)),
                                keyboardType: TextInputType.emailAddress,
                                readOnly: true,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              const SizedBox(height: 16),
                              _buildLabel(tr(LanguageKeys.phoneNumber)),
                              const SizedBox(height: 8),
                              Obx(() => Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            Get.bottomSheet(
                                              _buildCountryPickerBottomSheet(
                                                countryList:
                                                    controller.countries,
                                                selectedCountry:
                                                    controller.selectedCountry,
                                              ),
                                              isScrollControlled: true,
                                              backgroundColor: Colors.white,
                                            );
                                          },
                                          child: Obx(() => Container(
                                                width: 60,
                                                alignment: Alignment.centerLeft,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15),
                                                child: Text(
                                                  controller.selectedCountry
                                                      .value.code,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              )),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: TextFormField(
                                            controller:
                                                controller.phoneController,
                                            decoration: InputDecoration(
                                              hintText:
                                                  tr(LanguageKeys.phoneNumber),
                                              border: InputBorder.none,
                                            ),
                                            keyboardType: TextInputType.phone,
                                            validator: (value) =>
                                                value == null || value.isEmpty
                                                    ? tr(LanguageKeys
                                                        .pleaseEnterPhoneNumber)
                                                    : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              const SizedBox(height: 16),

                              Obx(() => Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: RadioListTile<String>(
                                          title: Text(
                                            tr(LanguageKeys.professional),
                                            style: stylePoppins(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          value: tr(LanguageKeys.professional),
                                          groupValue: controller
                                                      .userType.value ==
                                                  "professional"
                                              ? tr(LanguageKeys.professional)
                                              : tr(LanguageKeys.individual),
                                          onChanged: (val) {
                                            AppHelper.showLog("asfsfs: ${val}");
                                            if (val ==
                                                tr(LanguageKeys.professional)) {
                                              controller.isEditUserType.value =
                                                  true;
                                            } else {
                                              controller.isEditUserType.value =
                                                  false;
                                            }
                                            controller.setUserType(val!);
                                          },
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                      Expanded(
                                        child: RadioListTile<String>(
                                          title: Text(
                                            tr(LanguageKeys.individual),
                                            style: stylePoppins(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          value: tr(LanguageKeys.individual),
                                          groupValue: controller
                                                      .userType.value ==
                                                  "professional"
                                              ? tr(LanguageKeys.professional)
                                              : tr(LanguageKeys.individual),
                                          onChanged: (val) => controller
                                                      .isPaid.value !=
                                                  0
                                              ? _showProfessionalDialog(context)
                                              : controller.setUserType(val!),
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ],
                                  )),
                              const SizedBox(height: 16),
                              _buildLabel(tr(LanguageKeys.job),
                                  isRequired: controller.userType.value ==
                                      "professional"),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: controller.jobController,
                                decoration:
                                    _inputDecoration(tr(LanguageKeys.job)),
                                validator: (value) {
                                  if (controller.userType.value ==
                                          "professional" &&
                                      (value == null || value.isEmpty)) {
                                    return tr(LanguageKeys.pleaseEnterJob);
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildLabel(tr(LanguageKeys.city),
                                  isRequired: true),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: controller.cityController,
                                decoration:
                                    _inputDecoration(tr(LanguageKeys.city)),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? tr(LanguageKeys.pleaseEnterCity)
                                        : null,
                              ),
                              const SizedBox(height: 16),
                              _buildLabel(
                                tr(
                                  LanguageKeys.language,
                                ),
                                isRequired: true,
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(ScreenChooseLanguage.pageId);
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 60,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text(
                                    textAlign: TextAlign.left,
                                    controller.languageController.text,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                                ),
                              ),
                              // TextFormField(
                              //   readOnly: true,
                              //   controller: controller.languageController,
                              //   decoration:
                              //       _inputDecoration(tr(LanguageKeys.language)),
                              // ),
                              const SizedBox(height: 32),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : () async {
                                          if (controller.validateAndSave()) {
                                            if (!controller.isLoading.value) {
                                              final success = await controller
                                                  .updateProfile();
                                            }
                                          }
                                        },
                                  child: Obx(
                                    () => controller.isLoading.value
                                        ?  SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: LoadingIndicator(
                                              indicatorType:
                                                  Indicator.lineSpinFadeLoader,
                                              colors: [AppColors.whiteColor],
                                            ),
                                          )
                                        : Text(
                                            tr(LanguageKeys.submit),
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: AppColors.whiteColor),
                                          ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label, {bool isRequired = false}) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        if (isRequired) ...[
          const SizedBox(width: 4),
          const Text('*', style: TextStyle(color: Colors.red)),
        ],
      ],
    );
  }

  InputDecoration _inputDecoration(String hint, {String? prefixText}) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintText: hint,
      prefixText: prefixText,
    );
  }

  void showImagePickerSheet(
      BuildContext context, VoidCallback onCamera, VoidCallback onGallery) {
    showModalBottomSheet(
      backgroundColor: AppColors.whiteColor,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onCamera();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(tr(LanguageKeys.takePicture),
                      style:
                          TextStyle(fontSize: 18, color: AppColors.whiteColor)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onGallery();
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    tr(LanguageKeys.choosefromlib),
                    style: TextStyle(fontSize: 18, color: AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
