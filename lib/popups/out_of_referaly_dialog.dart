import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/resources/app_assets.dart' show AppAssets;
import 'package:referaly/resources/app_colors.dart' show AppColors;
import 'package:referaly/resources/text_style.dart' show stylePoppins;

class OutOfReferalyDialog extends StatelessWidget {
  static String pageId = "/outOfReferalyDialog";

  OutOfReferalyDialog({super.key});

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _descController = TextEditingController();
  final _commissionOptions = ['Option 1', 'Option 2', 'Option 3'];
  final RxnString _selectedCommission = RxnString();
  final RxList<String> _trackingSteps = [
    'Contact called',
    'Contract signed',
    'Service delivered',
    'Payment received',
    'Commision Paid'
  ].obs;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(8),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title and close button
                Row(
                  children: [
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Out of Referaly',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(Icons.close, size: 28),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Send a prospect to a professional who has not yet joined Referaly.\nBe protected by a contract and benefit from transparent tracking!\nYour prospect\'s information will not be shared until the contract has been accepted.',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                const Text('Lead Information',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                        fontSize: 16)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('First Name'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _firstNameController,
                            decoration: _inputDecoration('Enter First Name'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Last Name'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _lastNameController,
                            decoration: _inputDecoration('Last Name'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildLabel('Phone Number'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  decoration: _inputDecoration('Enter Number'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                _buildLabel('Email'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  decoration: _inputDecoration('Enter Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _buildLabel('Description'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descController,
                  maxLines: 3,
                  decoration: _inputDecoration('Details About The Lead'),
                ),
                const SizedBox(height: 18),
                _buildLabel('The commission you wish to receive'),
                const SizedBox(height: 8),
                Obx(() => DropdownButtonFormField<String>(
                      value: _selectedCommission.value,
                      items: _commissionOptions
                          .map((type) =>
                              DropdownMenuItem(value: type, child: Text(type)))
                          .toList(),
                      onChanged: (val) => _selectedCommission.value = val,
                      decoration: InputDecoration(
                        hintText: 'Choose One option',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none),
                      ),
                    )),
                const SizedBox(height: 18),
                _buildLabel('The tracking steps you want to have'),
                const SizedBox(height: 8),
                Obx(() => Column(
                      children: [
                        for (int i = 0; i < _trackingSteps.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    initialValue: _trackingSteps[i],
                                    enabled: false,
                                    decoration: _inputDecoration(''),
                                  ),
                                ),
                                if (i < _trackingSteps.length - 1)
                                  GestureDetector(
                                    onTap: () => _trackingSteps.removeAt(i),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2),
                                      child: Image.asset(
                                        AppAssets.imgDeleteicon,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ),
                      ],
                    )),
                const SizedBox(height: 8),

                buildAddNewButton(),
                const SizedBox(height: 8),
                buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(label, style: const TextStyle(fontWeight: FontWeight.w500));
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintText: hint,
    );
  }

  Widget buildAddNewButton() {
    return GestureDetector(
      onTap: () {
        // Add new functionality
        _trackingSteps.add('');
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              "Add New",
              style: stylePoppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSubmitButton() {
    return GestureDetector(
      // onTap: controller.submitDeal,
      onTap: () {
        if (_formKey.currentState!.validate()) {
          // Handle submit
          Get.back();
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            "Generate and Share a contract",
            style: stylePoppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
