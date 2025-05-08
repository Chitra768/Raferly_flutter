import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/edit_profile_controller.dart' show EditProfileController;
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/controller/my_profile_controller.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/screens/edit_profile_screen.dart' show EditProfileScreen;
import 'package:referaly/screens/profile/company_profile_screen.dart'
    show CompanyProfileScreen;
import 'package:referaly/widgets/widget_loading.dart';
import 'package:referaly/controller/company_profile_controller.dart';


class MyProfileScreen extends StatelessWidget {
  static const pageId = '/myProfile';
  final MyProfileController controller = Get.put(MyProfileController());

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
                        onTap: () => Get.back(),
                        child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Icon(Icons.arrow_back_ios,
                                color: AppColors.bgDark)),
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'My Profile',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: GestureDetector(
                        onTap: () {
                             // Initialize edit profileController if not already initialized
                                    if (!Get.isRegistered<
                                        EditProfileController>()) {
                                      Get.put(EditProfileController());
                                    }
                                    final companyController =
                                        Get.find<EditProfileController>();
                                    companyController.setCompanyData(
                                      firstName: controller.firstName,
                                      lastName: controller.lastName ,
                                      city: controller.city,
                                      email: controller.email,
                                      image: controller.profileImage,
                                      job: controller.job,
                                      language: controller.language,
                                      phone: controller.phone,
                                     
                                    );
                          Get.toNamed(EditProfileScreen.pageId);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            border: Border.all(color: Colors.purple, width: 3),
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
                  ),
                ],
              ),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: WidgetLoading());
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
                          _profileField('First Name', controller.firstName),
                          _profileField('Last Name', controller.lastName),
                          _profileField('Email', controller.email),
                          _profileField('Phone Number', controller.phone),
                          _profileField('Type of User', controller.userType),
                          _profileField('Job', controller.job),
                          _profileField('City', controller.city),
                          _profileField('Language', controller.language),
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
                                    side:
                                        const BorderSide(color: Colors.purple),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    minimumSize: Size(
                                        MediaQuery.of(context).size.height, 50),
                                  ),
                                  child: const Text(
                                    'More information',
                                    style: TextStyle(
                                        color: Colors.purple,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'Delete Account',
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
          Text(label,
              style: const TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Divider(),
        ],
      ),
    );
  }
}
