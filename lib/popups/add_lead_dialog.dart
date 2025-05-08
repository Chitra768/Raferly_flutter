import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/add_lead_controller.dart';
import '../widgets/app_drawer.dart';

class AddLeadDialog extends StatelessWidget {
  AddLeadDialog({super.key});

  final AddLeadController controller = Get.put(AddLeadController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      body: Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.all(8),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title and close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Spacer(),
                      const Text(
                        'Add a lead',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        child: const Icon(Icons.menu,
                            color: Colors.black, size: 28),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Import from contacts
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.person, color: Colors.purple),
                        label: const Text('Import from contacts',
                            style: TextStyle(color: Colors.purple)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.purple),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Feedback types dropdown
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Feedback types',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(height: 8),
                  Obx(() => DropdownButtonFormField<String>(
                        value: controller.selectedFeedbackType.value,
                        hint: const Text('Choose One option'),
                        items: controller.feedbackTypes
                            .map((type) => DropdownMenuItem(
                                value: type, child: Text(type)))
                            .toList(),
                        onChanged: (val) =>
                            controller.selectedFeedbackType.value = val,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none),
                        ),
                        validator: (val) => val == null
                            ? 'Please select a feedback type'
                            : null,
                      )),
                  const SizedBox(height: 16),
                  // First Name & Last Name
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('First Name', isRequired: true),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: controller.firstNameController,
                              decoration: _inputDecoration('First Name'),
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Required' : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Last Name', isRequired: true),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: controller.lastNameController,
                              decoration: _inputDecoration('Last Name'),
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Required' : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Phone Number
                  _buildLabel('Phone Number'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: controller.phoneController,
                    decoration: _inputDecoration('Enter Number'),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  // Email
                  _buildLabel('Email', isRequired: true),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: controller.emailController,
                    decoration: _inputDecoration('Enter Email'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  // Note
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Note (0/500)',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: controller.noteController,
                    maxLines: 3,
                    maxLength: 500,
                    decoration: _inputDecoration('Details About The Lead'),
                  ),
                  const SizedBox(height: 24),
                  // Submit button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      if (controller.formKey.currentState!.validate()) {
                        // Handle submit
                        Get.back();
                      }
                    },
                    child: const Text('Submit A Lead',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
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
}
