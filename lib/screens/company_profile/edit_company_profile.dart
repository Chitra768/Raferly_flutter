import 'package:flutter/material.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/widgets/custom_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:referaly/controller/edit_company_profile_controller.dart';

class EditCompanyProfileScreen extends StatefulWidget {
  const EditCompanyProfileScreen({super.key});
  static String pageId = '/screenEditCompanyProfile';

  @override
  State<EditCompanyProfileScreen> createState() => _EditCompanyProfileScreenState();
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
        Column(
          children: [
            const SizedBox(
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(Icons.arrow_back, color: AppColors.bgDark),
                ),
                const SizedBox(
                  width: 80,
                ),
                const Text(
                  'Edit Company\nProfile',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 36),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 112,
                            height: 112,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Obx(() {
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
                          ),
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
                                  color: Colors.purple,
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
                      _buildTextField('Company Name', controller.nameController,
                          isRequired: true),
                      const SizedBox(height: 16),
                      _buildTextField(
                          'Description', controller.descriptionController,
                          maxLines: 4, isRequired: true, counter: '4/500'),
                      const SizedBox(height: 16),
                      _buildTextField(
                          'Company Address', controller.addressController,
                          isRequired: true),
                      const SizedBox(height: 16),
                      _buildTextField('Company Number(Business code)',
                          controller.businessCodeController,
                          keyboardType: TextInputType.number, isRequired: true),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate() &&
                                !controller.isLoading.value) {
                              final success =
                                  await controller.updateCompanyProfile();
                              if (success) {
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
                                    'Submit',
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
            ),
          ],
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
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
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
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            counterText: counter,
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
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Take Photo',
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
                    side: const BorderSide(color: Colors.purple),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Select from Camera Roll',
                    style: TextStyle(fontSize: 18, color: Colors.purple),
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
