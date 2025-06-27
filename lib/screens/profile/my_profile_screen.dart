import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/controller/edit_company_profile_controller.dart';
import 'package:referaly/controller/edit_profile_controller.dart'
    show EditProfileController;
import 'package:referaly/controller/my_profile_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/auth/screen_welcome.dart';
import 'package:referaly/screens/company_profile/edit_company_profile.dart';
import 'package:referaly/screens/edit_profile_screen.dart'
    show EditProfileScreen;
import 'package:referaly/screens/profile/company_profile_screen.dart'
    show CompanyProfileScreen;
import 'package:referaly/utils/translations.dart';
import 'package:referaly/controller/company_profile_controller.dart';

class MyProfileScreen extends StatefulWidget {
  static const pageId = '/myProfile';

  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final MyProfileController controller = Get.put(MyProfileController());
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
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
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
              const SizedBox(height: 40),
              // Tab Switcher
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTab = 0;
                          });
                        },
                        child: Container(
                          height: 38,
                          decoration: BoxDecoration(
                            color: selectedTab == 0
                                ? AppColors.primary
                                : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: AppColors.transparent, width: 2),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            tr(LanguageKeys.titlePersonalInformation),
                            style: TextStyle(
                              color: selectedTab == 0
                                  ? Colors.white
                                  : AppColors.textTitleHint,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.w,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
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
                            name: controller.profile.value?.data?.companyName ??
                                '',
                            desc: controller
                                    .profile.value?.data?.companyDescription ??
                                '',
                            addr: controller
                                    .profile.value?.data?.companyAddress ??
                                '',
                            code:
                                controller.profile.value?.data?.companyNumber ??
                                    '',
                            image: controller
                                    .profile.value?.data?.companyLogoUrl ??
                                '',
                            id: controller.profile.value?.data?.companyId ?? '',
                            countryCode: controller
                                    .profile.value?.data?.companyCountryCode ??
                                '',
                            ind: controller.profile.value?.data?.industry ?? '',
                            cntry:
                                controller.profile.value?.data?.country ?? '',
                          );
                        },
                        child: Container(
                          height: 38,
                          decoration: BoxDecoration(
                            color: selectedTab == 1
                                ? AppColors.primary
                                : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: AppColors.transparent, width: 2),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            tr(LanguageKeys.titleBusinessInformation),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: selectedTab == 1
                                  ? Colors.white
                                  : AppColors.textTitleHint,
                              fontWeight: FontWeight.w600,
                              fontSize: 12.w,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Custom App Bar
              Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: GestureDetector(
                        onTap: () {
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
                          child: const Icon(Icons.arrow_back_ios_new, size: 20),
                        ),
                      ),
                    ),
                  ),
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
                            color: AppColors.textTitle),
                      ),
                    ),
                  ),
                  Obx(
                    () => controller.isLoading.value == true
                        ? const SizedBox()
                        : Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: GestureDetector(
                                onTap: () {
                                  if (controller.isLoading.value == true) {
                                    return;
                                  }
                                  if (selectedTab == 0) {
                                    // Handle personal profile edit
                                    if (!Get.isRegistered<
                                        EditProfileController>()) {
                                      Get.put(EditProfileController());
                                    }
                                    final editController =
                                        Get.find<EditProfileController>();
                                    editController.setCompanyData(
                                      firstName: controller.firstName,
                                      lastName: controller.lastName,
                                      city: controller.city,
                                      email: controller.email,
                                      image: controller.profileImage,
                                      countryCode: controller.countryCode,
                                      job: controller.job,
                                      language: controller.language,
                                      phone: controller.phone,
                                      userType1: controller.userType,
                                      isPaid: controller.isPaid,
                                    );
                                    Get.toNamed(EditProfileScreen.pageId);
                                  } else {
                                    if (!Get.isRegistered<
                                        EditCompanyProfileController>()) {
                                      Get.put(EditCompanyProfileController());
                                    }
                                    final companyController = Get.find<
                                        EditCompanyProfileController>();
                                    companyController.setCompanyData(
                                      name: controller.profile.value?.data
                                              ?.companyName ??
                                          '',
                                      desc: controller.profile.value?.data
                                              ?.companyDescription ??
                                          '',
                                      addr: controller.profile.value?.data
                                              ?.companyAddress ??
                                          '',
                                      code: controller.profile.value?.data
                                              ?.companyNumber ??
                                          '',
                                      image: controller.profile.value?.data
                                              ?.companyLogoUrl ??
                                          '',
                                      id: controller
                                              .profile.value?.data?.companyId ??
                                          '',
                                      countryCode: controller.profile.value
                                              ?.data?.companyCountryCode ??
                                          '',
                                      ind: controller
                                              .profile.value?.data?.industry ??
                                          '',
                                      cntry: controller
                                              .profile.value?.data?.country ??
                                          '',
                                    );
                                    Get.toNamed(
                                        EditCompanyProfileScreen.pageId);
                                  }
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      border: Border.all(
                                          color: AppColors.primary, width: 3),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: SvgPicture.asset(
                                      AppAssets.imgEditIcon,
                                      color: Colors.white,
                                      height: 18,
                                    )),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(
                        child: SizedBox(
                      width: 24,
                      height: 24,
                      child: LoadingIndicator(
                        indicatorType: Indicator.lineSpinFadeLoader,
                        colors: [AppColors.primary],
                      ),
                    ));
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

                  // Only show personal info if selectedTab == 0
                  if (selectedTab == 0) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            // Profile image with edit button
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.grey[200],
                                    backgroundImage: controller
                                            .profileImage.isNotEmpty
                                        ? NetworkImage(controller.profileImage)
                                        : null,
                                    child: controller.profileImage.isEmpty
                                        ? const Icon(Icons.account_circle,
                                            size: 80, color: Colors.blue)
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            _profileField(tr(LanguageKeys.firstName),
                                controller.firstName),
                            _profileField(
                                tr(LanguageKeys.lastName), controller.lastName),
                            _profileField(
                                tr(LanguageKeys.email), controller.email),
                            _profileField(
                                tr(LanguageKeys.phoneNumber), controller.phone),
                            _profileField(tr(LanguageKeys.companyType),
                                controller.userType),
                            _profileField(tr(LanguageKeys.job), controller.job),
                            _profileField(
                                tr(LanguageKeys.city), controller.city),
                            _profileField(
                                tr(LanguageKeys.language), controller.language),
                            const SizedBox(height: 24),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Column(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                                insetPadding:
                                                    const EdgeInsets.all(20),
                                                backgroundColor:
                                                    AppColors.grey100,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      24.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        tr(LanguageKeys
                                                            .deleteAccountConfirmation),
                                                        style: stylePoppins(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: AppColors
                                                              .blackColor,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      const SizedBox(
                                                          height: 24),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                OutlinedButton(
                                                              style:
                                                                  OutlinedButton
                                                                      .styleFrom(
                                                                foregroundColor:
                                                                    AppColors
                                                                        .fontBlack,
                                                                side: BorderSide(
                                                                    color: AppColors
                                                                        .fontBlack,
                                                                    width: 1),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            17),
                                                              ),
                                                              onPressed: () {
                                                                Get.back();
                                                              },
                                                              child: Text(
                                                                tr(LanguageKeys
                                                                    .cancel),
                                                                style:
                                                                    stylePoppins(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 16),
                                                          Expanded(
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    AppColors
                                                                        .primary,
                                                                foregroundColor:
                                                                    Colors
                                                                        .white,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            17),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                await controller
                                                                    .deleteAccount();
                                                              },
                                                              child: Text(
                                                                tr(LanguageKeys
                                                                    .yes),
                                                                style:
                                                                    stylePoppins(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ));
                                    },
                                    child: Text(
                                      tr(LanguageKeys.deleteAccount),
                                      style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    );
                  } else {
                    // Show company profile information
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            SizedBox(height: 16.w),
                            // Company logo/profile image
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.grey[200],
                                    backgroundImage: controller
                                                .profile
                                                .value
                                                ?.data
                                                ?.companyLogoUrl
                                                ?.isNotEmpty ==
                                            true
                                        ? NetworkImage(controller.profile.value!
                                            .data!.companyLogoUrl!)
                                        : null,
                                    child: controller.profile.value?.data
                                                ?.companyLogoUrl?.isEmpty ??
                                            true
                                        ? const Icon(Icons.business,
                                            size: 80, color: Colors.blue)
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            _companyField(
                                tr(LanguageKeys.companyName),
                                controller.profile.value?.data?.companyName ??
                                    ''),
                            _companyField(
                                tr(LanguageKeys.description),
                                controller.profile.value?.data
                                        ?.companyDescription ??
                                    ''),
                            _companyField(
                                tr(LanguageKeys.companyAddress),
                                controller
                                        .profile.value?.data?.companyAddress ??
                                    ''),
                            _companyField(
                                tr(LanguageKeys.companyPhoneNumber) +
                                    "(${tr(LanguageKeys.comapnyLabel)})",
                                controller.profile.value?.data?.companyNumber ??
                                    ''),
                            _companyField(tr(LanguageKeys.industry),
                                controller.profile.value?.data?.industry ?? ''),
                            _companyField(tr(LanguageKeys.country),
                                controller.profile.value?.data?.country ?? ''),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    );
                  }
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _profileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
          const Divider(),
        ],
      ),
    );
  }

  Widget _companyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(
            value.isNotEmpty ? value : '',
            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
