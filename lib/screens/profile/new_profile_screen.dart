import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';

class NewProfileScreen extends StatefulWidget {
  static const pageId = '/newProfile';

  const NewProfileScreen({super.key});

  @override
  State<NewProfileScreen> createState() => _NewProfileScreenState();
}

class _NewProfileScreenState extends State<NewProfileScreen> {
  int selectedTab = 0; // 0: Personal, 1: Company
  bool isEditMode = false;

  // Form controllers for personal information
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  // Dropdown values
  String? selectedUserType;
  String? selectedLanguage;

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

  @override
  void initState() {
    super.initState();
    _loadPersonalData();
  }

  void _loadPersonalData() {
    firstNameController.text = personalData['firstName'] ?? '';
    lastNameController.text = personalData['lastName'] ?? '';
    emailController.text = personalData['email'] ?? '';
    phoneController.text = personalData['phone'] ?? '';
    jobTitleController.text = personalData['jobTitle'] ?? '';
    cityController.text = personalData['city'] ?? '';
    selectedUserType = personalData['userType'];
    selectedLanguage = personalData['language'];
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
          // Profile image with edit button
          Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        border: Border.all(color: AppColors.primary, width: 3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SvgPicture.asset(
                        AppAssets.imgEditIcon,
                        color: Colors.black,
                        height: 18,
                      )),
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),
          Text(
            'Tap to change profile picture',
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
          _buildFormField(
            label: 'First Name',
            controller: firstNameController,
            placeholder: 'Enter your first name',
            enabled: isEditMode,
          ),
          _buildFormField(
            label: 'Last Name',
            controller: lastNameController,
            placeholder: 'Enter your last name',
            enabled: isEditMode,
          ),
          _buildFormField(
            label: 'Email',
            controller: emailController,
            placeholder: 'Enter your email',
            enabled: isEditMode,
            keyboardType: TextInputType.emailAddress,
          ),
          _buildFormField(
            label: 'Phone Number',
            controller: phoneController,
            placeholder: 'Enter your phone number',
            enabled: isEditMode,
            keyboardType: TextInputType.phone,
          ),
          _buildDropdownField(
            label: 'User Type',
            value: selectedUserType,
            placeholder: 'Select user type',
            items: ['Professional', 'Business Owner', 'Employee', 'Freelancer'],
            onChanged: isEditMode
                ? (value) => setState(() => selectedUserType = value)
                : null,
          ),
          _buildFormField(
            label: 'Job Title',
            controller: jobTitleController,
            placeholder: 'Enter your job title',
            enabled: isEditMode,
          ),
          _buildFormField(
            label: 'City',
            controller: cityController,
            placeholder: 'Enter your city',
            enabled: isEditMode,
          ),
          _buildDropdownField(
            label: 'Language',
            value: selectedLanguage,
            placeholder: 'Select language',
            items: ['English', 'Spanish', 'French', 'German', 'Chinese'],
            onChanged: isEditMode
                ? (value) => setState(() => selectedLanguage = value)
                : null,
          ),
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
          _buildFormField(
            label: 'Company Name',
            controller: TextEditingController(text: 'Acme Corporation'),
            placeholder: 'Enter company name',
            enabled: isEditMode,
          ),
          _buildFormField(
            label: 'Company Description',
            controller: TextEditingController(
                text: 'Leading technology solutions provider'),
            placeholder: 'Enter company description',
            enabled: isEditMode,
            maxLines: 3,
          ),
          _buildFormField(
            label: 'Company Address',
            controller: TextEditingController(
                text: '123 Business St, Tech City, TC 12345'),
            placeholder: 'Enter company address',
            enabled: isEditMode,
            maxLines: 2,
          ),
          _buildFormField(
            label: 'Company Phone',
            controller: TextEditingController(text: '+1 (555) 987-6543'),
            placeholder: 'Enter company phone',
            enabled: isEditMode,
            keyboardType: TextInputType.phone,
          ),
          _buildDropdownField(
            label: 'Industry',
            value: 'Technology',
            placeholder: 'Select industry',
            items: [
              'Technology',
              'Healthcare',
              'Finance',
              'Education',
              'Manufacturing'
            ],
            onChanged: isEditMode ? (value) {} : null,
          ),
          _buildDropdownField(
            label: 'Country',
            value: 'United States',
            placeholder: 'Select country',
            items: [
              'United States',
              'Canada',
              'United Kingdom',
              'Germany',
              'France'
            ],
            onChanged: isEditMode ? (value) {} : null,
          ),
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
    required bool enabled,
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
            enabled: enabled,
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
              fillColor: enabled ? Colors.white : Colors.grey[100],
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
    // Implement save logic here
    // You can integrate with your existing controllers
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
    super.dispose();
  }
}
