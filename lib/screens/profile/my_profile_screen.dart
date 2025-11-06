import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/company_profile_controller.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/controller/controller_registration.dart';
import 'package:referaly/controller/profile_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/auth/screen_choose_language.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/logo_loader.dart';

class MyProfileScreen extends StatefulWidget {
  static const pageId = '/myProfile';

  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final ProfileController controller = Get.find<ProfileController>();
  int selectedTab = 0; // 0: Personal, 1: Company

  @override
  void initState() {
    super.initState();
    // Only fetch profile if it hasn't been loaded yet
    if (!controller.isProfileLoaded.value) {
      controller.getProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final bool hasChanges = selectedTab == 0
            ? controller.hasPersonalChanges
            : controller.hasCompanyChanges;
        if (!hasChanges) return true;

        final shouldLeave = await _confirmLeaveWithoutSaving(context);
        if (shouldLeave == true) {
          return true;
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        body: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                // ---------------- APP BAR ----------------
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Back button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: GestureDetector(
                          onTap: () async {
                            final bool hasChanges = selectedTab == 0
                                ? controller.hasPersonalChanges
                                : controller.hasCompanyChanges;
                            if (hasChanges) {
                              final leave =
                                  await _confirmLeaveWithoutSaving(context);
                              if (leave != true) return;
                            }
                            Get.find<ControllerMainProfessional>().getProfile();
                            Get.back();
                          },
                          child: Container(
                            height: 42,
                            width: 42,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.arrow_back, size: 20),
                          ),
                        ),
                      ),
                    ),

                    // Title
                    Center(
                      child: Obx(
                        () => Text(
                          selectedTab == 0
                              ? tr(LanguageKeys.myprofile)
                              : tr(LanguageKeys.companyProfile),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.w,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textTitle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // ---------------- TAB SWITCHER ----------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      // Personal Tab
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTab = 0;
                            });
                          },
                          child: Container(
                            height: 70,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: selectedTab == 0
                                  ? AppColors.primary.withOpacity(0.1)
                                  : Colors.white,
                              border: Border(
                                top: BorderSide(
                                  style: BorderStyle.solid,
                                  color: AppColors.grey200,
                                  width: 1,
                                ),
                                bottom: BorderSide(
                                  style: BorderStyle.solid,
                                  color: selectedTab == 0
                                      ? AppColors.primary
                                      : AppColors.grey300,
                                  width: selectedTab == 0 ? 1 : 1,
                                ),
                              ),
                            ),
                            child: Text(
                              tr(LanguageKeys.titlePersonalInformation),
                              textAlign: TextAlign.center,
                              style: stylePoppins(
                                color: selectedTab == 0
                                    ? AppColors.primary
                                    : AppColors.textTitleHint,
                                fontWeight: FontWeight.w400,
                                fontSize: 15.w,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Company Tab
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTab = 1;
                            });

                            // Initialize CompanyProfileController if not already initialized
                            if (!Get.isRegistered<CompanyProfileController>()) {
                              Get.put(CompanyProfileController());
                            }
                            final companyController =
                                Get.find<CompanyProfileController>();
                            companyController.setCompanyData(
                              name:
                                  controller.profile.value?.data?.companyName ??
                                      '',
                              desc: controller.profile.value?.data
                                      ?.companyDescription ??
                                  '',
                              addr: controller
                                      .profile.value?.data?.companyAddress ??
                                  '',
                              code: controller
                                      .profile.value?.data?.companyNumber ??
                                  '',
                              image: controller
                                      .profile.value?.data?.companyLogoUrl ??
                                  '',
                              id: controller.profile.value?.data?.companyId ??
                                  '',
                              countryCode: controller.profile.value?.data
                                      ?.companyCountryCode ??
                                  '',
                              ind: controller.profile.value?.data?.industry ??
                                  '',
                              cntry:
                                  controller.profile.value?.data?.country ?? '',
                            );
                          },
                          child: Container(
                            height: 70,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: selectedTab == 1
                                  ? AppColors.primary.withOpacity(0.1)
                                  : Colors.white,
                              border: Border(
                                top: BorderSide(
                                  style: BorderStyle.solid,
                                  color: AppColors.grey200,
                                  width: 1,
                                ),
                                bottom: BorderSide(
                                  style: BorderStyle.solid,
                                  color: selectedTab == 1
                                      ? AppColors.primary
                                      : AppColors.grey300,
                                  width: selectedTab == 1 ? 1 : 1,
                                ),
                              ),
                            ),
                            child: Text(
                              tr(LanguageKeys.titleBusinessInformation),
                              textAlign: TextAlign.center,
                              style: stylePoppins(
                                color: selectedTab == 1
                                    ? AppColors.primary
                                    : AppColors.textTitleHint,
                                fontWeight: FontWeight.w400,
                                fontSize: 15.w,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ---------------- PROFILE CONTENT ----------------
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: LogoLoader(),
                        ),
                      );
                    }

                    if (controller.error.isNotEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              controller.error.value,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => controller.getProfile(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    // Personal Info Tab
                    if (selectedTab == 0) {
                      return _buildPersonalInfo();
                    }

                    // Company Info Tab
                    return _buildCompanyInfo();
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- PERSONAL INFO ----------------
  Widget _buildPersonalInfo() {
    Widget buildTextField({
      required String label,
      required TextEditingController controller,
      String? Function(String?)? validator,
      TextInputType keyboardType = TextInputType.text,
    }) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel(label, isRequired: validator != null),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            decoration: _inputDecoration(label),
            keyboardType: keyboardType,
            validator: validator,
          ),
          const SizedBox(height: 16),
        ],
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Profile Image
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                        backgroundImage: controller.pickedImage.value != null
                            ? FileImage(controller.pickedImage.value!)
                            : NetworkImage(imagePath) as ImageProvider,
                      );
                    }),
                    Positioned(
                      top: 60,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          showImagePickerSheet(
                            context,
                            controller.pickImageFromCamera,
                            controller.pickImageFromGallery,
                          );
                        },
                        child: SvgPicture.asset(
                          AppAssets.imgCameraSvg,
                          height: 60,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "Tap to change profile picture",
                  style: stylePoppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.fontBlack,
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
                  buildTextField(
                    label: tr(LanguageKeys.firstName),
                    controller: controller.firstNameController,
                    validator: (v) => v == null || v.isEmpty
                        ? tr(LanguageKeys.pleaseEnterFirstName)
                        : null,
                  ),
                  buildTextField(
                    label: tr(LanguageKeys.lastName),
                    controller: controller.lastNameController,
                    validator: (v) => v == null || v.isEmpty
                        ? tr(LanguageKeys.pleaseEnterLastName)
                        : null,
                  ),
                  buildTextField(
                    label: tr(LanguageKeys.email),
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  // Phone field with country code picker
                  _buildLabel(tr(LanguageKeys.phoneNumber), isRequired: true),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      // color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: const Color(0XFFE5E7EB), width: 1),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Get.bottomSheet(
                              _buildCountryPickerBottomSheet(
                                countryList: controller.countries,
                                selectedCountry: controller.selectedCountry,
                              ),
                              isScrollControlled: true,
                              backgroundColor: Colors.white,
                            );
                          },
                          child: Obx(
                            () => Container(
                              width: 60,
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: Colors.grey[300]!,
                                    width: 1,
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                controller.selectedCountry.value.code,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: controller.phoneController,
                            decoration: const InputDecoration(
                              filled: false,
                              border: InputBorder.none,
                              hintText: "Phone Number",
                              focusColor: AppColors.primary,
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (v) => v == null || v.isEmpty
                                ? tr(LanguageKeys.pleaseEnterPhoneNumber)
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildLabel(tr(LanguageKeys.companyType), isRequired: true),
                  const SizedBox(height: 8),
                  Obx(
                    () => DropdownButtonFormField<String>(
                      // disables dropdown if read-only
                      value: tr(controller.userType.value),
                      items: [
                        tr(LanguageKeys.professional),
                        tr(LanguageKeys.individual),
                      ].map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (controller.mainController.dashboard.value
                                      ?.data?.activeDeals?.length ??
                                  0) >
                              8
                          ? null
                          : (val) {
                              controller.setUserType(val!);
                              controller.isEditUserType.value =
                                  val == tr(LanguageKeys.professional);
                            },
                      decoration:
                          _inputDecoration(tr(LanguageKeys.companyType)),
                    ),
                  ),

                  const SizedBox(height: 16),

                  buildTextField(
                    label: tr(LanguageKeys.job),
                    controller: controller.jobController,
                    validator: (v) {
                      if (controller.userType.value == "professional" &&
                          (v == null || v.isEmpty)) {
                        return tr(LanguageKeys.pleaseEnterJob);
                      }
                      return null;
                    },
                  ),
                  buildTextField(
                    label: tr(LanguageKeys.city),
                    controller: controller.cityController,
                    validator: (v) => v == null || v.isEmpty
                        ? tr(LanguageKeys.pleaseEnterCity)
                        : null,
                  ),

                  // Language
                  _buildLabel(tr(LanguageKeys.language), isRequired: true),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => Get.toNamed(ScreenChooseLanguage.pageId),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        // color: Colors.grey[100],
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.languageController.text,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black54,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Submit Button
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
                      onPressed: controller.isLoading.value
                          ? null
                          : () async {
                              if (controller.validateAndSave()) {
                                if (!controller.isLoading.value) {
                                  await controller.updateProfile();
                                }
                              }
                            },
                      child: Obx(
                        () => controller.isLoading.value
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: LogoLoader(color: AppColors.whiteColor),
                              )
                            : Text(
                                tr(LanguageKeys.submit),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),

            _deleteAccountButton(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ---------------- COMPANY INFO ----------------
  Widget _buildCompanyInfo() {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          // Background Image
          SingleChildScrollView(
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
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
                              top: 60,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  showImagePickerSheet(
                                    context,
                                    controller.pickImageFromCamera,
                                    controller.pickImageFromGallery,
                                  );
                                },
                                child: SvgPicture.asset(
                                  AppAssets.imgCameraSvg,
                                  height: 60,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Tap to change profile picture",
                            style: stylePoppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.fontBlack,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        _buildTextField(
                          tr(LanguageKeys.companyName),
                          controller.nameController,
                          isRequired: true,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          tr(LanguageKeys.description),
                          controller.descriptionController,
                          maxLines: 4,
                          isRequired: true,
                          counter:
                              '${controller.descriptionController.text.length} /200',
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          tr(LanguageKeys.companyAddress),
                          controller.addressController,
                          isRequired: true,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          "${tr(LanguageKeys.companyPhoneNumber)}(${tr(LanguageKeys.comapnyLabel)})",
                          controller.businessCodeController,
                          keyboardType: TextInputType.number,
                        ),
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
                                      child: LogoLoader(
                                        color: AppColors.whiteColor,
                                      ),
                                    )
                                  : Text(
                                      tr(LanguageKeys.submit),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: AppColors.whiteColor,
                                      ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    bool isRequired = false,
    String? counter,
    TextInputType keyboardType = TextInputType.text,
  }) {
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
            hintText: '$label',
            fillColor: const Color(0XFFE5E7EB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0XFFE5E7EB), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0XFFE5E7EB), width: 1),
            ),
            counterText: "", // Remove the counter from bottom
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0XFFE5E7EB), width: 1),
            ),
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

  // ---------------- DELETE ACCOUNT ----------------
  Widget _deleteAccountButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  insetPadding: const EdgeInsets.all(20),
                  backgroundColor: AppColors.grey100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          tr(LanguageKeys.deleteAccountConfirmation),
                          style: stylePoppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.blackColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.fontBlack,
                                  side: BorderSide(
                                    color: AppColors.fontBlack,
                                    width: 1,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 17,
                                  ),
                                ),
                                onPressed: () => Get.back(),
                                child: Text(
                                  tr(LanguageKeys.cancel),
                                  style: stylePoppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 17,
                                  ),
                                ),
                                onPressed: () async {
                                  await controller.deleteAccount();
                                },
                                child: Text(
                                  tr(LanguageKeys.yes),
                                  style: stylePoppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: Text(
              tr(LanguageKeys.deleteAccount),
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
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
      filled: false,
      fillColor: const Color(0XFFE5E7EB),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0XFFE5E7EB), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0XFFE5E7EB), width: 1),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0XFFE5E7EB), width: 1),
      ),
      hintText: hint,
      prefixText: prefixText,
    );
  }

  Future<bool?> _confirmLeaveWithoutSaving(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          backgroundColor: AppColors.grey100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "You're leaving without saving info. Save changes?",
                  style: stylePoppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.blackColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.fontBlack,
                          side: BorderSide(
                            color: AppColors.fontBlack,
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 17,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(false); // don't leave
                        },
                        child: Text(
                          tr(LanguageKeys.no),
                          style: stylePoppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 17,
                          ),
                        ),
                        onPressed: () async {
                          // if (selectedTab == 0) {
                          //   if (!controller.isLoading.value &&
                          //       controller.validateAndSave()) {
                          //     await controller.updateProfile();
                          //   }
                          // } else {
                          //   if (!controller.isLoading.value) {
                          //     await controller.updateCompanyProfile();
                          //   }
                          // }
                          Navigator.of(context).pop(true); // leave after saving
                        },
                        child: Text(
                          tr(LanguageKeys.yes),
                          style: stylePoppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showImagePickerSheet(
    BuildContext context,
    VoidCallback onCamera,
    VoidCallback onGallery,
  ) {
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
                  child: Text(
                    tr(LanguageKeys.takePicture),
                    style: TextStyle(fontSize: 18, color: AppColors.whiteColor),
                  ),
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
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    tr(LanguageKeys.choosefromlib),
                    style:
                        const TextStyle(fontSize: 18, color: AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCountryPickerBottomSheet({
    required List<Country> countryList,
    required Rx<Country> selectedCountry,
  }) {
    return SafeArea(
      child: Container(
        height: Get.height,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.close, color: Colors.black),
              alignment: Alignment.centerLeft,
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: ListView.separated(
                itemCount: countryList.length,
                separatorBuilder: (_, __) => Divider(color: AppColors.grey200),
                itemBuilder: (context, index) {
                  final country = countryList[index];
                  return ListTile(
                    minVerticalPadding: 0,
                    minTileHeight: 40,
                    onTap: () {
                      selectedCountry.value = country;
                      Get.back();
                    },
                    leading: Text(
                      country.emoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                    title: Text(country.name),
                    // trailing: Text(country.code),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
