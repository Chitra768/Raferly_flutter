import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/controller/my_profile_controller.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/screens/edit_profile_screen.dart';
import 'package:referaly/screens/profile/company_profile_screen.dart'
    show CompanyProfileScreen;

class MyProfileScreen extends StatelessWidget {
  static const pageId = '/myProfile';
  final MyProfileController controller;

  MyProfileScreen({super.key}) : controller = Get.put(MyProfileController());

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
                          ],
                        ),
                        const SizedBox(height: 32),
                        _profileField('First Name', controller.firstName.value),
                        _profileField('Last Name', controller.lastName.value),
                        _profileField('Email', controller.email.value),
                        _profileField('Phone Number', controller.phone.value),
                        _profileField(
                            'Type of User', controller.userType.value),
                        _profileField('Job', controller.job.value),
                        _profileField('City', controller.city.value),
                        _profileField('Language', controller.language.value),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Column(
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  Get.toNamed(CompanyProfileScreen.pageId);
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.purple),
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
                ),
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
