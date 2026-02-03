import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/utils/translations.dart';

import '../../controller/controller_profile_type.dart';
import '../../resources/app_colors.dart';

class ScreenProfileType extends GetView<ControllerProfileType> {
  // Static page identifier
  static const String pageId = "/ScreenProfileType";

  // Controller initialization
  final ControllerProfileType profileTypeController =
      Get.put(ControllerProfileType());

  ScreenProfileType({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: _buildAppBar(context),
        body: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _buildMainContent(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Builds the custom AppBar with back button and handshake icon
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.whiteColor,
      scrolledUnderElevation: 0,
      elevation: 0,
      actions: [
        SvgPicture.asset(
          AppAssets.imgReferrelsPeopleSvg,
          height: 40,
          color: AppColors.primary,
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  // Builds the main content column with title, subtitle, profile options, and continue button
  Widget _buildMainContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 20),
        LinearProgressIndicator(
          value: 0.7,
          backgroundColor: AppColors.grey300,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
        const SizedBox(height: 20),
        // Title
        Text(
          tr(LanguageKeys.profileTypeTitle),
          style: TextStyle(
            fontSize: 20,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        // Subtitle
        Text(
          tr(LanguageKeys.profileTypeSubtitle),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.greyFontColor,
                fontWeight: FontWeight.w400,
              ),
        ),
        const SizedBox(height: 30),
        // Profile type options
        Obx(
          () => Column(
            children: [
              _buildProfileTypeOption(
                context,
                LanguageKeys.profileTypeProfessionalIndividuals,
                false,
                LanguageKeys.profileTypeSendOnly,
                LanguageKeys.profileTypeIndividualSubtitle,
                [
                  LanguageKeys.featureSendEasily,
                  LanguageKeys.featureTrackStatus,
                  LanguageKeys.featureContactManagement,
                  LanguageKeys.featureBasicReporting,
                ],
                profileTypeController.selectedProfileType.value ==
                    LanguageKeys.individual,
                AppAssets.imgProfileSend,
                () => profileTypeController
                    .selectProfileType(LanguageKeys.individual),
              ),
              SizedBox(height: 16),
              _buildProfileTypeOption(
                context,
                LanguageKeys.profileTypeProfessionalOnly,
                true,
                LanguageKeys.profileTypeSendReceive,
                LanguageKeys.professionalSubtitle,
                [
                  LanguageKeys.featureSendUnlimited,
                  LanguageKeys.featureReceiveLeads,
                  LanguageKeys.featureAnalytics,
                  LanguageKeys.featureLeadTools,
                ],
                profileTypeController.selectedProfileType.value ==
                    LanguageKeys.professional,
                AppAssets.imgCompare,
                () => profileTypeController
                    .selectProfileType(LanguageKeys.professional),
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }

  // Builds a profile type option card with icon, title, subtitle, descriptions, and button
  Widget _buildProfileTypeOption(
    BuildContext context,
    String typeKey,
    bool isProfessional,
    String title,
    String subtitle,
    List<String> descriptions,
    bool isSelected,
    String icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.grey300,
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon at top left
                  Container(
                    height: 40,
                    width: 40,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.primaryLightPink,
                    ),
                    child: SvgPicture.asset(
                      icon,
                      width: 12,
                      height: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Title
                  Obx(
                    () => Text(
                      tr(title),
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Subtitle
                  Obx(
                    () => Text(
                      tr(subtitle),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.greyFontColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Description as Column instead of ListView
                  Column(
                    children: descriptions
                        .asMap()
                        .entries
                        .map(
                          (entry) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    tr(entry.value),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.grey700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16), // Replaced Spacer
                  // Elevated Button "Get Started"
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSelected
                          ? () {
                              // Handle Get Started action, e.g., navigate or call a function
                              profileTypeController.goToNextScreen(context);
                            }
                          : null, // Disabled if not selected
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.whiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        tr(LanguageKeys.profileTypeGetStarted),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Chip for profile type label
          Positioned(
            top: 10,
            right: 20,
            child: Chip(
              padding: EdgeInsets.zero,
              side: BorderSide(
                color: AppColors.transparent,
                width: 0,
              ),
              backgroundColor: isProfessional
                  ? AppColors.primary.withOpacity(0.2)
                  : Colors.green.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              label: Text(
                tr(typeKey).toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  color: isProfessional ? AppColors.primary : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
