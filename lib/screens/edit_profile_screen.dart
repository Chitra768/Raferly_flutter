import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/popups/add_lead_dialog.dart' show AddLeadDialog;
import 'package:referaly/popups/out_of_referaly_dialog.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import '../controller/edit_profile_controller.dart';
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
                            Container(
                              width: 112,
                              height: 112,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: const CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.red,
                                child: Icon(Icons.person,
                                    size: 48, color: Colors.white),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
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
                                  onPressed: () {
                                    if (controller.validateAndSave()) {
                                      Future.delayed(
                                          const Duration(milliseconds: 500),
                                          () {
                                        // Get.dialog(AddLeadDialog());
                                        Get.dialog(OutOfReferalyDialog());
                                      });
                                    }
                                  },
                                  child: const Text('Submit',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white)),
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
}
