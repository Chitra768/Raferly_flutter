import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/controller/edit_profile_controller.dart'
    show EditProfileController;
import 'package:referaly/controller/my_profile_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/screens/edit_profile_screen.dart'
    show EditProfileScreen;
import 'package:referaly/screens/profile/company_profile_screen.dart'
    show CompanyProfileScreen;
import 'package:referaly/utils/translations.dart';
import 'package:referaly/controller/company_profile_controller.dart';

class MyProfileScreen extends StatelessWidget {
  static const pageId = '/myProfile';
  final MyProfileController controller = Get.put(MyProfileController());

  MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Call getProfile when screen is built
    controller.getProfile();

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
                          // child: SvgPicture.asset(
                          //   AppAssets.imgIosBack,
                          //   colorFilter: ColorFilter.mode(
                          //       AppColors.blackColor, BlendMode.darken),
                          // ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      tr(LanguageKeys.myprofile),
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: GestureDetector(
                        onTap: () {
                          // Initialize edit profileController if not already initialized
                          if (!Get.isRegistered<EditProfileController>()) {
                            Get.put(EditProfileController());
                          }
                          final companyController =
                              Get.find<EditProfileController>();
                          companyController.setCompanyData(
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
                          );
                          Get.toNamed(EditProfileScreen.pageId);
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
                ],
              ),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(
                        child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2.5,
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

                  return SingleChildScrollView(
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
                          _profileField(
                              tr(LanguageKeys.firstName), controller.firstName),
                          _profileField(
                              tr(LanguageKeys.lastName), controller.lastName),
                          _profileField(
                              tr(LanguageKeys.email), controller.email),
                          _profileField(
                              tr(LanguageKeys.phoneNumber), controller.phone),
                          _profileField(tr(LanguageKeys.companyType),
                              controller.userType),
                          _profileField(tr(LanguageKeys.job), controller.job),
                          _profileField(tr(LanguageKeys.city), controller.city),
                          _profileField(
                              tr(LanguageKeys.language), controller.language),
                          const SizedBox(height: 24),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    // Initialize CompanyProfileController if not already initialized
                                    if (!Get.isRegistered<
                                        CompanyProfileController>()) {
                                      Get.put(CompanyProfileController());
                                    }
                                    final companyController =
                                        Get.find<CompanyProfileController>();
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
                                    Get.toNamed(CompanyProfileScreen.pageId);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: AppColors.primary),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    minimumSize: Size(
                                        MediaQuery.of(context).size.height, 50),
                                  ),
                                  child: Text(
                                    tr(LanguageKeys.companyDetails),
                                    style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    tr(LanguageKeys.deleteAccount),
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600),
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
}
