import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/team_management_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_team_member.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/logo_loader.dart';

class TeamManagementScreen extends GetView<TeamManagementController> {
  static const String pageId = '/teamManagement';

  const TeamManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.teamTitle),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          tr(LanguageKeys.teamManagementTitle),
          style: const TextStyle(
            color: AppColors.teamTitle,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        surfaceTintColor: AppColors.whiteColor,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.teamBorderGrey),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.members.isEmpty) {
          return const Center(child: LogoLoader());
        }
        return RefreshIndicator(
          onRefresh: controller.loadTeamMembers,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _infoCard(),
                const SizedBox(height: 24),
                _addColleagueSection(),
                const SizedBox(height: 24),
                _teamMembersSection(),
                if (controller.error.value.isNotEmpty && controller.members.isEmpty) ...[
                  const SizedBox(height: 16),
                  _errorState(),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.teamPurpleLightBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr(LanguageKeys.teamManagementInfoTitleLine1),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.teamTitle,
              height: 1.3,
            ),
          ),
          Text(
            tr(LanguageKeys.teamManagementInfoTitleLine2),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.teamTitle,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.teamBodyGrey,
                height: 1.5,
              ),
              children: [
                TextSpan(text: tr(LanguageKeys.teamManagementInfoBodyPrefix)),
                TextSpan(
                  text: tr(LanguageKeys.teamManagementAgency),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.teamTitle,
                  ),
                ),
                TextSpan(text: tr(LanguageKeys.teamManagementInfoBodyAgencyDesc)),
                TextSpan(
                  text: tr(LanguageKeys.teamManagementIndependent),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.teamTitle,
                  ),
                ),
                TextSpan(
                  text: tr(LanguageKeys.teamManagementInfoBodyIndependentDesc),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _addColleagueSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr(LanguageKeys.teamManagementAddColleague),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.teamTitle,
          ),
        ),
        const SizedBox(height: 12),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: controller.onAddColleague,
            borderRadius: BorderRadius.circular(12),
            child: DottedBorder(
              color: AppColors.primary,
              strokeWidth: 2,
              dashPattern: const [6, 4],
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              child: Container(
                width: double.infinity,
                height: 56,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      tr(LanguageKeys.teamManagementAddNewColleague),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _teamMembersSection() {
    return Obx(() {
      final count = controller.members.length;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                tr(LanguageKeys.teamManagementMembers),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.teamTitle,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.teamBorderGrey,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.teamBodyGrey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (controller.isLoading.value && count == 0)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: LogoLoader()),
            )
          else if (count == 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                tr(LanguageKeys.teamManagementEmpty),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: AppColors.teamBodyGrey),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: count,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _memberCard(controller.members[index]);
              },
            ),
        ],
      );
    });
  }

  Widget _memberCard(TeamMemberData member) {
    final isAgency = member.type == TeamMemberType.agency;
    final isIndependent = member.type == TeamMemberType.independent;

    return Material(
      color: AppColors.whiteColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => controller.onMemberTap(member),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.teamBorderGrey),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.gray100,
                backgroundImage: member.avatarUrl != null && member.avatarUrl!.isNotEmpty
                    ? NetworkImage(member.avatarUrl!)
                    : null,
                child: member.avatarUrl == null || member.avatarUrl!.isEmpty
                    ? Icon(Icons.person, color: AppColors.grey500)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.fullName ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.teamTitle,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (member.email != null && member.email!.isNotEmpty)
                      Text(
                        member.email!,
                        style: const TextStyle(fontSize: 12, color: AppColors.teamBodyGrey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (member.status != null &&
                        member.status!.isNotEmpty &&
                        member.status!.toLowerCase() != 'active')
                      Text(
                        member.status!,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.teamBodyGrey,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (isAgency || isIndependent)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isAgency ? AppColors.teamPurpleLightBg : AppColors.purple100,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    isAgency
                        ? tr(LanguageKeys.teamManagementAgency)
                        : tr(LanguageKeys.teamManagementIndependent),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isAgency ? AppColors.primary : AppColors.teamIndependentViolet,
                    ),
                  ),
                ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, color: AppColors.grey500, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _errorState() {
    return Column(
      children: [
        Text(
          controller.error.value,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: AppColors.teamBodyGrey),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: controller.loadTeamMembers,
          child: Text(tr(LanguageKeys.retry)),
        ),
      ],
    );
  }
}
