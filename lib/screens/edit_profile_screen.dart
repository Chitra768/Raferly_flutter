import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/edit_profile_controller.dart';
import 'package:referaly/popups/add_lead_dialog.dart' show AddLeadDialog;
import 'package:referaly/popups/out_of_referaly_dialog.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import '../controller/add_lead_controller.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);
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
              const SizedBox(height: 60),
              // Custom App Bar
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: GestureDetector(
                        onTap: () => Get.back(),
                        child: Icon(Icons.arrow_back, color: AppColors.bgDark),
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Edit Profile',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                                    color: Colors.purple,
                                    border: Border.all(
                                        color: Colors.white, width: 3),
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
                        Form(
                          key: controller.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('First Name', isRequired: true),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: controller.firstNameController,
                                decoration: _inputDecoration('First Name'),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Required'
                                        : null,
                              ),
                              const SizedBox(height: 16),
                              _buildLabel('Last Name', isRequired: true),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: controller.lastNameController,
                                decoration: _inputDecoration('Last Name'),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Required'
                                        : null,
                              ),
                              const SizedBox(height: 16),
                              _buildLabel('Email'),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: controller.emailController,
                                decoration: _inputDecoration('Email'),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 16),
                              _buildLabel('Phone Number'),
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
                                            decoration: const InputDecoration(
                                              hintText: 'Phone Number',
                                              border: InputBorder.none,
                                            ),
                                            keyboardType: TextInputType.phone,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              const SizedBox(height: 16),
                              _buildLabel('Job'),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: controller.jobController,
                                decoration: _inputDecoration('Job'),
                              ),
                              const SizedBox(height: 16),
                              _buildLabel('City', isRequired: true),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: controller.cityController,
                                decoration: _inputDecoration('City'),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'Required'
                                        : null,
                              ),
                              const SizedBox(height: 16),
                              _buildLabel('Language'),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: controller.languageController,
                                decoration: _inputDecoration('Language'),
                              ),
                              const SizedBox(height: 32),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.purple,
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
                                        if (success) {
                                          Get.back();
                                        }
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
