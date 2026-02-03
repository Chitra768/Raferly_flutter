import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/custom_app_bar.dart';
import 'package:referaly/widgets/primary_button.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/models/model_notification_control.dart';

class NotificationPermissionsScreen extends StatefulWidget {
  static const String pageId = '/notificationPermissions';

  const NotificationPermissionsScreen({super.key});

  @override
  State<NotificationPermissionsScreen> createState() =>
      _NotificationPermissionsScreenState();
}

class _NotificationPermissionsScreenState
    extends State<NotificationPermissionsScreen> {
  bool _mobileNotificationsEnabled = false;
  bool _emailNotificationsEnabled = false;
  bool _contactAccessEnabled = false;
  static const String _mobileNotificationsKey = 'mobileNotificationsEnabled';
  static const String _contactAccessKey = 'contactAccessEnabled';

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    // Check if notifications are disabled by user preference
    final isDisabledByUser = AppPreference.readBool(_mobileNotificationsKey);

    // Check notification permission
    final notificationStatus =
        await FirebaseMessaging.instance.getNotificationSettings();
    final hasPermission = notificationStatus.authorizationStatus ==
            AuthorizationStatus.authorized ||
        notificationStatus.authorizationStatus ==
            AuthorizationStatus.provisional;

    setState(() {
      // Only enable if permission is granted AND not disabled by user
      _mobileNotificationsEnabled = hasPermission && !isDisabledByUser;
    });

    // Check if contact access is disabled by user preference
    final isContactDisabledByUser = AppPreference.readBool(_contactAccessKey);

    // Check contact permission
    final contactStatus = await FlutterContacts.requestPermission();
    setState(() {
      // Only enable if permission is granted AND not disabled by user
      _contactAccessEnabled = contactStatus && !isContactDisabledByUser;
    });

    // Fetch email notification status from API
    await _fetchEmailNotificationStatus();
  }

  Future<void> _fetchEmailNotificationStatus() async {
    try {
      final result = await RESTAuth.getUserNotificationControl();
      if (result is ApiSuccess) {
        final response = result.data as ModelNotificationControl;
        if (response.data != null) {
          setState(() {
            _emailNotificationsEnabled =
                response.data!.emailNotification ?? false;
          });
        }
      } else if (result is ApiFailure) {
        // If API fails, fallback to local preferences
        final emailEnabledSet =
            AppPreference.readString('emailNotificationsEnabledSet');
        setState(() {
          _emailNotificationsEnabled = emailEnabledSet == null
              ? true
              : AppPreference.readBool('emailNotificationsEnabled');
        });
      }
    } catch (e) {
      // If API fails, fallback to local preferences
      final emailEnabledSet =
          AppPreference.readString('emailNotificationsEnabledSet');
      setState(() {
        _emailNotificationsEnabled = emailEnabledSet == null
            ? true
            : AppPreference.readBool('emailNotificationsEnabled');
      });
    }
  }

  Future<void> _toggleMobileNotifications(bool value) async {
    // Update UI immediately for better UX
    setState(() {
      _mobileNotificationsEnabled = value;
    });

    if (value) {
      // Enable notifications: Request permission and get token
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      final hasPermission =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
              settings.authorizationStatus == AuthorizationStatus.provisional;

      if (hasPermission) {
        // Get FCM token
        final token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          await AppPreference.writeString(AppPreference.fcmToken, token);
        }
        // Remove the disabled flag
        await AppPreference.writeBool(_mobileNotificationsKey, false);

        Get.snackbar(
          tr(LanguageKeys.permissions),
          'Notifications enabled',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
        );
      } else {
        // Permission denied, revert the switch
        setState(() {
          _mobileNotificationsEnabled = false;
        });
      }
    } else {
      // Disable notifications: Delete token and store preference
      try {
        // Delete FCM token to stop receiving notifications
        await FirebaseMessaging.instance.deleteToken();
        // Clear stored token
        await AppPreference.writeString(AppPreference.fcmToken, '');
        // Store preference that notifications are disabled
        await AppPreference.writeBool(_mobileNotificationsKey, true);

        Get.snackbar(
          tr(LanguageKeys.permissions),
          'Notifications disabled',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
        );
      } catch (e) {
        // If deletion fails, still update the preference
        await AppPreference.writeBool(_mobileNotificationsKey, true);
      }
    }
  }

  Future<void> _toggleContactAccess(bool value) async {
    // Update UI immediately for better UX
    setState(() {
      _contactAccessEnabled = value;
    });

    if (value) {
      // Enable contact access: Request permission
      final status = await FlutterContacts.requestPermission();

      if (status) {
        // Remove the disabled flag
        await AppPreference.writeBool(_contactAccessKey, false);

        Get.snackbar(
          tr(LanguageKeys.permissions),
          'Contact access enabled',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
        );
      } else {
        // Permission denied, revert the switch
        setState(() {
          _contactAccessEnabled = false;
        });

        Get.snackbar(
          tr(LanguageKeys.permissions),
          tr(LanguageKeys.contactPermissionDenied),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      // Disable contact access: Store preference to restrict access
      await AppPreference.writeBool(_contactAccessKey, true);

      Get.snackbar(
        tr(LanguageKeys.permissions),
        'Contact access disabled',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.primary,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _toggleEmailNotifications(bool value) async {
    // Update UI immediately for better UX
    setState(() {
      _emailNotificationsEnabled = value;
    });

    try {
      // Call API to update email notification preference
      final result = await RESTAuth.updateUserNotificationControl(
        emailNotification: value ? 1 : 0,
      );

      if (result is ApiSuccess) {
        final response = result.data as ModelNotificationControl;
        // Update local state with server response
        if (response.data != null) {
          setState(() {
            _emailNotificationsEnabled =
                response.data!.emailNotification ?? value;
          });
        }
        // Save to local preferences as backup
        await AppPreference.writeBool('emailNotificationsEnabled', value);
        await AppPreference.writeString('emailNotificationsEnabledSet', 'true');

        // Show success message
        Get.snackbar(
          tr(LanguageKeys.permissions),
          response.message ??
              (value
                  ? 'Email notifications enabled'
                  : 'Email notifications disabled'),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
        );
      } else if (result is ApiFailure) {
        // Revert UI state on failure
        setState(() {
          _emailNotificationsEnabled = !value;
        });

        // Show error message
        Get.snackbar(
          tr(LanguageKeys.permissions),
          result.error.message ?? 'Failed to update email notification settings',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Revert UI state on error
      setState(() {
        _emailNotificationsEnabled = !value;
      });

      // Show error message
      Get.snackbar(
        tr(LanguageKeys.permissions),
        'Failed to update email notification settings',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(
        title: tr(LanguageKeys.permissions),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Information Section
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications,
                        size: 30,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      tr(LanguageKeys.stayUpdated),
                      style: stylePoppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      tr(LanguageKeys.stayUpdatedDescription),
                      style: stylePoppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Mobile Notifications
              _buildPermissionTile(
                icon: AppAssets.imgMobile,
                title: tr(LanguageKeys.mobileNotifications),
                subtitle: tr(LanguageKeys.mobileNotificationsDescription),
                value: _mobileNotificationsEnabled,
                onChanged: _toggleMobileNotifications,
              ),
              const SizedBox(height: 20),

              // Email Notifications
              _buildPermissionTile(
                icon: AppAssets.imgEmailactivity,
                title: tr(LanguageKeys.emailNotifications),
                subtitle: tr(LanguageKeys.emailNotificationsDescription),
                value: _emailNotificationsEnabled,
                onChanged: _toggleEmailNotifications,
              ),
              const SizedBox(height: 20),

              // Contact Access
              _buildPermissionTile(
                icon: AppAssets.imgSaveActivity,
                title: tr(LanguageKeys.contactAccess),
                subtitle: tr(LanguageKeys.contactAccessDescription),
                value: _contactAccessEnabled,
                onChanged: _toggleContactAccess,
              ),
              const SizedBox(height: 32),

              // Privacy Notice Container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        AppAssets.imgInfoActivity,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tr(LanguageKeys.privacyNoticeTitle),
                            style: stylePoppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tr(LanguageKeys.privacyNoticeText),
                            style: stylePoppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.primary.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Continue Button
              PrimaryButton(
                text: tr(LanguageKeys.continueText),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionTile({
    required String icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey100.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.grey300.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SvgPicture.asset(
              icon,
              color: AppColors.primary,
              width: 24,
              height: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: stylePoppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: stylePoppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: const Color(0xFFE0E0E0),
            trackOutlineColor:
                WidgetStateProperty.resolveWith((Set<WidgetState> states) {
              return Colors.transparent;
            }),
            thumbColor:
                WidgetStateProperty.resolveWith((Set<WidgetState> states) {
              return AppColors.whiteColor;
            }),
            overlayColor:
                WidgetStateProperty.resolveWith((Set<WidgetState> states) {
              return Colors.transparent;
            }),
          ),
        ],
      ),
    );
  }
}
