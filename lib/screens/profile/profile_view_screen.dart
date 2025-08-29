import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';

class ProfileViewScreen extends StatefulWidget {
  static const pageId = '/profileView';

  const ProfileViewScreen({super.key});

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  int selectedTab = 0; // 0: Personal, 1: Company

  // Sample data - replace with actual data from your controllers
  final Map<String, String> personalData = {
    'firstName': 'John',
    'lastName': 'Doe',
    'email': 'john.doe@example.com',
    'phone': '+1 (555) 123-4567',
    'userType': 'Professional',
    'jobTitle': 'Software Engineer',
    'city': 'San Francisco',
    'language': 'English',
  };

  final Map<String, String> companyData = {
    'companyName': 'Acme Corporation',
    'description': 'Leading technology solutions provider',
    'address': '123 Business St, Tech City, TC 12345',
    'phone': '+1 (555) 987-6543',
    'industry': 'Technology',
    'country': 'United States',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button, title, and edit button
            _buildHeader(),

            // Tab switcher
            _buildTabSwitcher(),

            // Profile picture section
            _buildProfilePicture(),

            // Content based on selected tab
            Expanded(
              child: selectedTab == 0
                  ? _buildPersonalInformation()
                  : _buildCompanyInformation(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.arrow_back_ios, size: 20.w),
            ),
          ),

          // Title
          Expanded(
            child: Center(
              child: Text(
                'My Profile',
                style: stylePoppins(
                  fontSize: 18.w,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textTitle,
                ),
              ),
            ),
          ),

          // Edit button
          GestureDetector(
            onTap: () {
              // Navigate to edit screen
              Get.toNamed('/newProfile');
            },
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.edit,
                size: 20.w,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedTab = 0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color:
                      selectedTab == 0 ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border(
                    bottom: BorderSide(
                      color: selectedTab == 0
                          ? AppColors.primary
                          : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  'Personal Information',
                  textAlign: TextAlign.center,
                  style: stylePoppins(
                    fontSize: 14.w,
                    fontWeight: FontWeight.w600,
                    color: selectedTab == 0 ? Colors.white : Colors.grey[600],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedTab = 1),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color:
                      selectedTab == 1 ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border(
                    bottom: BorderSide(
                      color: selectedTab == 1
                          ? AppColors.primary
                          : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  'Company Information',
                  textAlign: TextAlign.center,
                  style: stylePoppins(
                    fontSize: 14.w,
                    fontWeight: FontWeight.w600,
                    color: selectedTab == 1 ? Colors.white : Colors.grey[600],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Column(
        children: [
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!, width: 3),
            ),
            child: CircleAvatar(
              radius: 50.w,
              backgroundColor: Colors.grey[200],
              backgroundImage:
                  const AssetImage('assets/images/profile_placeholder.png'),
              child: Container(
                width: 100.w,
                height: 100.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Profile Picture',
            style: stylePoppins(
              fontSize: 12.w,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInformation() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          _buildInfoField(
            label: 'First Name',
            value: personalData['firstName'] ?? '',
          ),
          _buildInfoField(
            label: 'Last Name',
            value: personalData['lastName'] ?? '',
          ),
          _buildInfoField(
            label: 'Email',
            value: personalData['email'] ?? '',
          ),
          _buildInfoField(
            label: 'Phone Number',
            value: personalData['phone'] ?? '',
          ),
          _buildInfoField(
            label: 'User Type',
            value: personalData['userType'] ?? '',
          ),
          _buildInfoField(
            label: 'Job Title',
            value: personalData['jobTitle'] ?? '',
          ),
          _buildInfoField(
            label: 'City',
            value: personalData['city'] ?? '',
          ),
          _buildInfoField(
            label: 'Language',
            value: personalData['language'] ?? '',
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildCompanyInformation() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          _buildInfoField(
            label: 'Company Name',
            value: companyData['companyName'] ?? '',
          ),
          _buildInfoField(
            label: 'Description',
            value: companyData['description'] ?? '',
          ),
          _buildInfoField(
            label: 'Company Address',
            value: companyData['address'] ?? '',
          ),
          _buildInfoField(
            label: 'Company Phone',
            value: companyData['phone'] ?? '',
          ),
          _buildInfoField(
            label: 'Industry',
            value: companyData['industry'] ?? '',
          ),
          _buildInfoField(
            label: 'Country',
            value: companyData['country'] ?? '',
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildInfoField({
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: stylePoppins(
              fontSize: 14.w,
              fontWeight: FontWeight.w600,
              color: AppColors.textTitle,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Text(
              value.isNotEmpty ? value : 'Not specified',
              style: stylePoppins(
                fontSize: 14.w,
                fontWeight: FontWeight.w400,
                color:
                    value.isNotEmpty ? AppColors.textTitle : Colors.grey[500],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
