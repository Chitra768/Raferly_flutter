import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/models/model_lead_create.dart';
import 'package:referaly/models/model_outofraferaly.dart';
import 'package:referaly/resources/app_assets.dart' show AppAssets;
import 'package:referaly/resources/app_colors.dart' show AppColors;
import 'package:referaly/resources/text_style.dart' show stylePoppins;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class OutOfReferalyScreen extends StatelessWidget {
  static String pageId = "/outOfReferalyDialog";

  OutOfReferalyScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _descController = TextEditingController();
  final List<String> commissionOptions = [
    'No Commission',
    'Fix Commission',
    'Percentage Commission'
  ];

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                Text('Lead Information',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
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
                      items: commissionOptions
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
      )),
    );
  }

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final Rx<ModelOutofraferaly?> lead = Rx<ModelOutofraferaly?>(null);

  Future<void> createLead() async {
    isLoading.value = true;
    error.value = '';
    try {
      final response = await RESTAuth.createLeadOutofRaferaly(
        _firstNameController.text,
        _lastNameController.text,
        _phoneController.text,
        _emailController.text,
        _descController.text,
        _selectedCommission.value ?? '',
        _selectedCommission.value ?? '',
        _trackingSteps.join(', '),
      );
      if (response is ApiSuccess<ModelOutofraferaly>) {
        lead.value = response.data;
        if (response.data.data?.dealDetail?.inviteLink != null) {
          _onCreateLeadSuccess(
              Get.context!, response.data.data!.dealDetail!.inviteLink!);
        }
      } else if (response is ApiFailure) {
        error.value = response.error.message ?? 'Something went wrong';
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
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
          createLead();
          // Get.back();
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

  void _onCreateLeadSuccess(BuildContext context, String link) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return YourCustomDialog(message: link);
      },
    );
  }
}

class YourCustomDialog extends StatelessWidget {
  final String message;
  const YourCustomDialog({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Split the message at the first colon
    List<String> parts = message.split(":");
    String textPart = parts[0];
    String linkPart = parts.length > 1 ? parts.sublist(1).join(":").trim() : "";

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.all(20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "HERE IS YOUR LINK",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.purple,
              fontSize: 22,
            ),
          ),
          SizedBox(height: 16),
          Text(
            textPart,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  readOnly: true,
                  controller: TextEditingController(text: linkPart),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),
              ),
              SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.copy, color: Colors.purple),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: linkPart));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Link copied!")),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 18),
          Text("Share easily on", style: TextStyle(fontSize: 14)),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.wallet, color: Colors.green),
                  onPressed: () {/* Share via WhatsApp */},
                ),
                IconButton(
                  icon: Icon(Icons.sms, color: Colors.blue),
                  onPressed: () {/* Share via SMS */},
                ),
                IconButton(
                  icon: Icon(Icons.wallet, color: Colors.blue[700]),
                  onPressed: () {/* Share via LinkedIn */},
                ),
                IconButton(
                  icon: Icon(Icons.facebook, color: Colors.blue),
                  onPressed: () {/* Share via Facebook */},
                ),
                IconButton(
                  icon: Icon(Icons.email, color: Colors.blueGrey),
                  onPressed: () {/* Share via Email */},
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt, color: Colors.purple),
                  onPressed: () {/* Share via Instagram */},
                ),
              ],
            ),
          ),
          SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "I have shared my link already",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
