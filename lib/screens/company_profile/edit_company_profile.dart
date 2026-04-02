// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:referaly/controller/edit_company_profile_controller.dart'
    show EditCompanyProfileController;
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/profile/my_profile_screen.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/custom_app_bar.dart';
import 'package:referaly/widgets/logo_loader.dart';

class EditCompanyProfileScreen extends StatefulWidget {
  const EditCompanyProfileScreen({super.key});
  static String pageId = '/screenEditCompanyProfile';

  @override
  State<EditCompanyProfileScreen> createState() =>
      _EditCompanyProfileScreenState();
}

class _EditCompanyProfileScreenState extends State<EditCompanyProfileScreen> {
  final EditCompanyProfileController controller =
      Get.put(EditCompanyProfileController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(children: [
        // Background Image
        Positioned(
          top: 0,
          child: Image.asset(
            AppAssets.imgCircle,
            fit: BoxFit.fitWidth,
            height: 220,
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 60,
              ),
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
                      tr(LanguageKeys.editCompanyProfile),
                      textAlign: TextAlign.center,
                      style: stylePoppins(
                          fontSize: 19.w,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textTitle),
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 36),
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

                          // Edit icon
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
                                  border:
                                      Border.all(color: Colors.white, width: 3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _buildTextField(tr(LanguageKeys.companyName),
                          controller.nameController),
                      const SizedBox(height: 16),
                      _buildTextField(tr(LanguageKeys.description),
                          controller.descriptionController,
                          maxLines: 4,
                          isRequired: true,
                          counter:
                              '${controller.descriptionController.text.length} /200'),
                      const SizedBox(height: 16),
                      _buildTextField(tr(LanguageKeys.companyAddress),
                          controller.addressController),
                      const SizedBox(height: 16),
                      _buildTextField(
                          tr(LanguageKeys.companyPhoneNumber) +
                              "(${tr(LanguageKeys.comapnyLabel)})",
                          controller.businessCodeController,
                          keyboardType: TextInputType.number),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            if (!controller.isLoading.value) {
                              final success =
                                  await controller.updateCompanyProfile();
                              if (success) {
                                Get.back();
                              }
                            }
                          },
                          child: Obx(
                            () => controller.isLoading.value
                                ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child:
                                        LogoLoader(color: AppColors.whiteColor),
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
              ),
            ],
          ),
        )
      ]),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1,
      bool isRequired = false,
      String? counter,
      TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              counter != null ? '$label ($counter)' : label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              const Text('*', style: TextStyle(color: Colors.red)),
            ],
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          maxLength: counter != null ? 200 : null,
          keyboardType: keyboardType,
          onChanged: (value) {
            if (counter != null) {
              setState(() {});
            }
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            counterText: "", // Remove the counter from bottom
          ),
          validator: isRequired
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Required';
                  }
                  return null;
                }
              : null,
        ),
      ],
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
                  child: Text(tr(LanguageKeys.choosefromlib),
                      style: TextStyle(fontSize: 18, color: AppColors.primary)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
