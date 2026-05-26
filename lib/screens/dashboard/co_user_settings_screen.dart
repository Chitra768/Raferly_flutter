import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/co_user_settings_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_team_member.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/logo_loader.dart';

/// Co-user Settings — matches Figma nodes 3474:1368 (EN), 3474:1270 (FR), 3474:1172 (ES).
class CoUserSettingsScreen extends GetView<CoUserSettingsController> {
  static const String pageId = '/coUserSettings';

  const CoUserSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.teamTitle, size: 20),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          tr(LanguageKeys.coUserSettingsTitle),
          style: const TextStyle(
            color: AppColors.teamTitle,
            fontWeight: FontWeight.w600,
            fontSize: 18,
            height: 28 / 18,
          ),
        ),
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: AppColors.whiteColor,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.teamBorderGrey),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.settings.value == null) {
          return const Center(child: LogoLoader());
        }
        if (controller.error.value.isNotEmpty && controller.settings.value == null) {
          return _errorBody();
        }
        final settings = controller.settings.value;
        if (settings == null || controller.draftAccess.value == null) {
          return const SizedBox.shrink();
        }
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _profileHeader(settings),
                    const SizedBox(height: 24),
                    _contentAccessSection(),
                    const SizedBox(height: 24),
                    _navigationAccessSection(),
                    const SizedBox(height: 24),
                    _collaborationTypeSection(settings),
                  ],
                ),
              ),
            ),
            _saveFooter(),
          ],
        );
      }),
    );
  }

  Widget _errorBody() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(controller.error.value, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            TextButton(
              onPressed: controller.loadSettings,
              child: Text(tr(LanguageKeys.retry)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileHeader(TeamMemberSettingsModel settings) {
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.teamPurpleLightBg, width: 4),
          ),
          child: ClipOval(
            child: settings.avatarUrl != null && settings.avatarUrl!.isNotEmpty
                ? Image.network(
                    settings.avatarUrl!,
                    width: 88,
                    height: 88,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _avatarPlaceholder(),
                  )
                : _avatarPlaceholder(),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          settings.fullName ?? '',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.teamTitle,
            height: 28 / 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          settings.collaborationLabel ?? tr(LanguageKeys.coUserSettingsAgencyCollaboration),
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.teamBodyGrey,
            height: 20 / 14,
          ),
        ),
      ],
    );
  }

  Widget _avatarPlaceholder() {
    return Container(
      color: AppColors.gray100,
      child: Icon(Icons.person, color: AppColors.grey500, size: 40),
    );
  }

  Widget _contentAccessSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr(LanguageKeys.coUserSettingsContentAccess),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.teamTitle,
            height: 24 / 16,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          tr(LanguageKeys.coUserSettingsContentAccessSubtitle),
          style: const TextStyle(fontSize: 14, color: AppColors.teamBodyGrey, height: 20 / 14),
        ),
        const SizedBox(height: 16),
        Obx(() {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.teamBorderGrey),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadowBlack5,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              children: [
                _modulePermissionRow(
                  icon: Icons.groups_outlined,
                  title: tr(LanguageKeys.coUserSettingsBusinessReferrers),
                  visible: controller.businessReferrersVisible,
                  edition: controller.businessReferrersEdition,
                  onVisibilityChanged: controller.setBusinessReferrersVisible,
                  onEditionChanged: controller.setBusinessReferrersEdition,
                  showDivider: true,
                ),
                _modulePermissionRow(
                  icon: Icons.send_outlined,
                  title: tr(LanguageKeys.coUserSettingsLeadsSent),
                  visible: controller.leadsSentVisible,
                  edition: controller.leadsSentEdition,
                  onVisibilityChanged: controller.setLeadsSentVisible,
                  onEditionChanged: controller.setLeadsSentEdition,
                  showDivider: true,
                ),
                _modulePermissionRow(
                  icon: Icons.inbox_outlined,
                  title: tr(LanguageKeys.coUserSettingsLeadsReceived),
                  visible: controller.leadsReceivedVisible,
                  edition: controller.leadsReceivedEdition,
                  onVisibilityChanged: controller.setLeadsReceivedVisible,
                  onEditionChanged: controller.setLeadsReceivedEdition,
                  showDivider: true,
                ),
                _modulePermissionRow(
                  icon: Icons.description_outlined,
                  title: tr(LanguageKeys.coUserSettingsReferralContracts),
                  visible: controller.referralContractsVisible,
                  edition: controller.referralContractsEdition,
                  onVisibilityChanged: controller.setReferralContractsVisible,
                  onEditionChanged: controller.setReferralContractsEdition,
                  showDivider: false,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _navigationAccessSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr(LanguageKeys.coUserSettingsNavigationAccess),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.teamTitle,
            height: 24 / 16,
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => Container(
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.teamBorderGrey),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadowBlack5,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              children: [
                // _navigationAccessRow(
                //   icon: Icons.hub_outlined,
                //   title: tr(LanguageKeys.coUserSettingsMyNetwork),
                //   visible: controller.myNetworkVisible,
                //   onToggle: controller.setMyNetworkVisible,
                //   showDivider: true,
                // ),
                _navigationAccessRow(
                  icon: Icons.person_outline,
                  title: tr(LanguageKeys.coUserSettingsIAmReferrer),
                  visible: controller.iAmReferrerVisible,
                  onToggle: controller.setIAmReferrerVisible,
                  showDivider: false,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _modulePermissionRow({
    required IconData icon,
    required String title,
    required bool visible,
    required bool edition,
    required ValueChanged<bool> onVisibilityChanged,
    required ValueChanged<bool> onEditionChanged,
    required bool showDivider,
  }) {
    final visibilitySubtitle = visible
        ? tr(LanguageKeys.coUserSettingsVisibleToCoUser)
        : tr(LanguageKeys.coUserSettingsHiddenFromCoUser);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, visible ? 8 : 16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.teamPurpleLightBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Icon(icon, color: AppColors.teamPurple, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.teamTitle,
                            height: 24 / 16,
                          ),
                        ),
                        Text(
                          visibilitySubtitle,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.teamBodyGrey,
                            height: 20 / 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        tr(LanguageKeys.coUserSettingsVisibility),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.teamBodyGrey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _FigmaToggle(
                        value: visible,
                        onChanged: onVisibilityChanged,
                      ),
                    ],
                  ),
                ],
              ),
              if (visible) ...[
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 56),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          tr(LanguageKeys.coUserSettingsCanEdit),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.teamBodyGrey,
                            height: 20 / 14,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            tr(LanguageKeys.coUserSettingsEdition),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColors.teamBodyGrey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          _FigmaToggle(
                            value: edition,
                            onChanged: onEditionChanged,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1, thickness: 1, color: AppColors.teamBorderGrey),
      ],
    );
  }

  Widget _navigationAccessRow({
    required IconData icon,
    required String title,
    required bool visible,
    required ValueChanged<bool> onToggle,
    required bool showDivider,
  }) {
    final subtitle = visible
        ? tr(LanguageKeys.coUserSettingsVisibleToCoUser)
        : tr(LanguageKeys.coUserSettingsHiddenFromCoUser);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.teamPurpleLightBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: AppColors.teamPurple, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.teamTitle,
                        height: 24 / 16,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.teamBodyGrey,
                        height: 20 / 14,
                      ),
                    ),
                  ],
                ),
              ),
              _FigmaToggle(value: visible, onChanged: onToggle),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1, thickness: 1, color: AppColors.teamBorderGrey),
      ],
    );
  }

  Widget _collaborationTypeSection(TeamMemberSettingsModel settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr(LanguageKeys.coUserSettingsCollaborationType),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.teamTitle,
            height: 24 / 16,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.teamBorderGrey),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowBlack5,
                blurRadius: 1,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.teamPurpleLightBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.swap_horiz,
                      color: AppColors.teamPurple,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr(LanguageKeys.coUserSettingsSwitchIndependent),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.teamTitle,
                            height: 24 / 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tr(LanguageKeys.coUserSettingsSwitchIndependentDesc),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.teamBodyGrey,
                            height: 20 / 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (settings.canSwitchToIndependent) ...[
                const SizedBox(height: 16),
                SizedBox(
                  height: 52,
                  child: OutlinedButton(
                    onPressed: controller.isSaving.value ? null : controller.switchToIndependent,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.teamPurple, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      foregroundColor: AppColors.teamPurple,
                    ),
                    child: Text(
                      tr(LanguageKeys.coUserSettingsSwitchIndependent),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _saveFooter() {
    return Obx(() {
      final canSave = controller.isDirty && !controller.isSaving.value;
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          border: const Border(top: BorderSide(color: AppColors.teamBorderGrey)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: canSave ? controller.saveSettings : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canSave ? AppColors.teamPurple : AppColors.teamBorderGrey,
                disabledBackgroundColor: AppColors.teamBorderGrey,
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white,
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: controller.isSaving.value
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      tr(LanguageKeys.coUserSettingsSaveChanges),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ),
      );
    });
  }
}

/// Pill toggle matching Figma (48×24, #8634E1 active, #E8E8EB inactive).
class _FigmaToggle extends StatelessWidget {
  const _FigmaToggle({
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 48,
        height: 24,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: value ? AppColors.teamPurple : AppColors.teamBorderGrey,
          borderRadius: BorderRadius.circular(999),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: value ? AppColors.teamPurple : AppColors.teamBorderGrey,
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
