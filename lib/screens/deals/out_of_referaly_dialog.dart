import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_outofraferaly.dart';
import 'package:referaly/resources/app_assets.dart' show AppAssets;
import 'package:referaly/resources/app_colors.dart' show AppColors;
import 'package:referaly/resources/text_style.dart' show stylePoppins;
import 'package:flutter/services.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/logo_loader.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class OutOfReferalyScreen extends StatefulWidget {
  static String pageId = "/outOfReferalyDialog";

  const OutOfReferalyScreen({super.key});

  @override
  State<OutOfReferalyScreen> createState() => _OutOfReferalyScreenState();
}

class _OutOfReferalyScreenState extends State<OutOfReferalyScreen> {
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
    TextEditingController(text: tr(LanguageKeys.meetingScheduled)),
    TextEditingController(text: tr(LanguageKeys.contractSigned)),
  ].obs;

  final _commissionValueController = TextEditingController();
  final _agreementNameController = TextEditingController();
  final _title = ''.obs;
  final RxBool isOneTimeContract = true.obs;
  final RxBool isAgreementNameEditing = false.obs;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args != null && args['title'] != null) {
      _title.value = args['title'];
      _agreementNameController.text = args['title'];
    } else {
      _agreementNameController.text = tr(LanguageKeys.referralAgreement);
    }
  }

  @override
  void dispose() {
    _agreementNameController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          tr(LanguageKeys.sendReferral),
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildUninvitedInfoBox(),
                      SizedBox(height: 24.h),
                      _buildReferralAgreementSection(),
                      SizedBox(height: 24.h),
                      _buildContractTypeSection(),
                      SizedBox(height: 24.h),
                      _buildLeadInfoSection(),
                      SizedBox(height: 24.h),
                      _buildCommissionSection(),
                      SizedBox(height: 24.h),
                      _buildTrackingStepsSection(),
                      SizedBox(height: 8.h),
                      buildAddNewButton(),
                      SizedBox(height: 32.h),
                      _buildGenerateButton(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUninvitedInfoBox() {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.blueColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              color: AppColors.blueColor2,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.info_outline, size: 18.w, color: Colors.white),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr(LanguageKeys.uninvitedProfessional),
                  style: stylePoppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.fontBlack,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  tr(LanguageKeys.outOfReferalyInfo),
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.greyFontColor,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferralAgreementSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr(LanguageKeys.referralAgreementName),
          style: stylePoppins(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: AppColors.fontBlack,
          ),
        ),
        SizedBox(height: 8.h),
        Obx(() {
          if (isAgreementNameEditing.value) {
            return _buildAgreementNameTextField();
          }
          return _buildAgreementNameDisplay();
        }),
      ],
    );
  }

  Widget _buildAgreementNameDisplay() {
    return GestureDetector(
      onTap: () => isAgreementNameEditing.value = true,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.textFieldBorderColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.textFieldColor,
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _agreementNameController.text.isEmpty
                    ? tr(LanguageKeys.referralAgreement)
                    : _agreementNameController.text,
                style: stylePoppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: _agreementNameController.text.isEmpty
                      ? AppColors.textTitleHint
                      : AppColors.fontBlack,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => isAgreementNameEditing.value = true,
              child: Icon(
                Icons.edit_outlined,
                size: 20.w,
                color: AppColors.greyFontColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgreementNameTextField() {
    return TextFormField(
      controller: _agreementNameController,
      autofocus: true,
      decoration: _inputDecoration(tr(LanguageKeys.referralAgreement)).copyWith(
        suffixIcon: GestureDetector(
          onTap: () => isAgreementNameEditing.value = false,
          child: Icon(
            Icons.edit_outlined,
            size: 20.w,
            color: AppColors.greyFontColor,
          ),
        ),
      ),
    );
  }

  Widget _buildContractTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr(LanguageKeys.contractType),
          style: stylePoppins(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: AppColors.fontBlack,
          ),
        ),
        SizedBox(height: 12.h),
        Obx(
          () => IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildContractTypeCard(
                    isSelected: isOneTimeContract.value,
                    icon: Icons.send_outlined,
                    title: tr(LanguageKeys.oneTime),
                    description: tr(LanguageKeys.oneTimeDescription),
                    onTap: () => isOneTimeContract.value = true,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildContractTypeCard(
                    isSelected: !isOneTimeContract.value,
                    icon: Icons.refresh,
                    title: tr(LanguageKeys.recurrent),
                    description: tr(LanguageKeys.recurrentDescription),
                    onTap: () => isOneTimeContract.value = false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContractTypeCard({
    required bool isSelected,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.primary.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.textFieldColor,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              icon,
              size: 24.w,
              color: isSelected ? AppColors.primary : AppColors.greyFontColor,
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: stylePoppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.fontBlack,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              description,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.greyFontColor,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                tr(LanguageKeys.leadInfo),
                style: stylePoppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: AppColors.fontBlack,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                tr(LanguageKeys.required),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.greyFontColor,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel(tr(LanguageKeys.firstName), isRequired: true),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: _firstNameController,
                    decoration:
                        _inputDecoration(tr(LanguageKeys.enterFirstName)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return tr(LanguageKeys.firastNameError);
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel(tr(LanguageKeys.lastName), isRequired: true),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: _lastNameController,
                    decoration:
                        _inputDecoration(tr(LanguageKeys.enterLastName)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return tr(LanguageKeys.lastNameError);
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        _buildLabel(tr(LanguageKeys.phoneNumber)),
        SizedBox(height: 8.h),
        TextFormField(
          controller: _phoneController,
          decoration: _inputDecoration(tr(LanguageKeys.enterNum)).copyWith(
            prefixIcon: Icon(
              Icons.phone_outlined,
              size: 20.w,
              color: AppColors.greyFontColor,
            ),
          ),
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 16.h),
        _buildLabel(tr(LanguageKeys.email), isRequired: true),
        SizedBox(height: 8.h),
        TextFormField(
          controller: _emailController,
          decoration: _inputDecoration(tr(LanguageKeys.enterEmail)).copyWith(
            prefixIcon: Icon(
              Icons.email_outlined,
              size: 20.w,
              color: AppColors.greyFontColor,
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return tr(LanguageKeys.emptyEmail);
            }
            final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
            if (!emailRegex.hasMatch(value)) {
              return tr(LanguageKeys.invalidEmail);
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        _buildLabel(tr(LanguageKeys.description), isRequired: true),
        SizedBox(height: 8.h),
        TextFormField(
          controller: _descController,
          maxLines: 3,
          decoration: _inputDecoration(tr(LanguageKeys.enterDescriptionErr)),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return tr(LanguageKeys.enterDescriptionErr);
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCommissionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr(LanguageKeys.commissionPreferences),
          style: stylePoppins(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: AppColors.fontBlack,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.textFieldColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel(tr(LanguageKeys.desiredCommissionType),
                  isRequired: true),
              SizedBox(height: 8.h),
              Obx(
                () => DropdownButtonFormField<String>(
                  value: _selectedCommission.value,
                  isExpanded: true,
                  icon: const SizedBox.shrink(),
                  items: commissionOptions
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (val) => _selectedCommission.value = val,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return tr(LanguageKeys.pleaseSelectCommType);
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: tr(LanguageKeys.chooseOneoption),
                    filled: true,
                    fillColor: AppColors.textFieldBorderColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: AppColors.textFieldColor),
                    ),
                    hintStyle: TextStyle(
                        fontSize: 14.sp, color: AppColors.textTitleHint),
                    suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                  ),
                ),
              ),
              Obx(() {
                if (_selectedCommission.value ==
                        tr(LanguageKeys.fix_commission) ||
                    _selectedCommission.value ==
                        tr(LanguageKeys.percentage_commission)) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.h),
                      _buildLabel(tr(LanguageKeys.value), isRequired: false),
                      SizedBox(height: 8.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _commissionValueController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.textFieldBorderColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide(
                                      color: AppColors.textFieldColor),
                                ),
                                hintText: tr(LanguageKeys.enterCommissionValue),
                                hintStyle: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.textTitleHint),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 16.h),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            _selectedCommission.value ==
                                    tr(LanguageKeys.fix_commission)
                                ? '€'
                                : '%',
                            style: stylePoppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: AppColors.fontBlack,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ],
    );
  }

  void _reorderTrackingSteps(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    if (oldIndex < 0 ||
        oldIndex >= _trackingSteps.length ||
        newIndex < 0 ||
        newIndex > _trackingSteps.length) {
      return;
    }
    final controller = _trackingSteps.removeAt(oldIndex);
    _trackingSteps.insert(newIndex, controller);
  }

  Widget _buildTrackingStepsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              tr(LanguageKeys.trackingSteps),
              style: stylePoppins(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: AppColors.fontBlack,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                _trackingSteps.clear();
                _trackingSteps.addAll([
                  TextEditingController(text: tr(LanguageKeys.contactCalled)),
                  TextEditingController(
                      text: tr(LanguageKeys.meetingScheduled)),
                  TextEditingController(text: tr(LanguageKeys.contractSigned)),
                ]);
              },
              child: Text(
                tr(LanguageKeys.resetDefault),
                style: stylePoppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Text(
          tr(LanguageKeys.trackingStepsDescription),
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.greyFontColor,
            height: 1.4,
          ),
        ),
        SizedBox(height: 12.h),
        Obx(
          () => ReorderableListView.builder(
            key: const PageStorageKey('tracking_steps_list'),
            shrinkWrap: true,
            primary: false,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            buildDefaultDragHandles: false,
            itemCount: _trackingSteps.length,
            onReorder: _reorderTrackingSteps,
            itemBuilder: (context, index) {
              final i = index;
              return ReorderableDelayedDragStartListener(
                key: ValueKey(_trackingSteps[i]),
                index: index,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.textFieldColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.drag_indicator,
                          size: 24.w,
                          color: AppColors.greyFontColor,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: TextFormField(
                            controller: _trackingSteps[i],
                            style: stylePoppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.fontBlack,
                            ),
                            decoration: InputDecoration(
                              hintText: tr(LanguageKeys.enterTrackName),
                              filled: true,
                              fillColor: Colors.transparent,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 8.h),
                              hintStyle: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.textTitleHint),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        GestureDetector(
                          onTap: () => _trackingSteps.removeAt(i),
                          child: Icon(
                            Icons.delete_outline,
                            size: 22.w,
                            color: AppColors.iconColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 18.h),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (_selectedCommission.value == tr(LanguageKeys.fix_commission) ||
                _selectedCommission.value ==
                    tr(LanguageKeys.percentage_commission)) {
              if (_commissionValueController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text(tr(LanguageKeys.pleaseEnterCommissionValue))),
                );
                return;
              }
            }
            createLead();
          }
        },
        child: Obx(
          () => isLoading.value
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: LogoLoader(color: AppColors.whiteColor),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.send_outlined, size: 20.w, color: Colors.white),
                    SizedBox(width: 8.w),
                    Text(
                      tr(LanguageKeys.generateAndShareContract),
                      style: stylePoppins(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
        ),
      ),
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
        _commissionValueController.text,
        trackNameList,
        referralAgreementName: _agreementNameController.text.trim().isEmpty
            ? null
            : _agreementNameController.text.trim(),
        contractType: isOneTimeContract.value ? '2' : '1',
      );
      if (response is ApiSuccess<ModelOutofraferaly>) {
        lead.value = response.data;
        if (response.data.data?.dealDetail?.inviteLink != null) {
          _onCreateLeadSuccess(
              Get.context!,
              response.data.data!.dealDetail!.inviteLink!,
              response.data.data!.dealDetail!.deepLink!);
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

  Widget _buildLabel(String label, {bool isRequired = false}) {
    return Row(
      children: [
        Flexible(
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        ),
        if (isRequired)
          const Text(
            ' *',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.textFieldBorderColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.textFieldColor,
          width: 1.2,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.textFieldColor,
          width: 1.2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.textFieldColor,
          width: 1.5,
        ),
      ),
      hintText: hint,
      hintStyle: TextStyle(fontSize: 14, color: AppColors.textTitleHint),
    );
  }

  Widget buildAddNewButton() {
    return GestureDetector(
      onTap: () {
        _trackingSteps.add(TextEditingController());
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.primary,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              color: AppColors.primary,
              size: 24.w,
            ),
            SizedBox(width: 10.w),
            Text(
              tr(LanguageKeys.addNewStep),
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

  void _onCreateLeadSuccess(
      BuildContext context, String link, String deepLink) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return YourCustomDialog(message: link, deepLink: deepLink);
      },
    );
  }
}

class YourCustomDialog extends StatelessWidget {
  final String message;
  final String deepLink;
  const YourCustomDialog(
      {super.key, required this.message, required this.deepLink});

  @override
  Widget build(BuildContext context) {
    // Split the message at the first colon
    List<String> parts = message.split(":");
    String textPart = parts[0];
    String linkPart = parts.length > 1 ? parts.sublist(1).join(":").trim() : "";

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
            const SizedBox(height: 16),
            Text(
              tr(LanguageKeys.shareTheFollowing),
              textAlign: TextAlign.center,
              style: stylePoppins(
                fontWeight: FontWeight.w500,
                color: AppColors.blackColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(
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
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
                    controller: TextEditingController(text: deepLink),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      hintStyle:
                          TextStyle(fontSize: 14, color: Colors.grey[400]),
                    ),
                    style: const TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                ),
                const SizedBox(width: 8),
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
                      Clipboard.setData(ClipboardData(text: deepLink));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Link copied!")),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(tr(LanguageKeys.shareEasily),
                style: stylePoppins(
                  fontWeight: FontWeight.w500,
                  color: AppColors.blackColor,
                  fontSize: 14,
                )),
            const SizedBox(height: 20),
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
                    onPressed: () => _share(context, 'whatsapp', deepLink),
                  ),
                  IconButton(
                    icon: Image.asset(AppAssets.imgMessage, width: 35),
                    onPressed: () => _share(context, 'message', deepLink),
                  ),
                  IconButton(
                    icon: Image.asset(AppAssets.imgLinkedin,
                        width: 35), // LinkedIn placeholder
                    onPressed: () => _share(context, 'linkedin', deepLink),
                  ),
                  IconButton(
                    icon: Image.asset(AppAssets.imgFacebook,
                        width: 35), // Facebook placeholder
                    onPressed: () => _share(context, 'facebook', deepLink),
                  ),
                  IconButton(
                    icon: Image.asset(AppAssets.imgEmail, width: 35),
                    onPressed: () => _share(context, 'email', deepLink),
                  ),

                  IconButton(
                    icon: Image.asset(AppAssets.imgInstagram,
                        width: 35), // Instagram placeholder
                    onPressed: () => _share(context, 'instagram', deepLink),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 38),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
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
