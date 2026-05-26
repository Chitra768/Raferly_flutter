import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/team_member_content_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_team_member.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/logo_loader.dart';

/// Member content tabs — Figma 3826:12667 (EN), 3826:12777 (FR), 3826:12392 (ES).
class TeamMemberContentScreen extends GetView<TeamMemberContentController> {
  static const String pageId = '/teamMemberContent';

  const TeamMemberContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        // title: Text(tr(LanguageKeys.teamMemberContent)),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.teamTitle, size: 20),
          onPressed: () => Get.back(),
        ),
        surfaceTintColor: AppColors.whiteColor,
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.teamBorderGrey),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),
          // _topBar(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.profileSnapshot.value == null) {
                return const Center(child: LogoLoader());
              }
              if (controller.error.value.isNotEmpty && controller.profileSnapshot.value == null) {
                return _errorState();
              }
              final profile = controller.profileSnapshot.value;
              if (profile == null) {
                return const SizedBox.shrink();
              }

              return _scrollableContent(profile);
            }),
          ),
        ],
      ),
    );
  }

  Widget _errorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              controller.error.value,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: controller.loadContent,
              child: Text(tr(LanguageKeys.retry)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        border: const Border(bottom: BorderSide(color: AppColors.teamBorderGrey)),
      ),
      child: SafeArea(
        bottom: false,
        child: Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.teamTitle, size: 20),
            onPressed: () => Get.back(),
          ),
        ),
      ),
    );
  }

  Widget _profileSection(TeamMemberContentModel data) {
    final avatarUrl = data.avatarUrl;
    return Container(
      color: AppColors.whiteColor,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.gray100,
                backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                child: avatarUrl == null || avatarUrl.isEmpty
                    ? Icon(Icons.person, color: AppColors.grey500, size: 32)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.memberName ?? '',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.teamTitle,
                        height: 28 / 20,
                      ),
                    ),
                    if (data.memberEmail != null && data.memberEmail!.isNotEmpty)
                      Text(
                        data.memberEmail!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.teamBodyGrey,
                          height: 24 / 16,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _summaryRow(data.summary),
        ],
      ),
    );
  }

  Widget _summaryRow(TeamMemberContentSummary summary) {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            count: summary.leadsCount,
            label: tr(LanguageKeys.teamMemberContentTabLeads),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            count: summary.contractsCount,
            label: tr(LanguageKeys.teamMemberContentTabContracts),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            count: summary.referrersCount,
            label: tr(LanguageKeys.teamMemberContentTabReferrers),
          ),
        ),
      ],
    );
  }

  Widget _statCard({required int count, required String label}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.teamPurpleLightBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            '$count',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.teamPurple,
              height: 32 / 24,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.teamBodyGrey,
              height: 16 / 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _segmentedControl() {
    return Obx(() {
      const tabs = TeamMemberContentTab.values;
      final selectedIndex = tabs.indexOf(controller.selectedTab.value);

      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.teamBorderGrey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final segmentWidth = constraints.maxWidth / tabs.length;
            return Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeInOut,
                  left: segmentWidth * selectedIndex,
                  width: segmentWidth,
                  top: 0,
                  bottom: 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.shadowBlack5,
                          blurRadius: 1,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: tabs.map((tab) {
                    final selected = controller.selectedTab.value == tab;
                    return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => controller.selectTab(tab),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            _tabLabel(tab),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: selected ? AppColors.teamTitle : AppColors.teamBodyGrey,
                              height: 20 / 14,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
      );
    });
  }

  String _tabLabel(TeamMemberContentTab tab) {
    switch (tab) {
      case TeamMemberContentTab.leads:
        return tr(LanguageKeys.teamMemberContentTabLeads);
      case TeamMemberContentTab.contracts:
        return tr(LanguageKeys.teamMemberContentTabContracts);
      case TeamMemberContentTab.referrers:
        return tr(LanguageKeys.teamMemberContentTabReferrers);
    }
  }

  /// One scroll view: profile scrolls off, tabs stay pinned, list follows below tabs.
  Widget _scrollableContent(TeamMemberContentModel profile) {
    return Obx(() {
      final slivers = <Widget>[
        SliverToBoxAdapter(child: _profileSection(profile)),
        SliverPersistentHeader(
          pinned: true,
          delegate: _StickySegmentedHeaderDelegate(
            child: _segmentedControl(),
          ),
        ),
        ..._listSlivers(),
      ];

      final scrollView = CustomScrollView(
        key: ValueKey(controller.selectedTab.value),
        slivers: slivers,
      );

      if (!controller.isRefreshing.value) {
        return scrollView;
      }

      return Stack(
        children: [
          IgnorePointer(
            child: Opacity(opacity: 0.45, child: scrollView),
          ),
          const Center(
            child: SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.teamPurple,
              ),
            ),
          ),
        ],
      );
    });
  }

  List<Widget> _listSlivers() {
    if (controller.isLoading.value && controller.content.value == null) {
      return const [
        SliverFillRemaining(
          child: Center(child: LogoLoader()),
        ),
      ];
    }
    if (controller.error.value.isNotEmpty && controller.content.value == null) {
      return [
        SliverFillRemaining(child: _errorState()),
      ];
    }

    final data = controller.content.value;
    if (data == null) {
      return const [SliverToBoxAdapter(child: SizedBox.shrink())];
    }

    if (controller.error.value.isNotEmpty && data.items.isEmpty) {
      return [
        SliverFillRemaining(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(controller.error.value, textAlign: TextAlign.center),
            ),
          ),
        ),
      ];
    }

    final items = data.items;
    if (items.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Text(
              tr(LanguageKeys.teamMemberContentEmpty),
              style: const TextStyle(color: AppColors.teamBodyGrey, fontSize: 14),
            ),
          ),
        ),
      ];
    }

    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        sliver: SliverList.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) => _itemCard(items[index]),
        ),
      ),
    ];
  }

  Widget _itemCard(TeamMemberContentItem item) {
    final statusStyle = _statusStyle(item.status);

    return Material(
      color: AppColors.whiteColor,
      borderRadius: BorderRadius.circular(12),
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowBlack5,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.gray100,
                borderRadius: BorderRadius.circular(8),
              ),
              clipBehavior: Clip.antiAlias,
              child: item.logoUrl != null && item.logoUrl!.isNotEmpty
                  ? Image.network(
                      item.logoUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _logoPlaceholder(),
                    )
                  : _logoPlaceholder(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.teamTitle,
                      height: 24 / 16,
                    ),
                  ),
                  if (item.status != null && item.status!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusStyle.background,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        _statusLabel(item.status!),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: statusStyle.foreground,
                          height: 16 / 12,
                        ),
                      ),
                    ),
                  ],
                  if (item.subtitle != null && item.subtitle!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle!.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.teamBodyGrey,
                        height: 16 / 12,
                        letterSpacing: 0.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8, top: 12),
              child: Icon(Icons.chevron_right, color: AppColors.teamBodyGrey, size: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _logoPlaceholder() {
    return Center(
      child: Icon(Icons.business, color: AppColors.grey500, size: 22),
    );
  }

  _StatusStyle _statusStyle(String? status) {
    switch (status?.toLowerCase()) {
      case 'success':
      case 'active':
        return const _StatusStyle(
          background: AppColors.green100,
          foreground: AppColors.teamStatusSuccessFg,
        );
      case 'lost':
        return const _StatusStyle(
          background: AppColors.red200,
          foreground: AppColors.red600,
        );
      default:
        return const _StatusStyle(
          background: AppColors.orange100,
          foreground: AppColors.orange600,
        );
    }
  }

  String _statusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'success':
        return tr(LanguageKeys.teamMemberContentStatusSuccess);
      case 'active':
        return tr(LanguageKeys.teamMemberContentStatusActive);
      case 'lost':
        return tr(LanguageKeys.teamMemberContentStatusLost);
      default:
        return tr(LanguageKeys.teamMemberContentStatusPending);
    }
  }
}

class _StickySegmentedHeaderDelegate extends SliverPersistentHeaderDelegate {
  _StickySegmentedHeaderDelegate({required this.child});

  static const double _extent = 72;

  final Widget child;

  @override
  double get minExtent => _extent;

  @override
  double get maxExtent => _extent;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.teamPageBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _StickySegmentedHeaderDelegate oldDelegate) => false;
}

class _StatusStyle {
  const _StatusStyle({required this.background, required this.foreground});

  final Color background;
  final Color foreground;
}
