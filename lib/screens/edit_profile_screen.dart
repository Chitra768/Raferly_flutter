import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/edit_profile_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/screens/auth/screen_choose_language.dart';
import 'package:referaly/utils/translations.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});
  static String pageId = '/screenEditProfile';

  final EditProfileController controller = Get.put(EditProfileController());

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

                        // child: SvgPicture.asset(
                        //   AppAssets.imgIosBack,
                        //   colorFilter: ColorFilter.mode(
                        //       AppColors.blackColor, BlendMode.darken),
                        // ),
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
                                        ? 'Required'
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
                                        ? 'Required'
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
                                        DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: controller
                                                .selectedCountryCode.value,
                                            items: controller.countryCodes
                                                .map((code) => DropdownMenuItem(
                                                      value: code,
                                                      child: Text(code),
                                                    ))
                                                .toList(),
                                            onChanged: (val) {
                                              if (val != null)
                                                controller.selectedCountryCode
                                                    .value = val;
                                            },
                                          ),
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
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              const SizedBox(height: 16),
                              _buildLabel(tr(LanguageKeys.job)),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: controller.jobController,
                                decoration:
                                    _inputDecoration(tr(LanguageKeys.job)),
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
                                        ? 'Required'
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
                                  onPressed: () async {
                                    if (controller.validateAndSave()) {
                                      if (!controller.isLoading.value) {
                                        final success =
                                            await controller.updateProfile();
                                        Get.back();
                                      }
                                    }
                                  },
                                  child: Obx(
                                    () => controller.isLoading.value
                                        ? const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2.5,
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
                    side:  BorderSide(color: AppColors.primary),
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
