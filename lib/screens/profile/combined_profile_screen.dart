import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';

class CombinedProfileScreen extends StatefulWidget {
  static const pageId = '/combinedProfile';

  const CombinedProfileScreen({super.key});

  @override
  State<CombinedProfileScreen> createState() => _CombinedProfileScreenState();
}

class _CombinedProfileScreenState extends State<CombinedProfileScreen> {
  int selectedTab = 0; // 0: Personal, 1: Company
  bool isEditMode = false;

  // Form controllers for personal information
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  // Company form controllers
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController companyDescController = TextEditingController();
  final TextEditingController companyAddrController = TextEditingController();
  final TextEditingController companyPhoneController = TextEditingController();

  // Dropdown values
  String? selectedUserType;
  String? selectedLanguage;
  String? selectedIndustry;
  String? selectedCountry;

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
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // Load personal data
    firstNameController.text = personalData['firstName'] ?? '';
    lastNameController.text = personalData['lastName'] ?? '';
    emailController.text = personalData['email'] ?? '';
    phoneController.text = personalData['phone'] ?? '';
    jobTitleController.text = personalData['jobTitle'] ?? '';
    cityController.text = personalData['city'] ?? '';
    selectedUserType = personalData['userType'];
    selectedLanguage = personalData['language'];

    // Load company data
    companyNameController.text = companyData['companyName'] ?? '';
    companyDescController.text = companyData['description'] ?? '';
    companyAddrController.text = companyData['address'] ?? '';
    companyPhoneController.text = companyData['phone'] ?? '';
    selectedIndustry = companyData['industry'];
    selectedCountry = companyData['country'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button, title, and edit/save button
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

          // Edit/Save button
          GestureDetector(
            onTap: () {
              setState(() {
                if (isEditMode) {
                  // Save changes
                  _saveChanges();
                }
                isEditMode = !isEditMode;
              });
            },
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: isEditMode ? Colors.green : AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isEditMode ? Icons.check : Icons.edit,
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
          Stack(
            alignment: Alignment.bottomRight,
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
              if (isEditMode)
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20.w,
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            isEditMode ? 'Tap to change profile picture' : 'Profile Picture',
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
          if (isEditMode) ...[
            _buildFormField(
              label: 'First Name',
              controller: firstNameController,
              placeholder: 'Enter your first name',
            ),
            _buildFormField(
              label: 'Last Name',
              controller: lastNameController,
              placeholder: 'Enter your last name',
            ),
            _buildFormField(
              label: 'Email',
              controller: emailController,
              placeholder: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
            ),
            _buildFormField(
              label: 'Phone Number',
              controller: phoneController,
              placeholder: 'Enter your phone number',
              keyboardType: TextInputType.phone,
            ),
            _buildDropdownField(
              label: 'User Type',
              value: selectedUserType,
              placeholder: 'Select user type',
              items: [
                'Professional',
                'Business Owner',
                'Employee',
                'Freelancer'
              ],
              onChanged: (value) => setState(() => selectedUserType = value),
            ),
            _buildFormField(
              label: 'Job Title',
              controller: jobTitleController,
              placeholder: 'Enter your job title',
            ),
            _buildFormField(
              label: 'City',
              controller: cityController,
              placeholder: 'Enter your city',
            ),
            _buildDropdownField(
              label: 'Language',
              value: selectedLanguage,
              placeholder: 'Select language',
              items: ['English', 'Spanish', 'French', 'German', 'Chinese'],
              onChanged: (value) => setState(() => selectedLanguage = value),
            ),
          ] else ...[
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
          ],

          SizedBox(height: 32.h),

          // Save Changes button (only show in edit mode)
          if (isEditMode)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Save Changes',
                  style: stylePoppins(
                    fontSize: 16.w,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildCompanyInformation() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          if (isEditMode) ...[
            _buildFormField(
              label: 'Company Name',
              controller: companyNameController,
              placeholder: 'Enter company name',
            ),
            _buildFormField(
              label: 'Company Description',
              controller: companyDescController,
              placeholder: 'Enter company description',
              maxLines: 3,
            ),
            _buildFormField(
              label: 'Company Address',
              controller: companyAddrController,
              placeholder: 'Enter company address',
              maxLines: 2,
            ),
            _buildFormField(
              label: 'Company Phone',
              controller: companyPhoneController,
              placeholder: 'Enter company phone',
              keyboardType: TextInputType.phone,
            ),
            _buildDropdownField(
              label: 'Industry',
              value: selectedIndustry,
              placeholder: 'Select industry',
              items: [
                'Technology',
                'Healthcare',
                'Finance',
                'Education',
                'Manufacturing'
              ],
              onChanged: (value) => setState(() => selectedIndustry = value),
            ),
            _buildDropdownField(
              label: 'Country',
              value: selectedCountry,
              placeholder: 'Select country',
              items: [
                'United States',
                'Canada',
                'United Kingdom',
                'Germany',
                'France'
              ],
              onChanged: (value) => setState(() => selectedCountry = value),
            ),
          ] else ...[
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
          ],

          SizedBox(height: 32.h),

          // Save Changes button (only show in edit mode)
          if (isEditMode)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Save Changes',
                  style: stylePoppins(
                    fontSize: 16.w,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    TextInputType? keyboardType,
    int maxLines = 1,
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
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: stylePoppins(
                fontSize: 14.w,
                fontWeight: FontWeight.w400,
                color: Colors.grey[500],
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            ),
          ),
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

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required String placeholder,
    required List<String> items,
    required Function(String?)? onChanged,
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
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                hint: Text(
                  placeholder,
                  style: stylePoppins(
                    fontSize: 14.w,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[500],
                  ),
                ),
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: stylePoppins(
                        fontSize: 14.w,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textTitle,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
                dropdownColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveChanges() {
    // Update the data maps with new values
    personalData['firstName'] = firstNameController.text;
    personalData['lastName'] = lastNameController.text;
    personalData['email'] = emailController.text;
    personalData['phone'] = phoneController.text;
    personalData['userType'] = selectedUserType ?? '';
    personalData['jobTitle'] = jobTitleController.text;
    personalData['city'] = cityController.text;
    personalData['language'] = selectedLanguage ?? '';

    companyData['companyName'] = companyNameController.text;
    companyData['description'] = companyDescController.text;
    companyData['address'] = companyAddrController.text;
    companyData['phone'] = companyPhoneController.text;
    companyData['industry'] = selectedIndustry ?? '';
    companyData['country'] = selectedCountry ?? '';

    // Show success message
    Get.snackbar(
      'Success',
      'Profile updated successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );

    setState(() {
      isEditMode = false;
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    jobTitleController.dispose();
    cityController.dispose();
    companyNameController.dispose();
    companyDescController.dispose();
    companyAddrController.dispose();
    companyPhoneController.dispose();
    super.dispose();
  }
}
