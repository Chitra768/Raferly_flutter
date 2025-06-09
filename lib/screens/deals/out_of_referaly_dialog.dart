import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_lead_create.dart';
import 'package:referaly/models/model_outofraferaly.dart';
import 'package:referaly/resources/app_assets.dart' show AppAssets;
import 'package:referaly/resources/app_colors.dart' show AppColors;
import 'package:referaly/resources/text_style.dart' show stylePoppins;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:referaly/utils/translations.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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
    tr(LanguageKeys.no_commission),
    tr(LanguageKeys.fix_commission),
    tr(LanguageKeys.percentage_commission),
  ];

  final RxnString _selectedCommission = RxnString();
  final RxList<TextEditingController> _trackingSteps = [
    TextEditingController(text: tr(LanguageKeys.contactCalled)),
    TextEditingController(text: tr(LanguageKeys.contractSigned)),
    TextEditingController(text: tr(LanguageKeys.serviceDeleiverd)),
    TextEditingController(text: tr(LanguageKeys.paymentReceived)),
  ].obs;

  final _commissionValueController = TextEditingController();

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
                    Expanded(
                      child: Center(
                        child: Text(
                          tr(LanguageKeys.outOf),
                          style: stylePoppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
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
                Text(
                  tr(LanguageKeys.outOfReferalyInfo),
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                Text(tr(LanguageKeys.leadInfo),
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
                          _buildLabel(tr(LanguageKeys.firstName)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _firstNameController,
                            decoration: _inputDecoration(
                                tr(LanguageKeys.enterFirstName)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel(tr(LanguageKeys.lastName)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _lastNameController,
                            decoration: _inputDecoration(
                                tr(LanguageKeys.enterLastName)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildLabel(tr(LanguageKeys.phoneNumber)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  decoration: _inputDecoration(tr(LanguageKeys.enterNum)),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                _buildLabel(tr(LanguageKeys.email)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  decoration: _inputDecoration(tr(LanguageKeys.enterEmail)),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                _buildLabel(tr(LanguageKeys.description)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descController,
                  maxLines: 3,
                  decoration:
                      _inputDecoration(tr(LanguageKeys.enterDescriptionErr)),
                ),
                const SizedBox(height: 18),
                _buildLabel(tr(LanguageKeys.commisionTitle)),
                const SizedBox(height: 8),
                Obx(() => DropdownButtonFormField<String>(
                      value: _selectedCommission.value,
                      items: commissionOptions
                          .map((type) =>
                              DropdownMenuItem(value: type, child: Text(type)))
                          .toList(),
                      onChanged: (val) => _selectedCommission.value = val,
                      decoration: InputDecoration(
                        hintText: tr(LanguageKeys.chooseOneoption),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none),
                      ),
                    )),
                Obx(() {
                  if (_selectedCommission.value ==
                          tr(LanguageKeys.fix_commission) ||
                      _selectedCommission.value ==
                          tr(LanguageKeys.percentage_commission)) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          tr(LanguageKeys.commisionValue),
                          style: stylePoppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _commissionValueController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            hintText: tr(LanguageKeys.enterCommissionValue),
                            suffixIcon: _selectedCommission.value ==
                                    tr(LanguageKeys.fix_commission)
                                ? Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text('€',
                                        style: TextStyle(fontSize: 18)),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text('%',
                                        style: TextStyle(fontSize: 18)),
                                  ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    );
                  }
                  return SizedBox.shrink();
                }),
                const SizedBox(height: 18),
                _buildLabel(tr(LanguageKeys.outOfTrackName)),
                const SizedBox(height: 8),
                Obx(() => Column(
                      children: [
                        ...List.generate(
                          _trackingSteps.length,
                          (i) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _trackingSteps[i],
                                      decoration: _inputDecoration(
                                          tr(LanguageKeys.enterTrackName)),
                                    ),
                                  ),
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
                            );
                          },
                        ),
                        TextFormField(
                          initialValue: tr(LanguageKeys.commisionPaid),
                          enabled: false,
                          decoration: _inputDecoration(''),
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
    List<String> trackNameList =
        _trackingSteps.map((field) => field.text).toList();
    try {
      final response = await RESTAuth.createLeadOutofRaferaly(
        _firstNameController.text,
        _lastNameController.text,
        _phoneController.text,
        _emailController.text,
        _descController.text,
        _selectedCommission.value ?? '',
        _selectedCommission.value ?? '',
       trackNameList,
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
        _trackingSteps.add(TextEditingController());
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
              tr(LanguageKeys.addnew),
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
          child: Obx(
            () => isLoading.value
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    tr(LanguageKeys.generateAContract),
                    style: stylePoppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
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
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      content: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tr(LanguageKeys.hereIsYour).toUpperCase()!,
              style: stylePoppins(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 16),
            Text(
              tr(LanguageKeys.shareTheFollowing),
              textAlign: TextAlign.center,
              style: stylePoppins(
                fontWeight: FontWeight.w500,
                color: AppColors.blackColor,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              tr(LanguageKeys.youWillBeProtected),
              textAlign: TextAlign.center,
              style: stylePoppins(
                fontWeight: FontWeight.w500,
                color: AppColors.greyFontColor,
                fontSize: 14,
              ),
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
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      AppAssets.imgLink,
                      width: 20,
                      height: 20,
                      color: AppColors.whiteColor,
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: linkPart));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Link copied!")),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 18),
            Text(tr(LanguageKeys.shareEasily),
                style: stylePoppins(
                  fontWeight: FontWeight.w500,
                  color: AppColors.blackColor,
                  fontSize: 14,
                )),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Replace these with your own SVGs or images for each platform
                  IconButton(
                    icon: Image.asset(AppAssets.imgWhatsapp,
                        width: 35), // WhatsApp placeholder
                    // WhatsApp placeholder
                    onPressed: () => _share(context, 'whatsapp', linkPart),
                  ),
                  IconButton(
                    icon: Image.asset(AppAssets.imgMessage, width: 35),
                    onPressed: () => _share(context, 'message', linkPart),
                  ),
                  IconButton(
                    icon: Image.asset(AppAssets.imgLinkedin,
                        width: 35), // LinkedIn placeholder
                    onPressed: () => _share(context, 'linkedin', linkPart),
                  ),
                  IconButton(
                    icon: Image.asset(AppAssets.imgFacebook,
                        width: 35), // Facebook placeholder
                    onPressed: () => _share(context, 'facebook', linkPart),
                  ),
                  IconButton(
                    icon: Image.asset(AppAssets.imgEmail, width: 35),
                    onPressed: () => _share(context, 'email', linkPart),
                  ),

                  IconButton(
                    icon: Image.asset(AppAssets.imgInstagram,
                        width: 35), // Instagram placeholder
                    onPressed: () => _share(context, 'instagram', linkPart),
                  ),
                ],
              ),
            ),
            SizedBox(height: 38),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Get.back();
                },
                child: Text(
                  tr(LanguageKeys.iHaveSharedMy),
                  style: stylePoppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _share(BuildContext context, String platform, String link) async {
  final encodedLink = Uri.encodeComponent(link);
  String? url;

  switch (platform) {
    case 'whatsapp':
      url = 'whatsapp://send?text=$encodedLink';
      break;

    case 'message':
      url = 'sms:?body=$encodedLink';
      break;

    case 'email':
      url = 'mailto:?subject=Check this out&body=$encodedLink';
      break;

    case 'facebook':
      url = 'https://www.facebook.com/sharer/sharer.php?u=$encodedLink';
      break;

    case 'linkedin':
      url = 'https://www.linkedin.com/sharing/share-offsite/?url=$encodedLink';
      break;

    case 'instagram':
      // Instagram does not support direct link sharing via URL scheme,
      // you can instead fallback to a general share sheet:
      Share.share(link);
      return;

    default:
      Share.share(link);
      return;
  }

  if (url != null && await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } else {
    // fallback: open general share sheet
    Share.share(link);
  }
}
