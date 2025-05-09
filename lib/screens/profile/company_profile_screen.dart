import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/company_profile_controller.dart';
import 'package:referaly/controller/edit_company_profile_controller.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/screens/company_profile/edit_company_profile.dart';

class CompanyProfileScreen extends GetView<CompanyProfileController> {
  static const pageId = '/companyProfile';
  final CompanyProfileController controller =
      Get.put(CompanyProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Image
          Positioned(
            top: -29,
            child: Image.asset(
              AppAssets.imgCircle,
              fit: BoxFit.fitWidth,
              height: 220,
              width: MediaQuery.of(context).size.width,
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
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Icon(Icons.arrow_back_ios, color: AppColors.bgDark),
                        ),
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Company Profile',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: GestureDetector(
                        onTap: () {
                             // Initialize CompanyProfileController if not already initialized
                                    if (!Get.isRegistered<
                                        EditCompanyProfileController>()) {
                                      Get.put(EditCompanyProfileController());
                                    }
                                    final companyController =
                                        Get.find<EditCompanyProfileController>();
                                    companyController.setCompanyData(
                                      name: controller.companyName.value,
                                      desc: controller.description.value,
                                      addr: controller.address.value,
                                      code:controller.businessCode.value,
                                      image: controller.profileImage.value,
                                      id: controller.companyId.value,
                                      countryCode: controller.companyCountryCode.value,
                                      ind: controller.industry.value,
                                      cntry: controller.country.value,
                                    );
                          Get.toNamed(EditCompanyProfileScreen.pageId);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            border: Border.all(color: AppColors.primary, width: 3),
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
                        // Company logo/profile image
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
                                backgroundImage:
                                    controller.profileImage.value.isNotEmpty
                                        ? NetworkImage(
                                            controller.profileImage.value)
                                        : null,
                                child: controller.profileImage.value.isEmpty
                                    ? const Icon(Icons.account_circle, size: 80, color: Colors.blue)
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        _companyField(
                            'Company Name', controller.companyName.value),
                        _companyField(
                            'Description', controller.description.value),
                        _companyField(
                            'Company Address', controller.address.value),
                        _companyField('Company Number(Business code)',
                            controller.businessCode.value),
                        // _companyField('Company ID', controller.companyId.value),
                        // _companyField('Country Code',
                        //     controller.companyCountryCode.value),
                        // _companyField('Industry', controller.industry.value),
                        // _companyField('Country', controller.country.value),
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

  Widget _companyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(
            value.isNotEmpty ? value : '',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
