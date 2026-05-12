import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/controller_feedback.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/primary_button.dart';

/// Screen for submitting user feedback (localized EN / ES / FR).
class FeedbacksScreen extends GetView<FeedbackController> {
  static const String pageId = '/feedbacks';

  const FeedbacksScreen({super.key});

  static const Color _segmentTrack = Color(0xFFF3F4F6);
  static const Color _inputFill = Color(0xFFFAFAFA);
  static const Color _inputBorder = Color(0xFFF0F0F0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            _FeedbackAppBar(onBack: () => Get.back()),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      tr(LanguageKeys.feedbackScreenSubtitle),
                      textAlign: TextAlign.center,
                      style: stylePoppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppColors.k6B7280,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Obx(
                      () => _SlidingSegmentControl(
                        key: const ValueKey('feedback_segment_tabs'),
                        selected: controller.selectedTab.value,
                        onSelect: controller.selectTab,
                        ideaLabel: tr(LanguageKeys.feedbackTabIdeaShort),
                        bugLabel: tr(LanguageKeys.feedbackTabBugShort),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tr(LanguageKeys.feedbackFieldTitleLabel),
                              style: stylePoppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: controller.titleController,
                              style: stylePoppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF111827),
                              ),
                              decoration: InputDecoration(
                                hintText: tr(LanguageKeys.feedbackTitlePlaceholder),
                                hintStyle: stylePoppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textTitleHint,
                                ),
                                filled: true,
                                fillColor: _inputFill,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: _inputBorder),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: _inputBorder),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: AppColors.primary.withValues(alpha: 0.6),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              tr(LanguageKeys.feedbackFieldDetailsLabel),
                              style: stylePoppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: controller.descriptionController,
                              minLines: 6,
                              maxLines: 12,
                              style: stylePoppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF111827),
                              ),
                              decoration: InputDecoration(
                                hintText:
                                    tr(LanguageKeys.feedbackDetailsPlaceholder),
                                hintStyle: stylePoppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textTitleHint,
                                ),
                                alignLabelWithHint: true,
                                filled: true,
                                fillColor: _inputFill,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: _inputBorder),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: _inputBorder),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: AppColors.primary.withValues(alpha: 0.6),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => PrimaryButton(
                        text: tr(LanguageKeys.feedbackSubmitCta),
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.onSubmit,
                        isLoading: controller.isLoading.value,
                        borderRadius: 16,
                        height: 52,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedbackAppBar extends StatelessWidget {
  final VoidCallback onBack;

  const _FeedbackAppBar({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Row(
        children: [
          Material(
            color: AppColors.circleBackgrey,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onBack,
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(Icons.arrow_back, size: 20, color: Colors.black),
              ),
            ),
          ),
          Expanded(
            child: Text(
              tr(LanguageKeys.feedbackScreenHeadline),
              textAlign: TextAlign.center,
              style: stylePoppins(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF111827),
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

/// Single [AnimationController] drives pill position **and** both label colors so
/// nothing gets one frame out of sync (avoids grey “blink”). No [InkWell] splash.
class _SlidingSegmentControl extends StatefulWidget {
  final FeedbackTabKind selected;
  final void Function(FeedbackTabKind) onSelect;
  final String ideaLabel;
  final String bugLabel;

  const _SlidingSegmentControl({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.ideaLabel,
    required this.bugLabel,
  });

  static const Duration _kDuration = Duration(milliseconds: 320);
  static const Curve _kCurve = Curves.easeInOutCubic;

  @override
  State<_SlidingSegmentControl> createState() => _SlidingSegmentControlState();
}

class _SlidingSegmentControlState extends State<_SlidingSegmentControl>
    with SingleTickerProviderStateMixin {
  late AnimationController _slide;

  @override
  void initState() {
    super.initState();
    _slide = AnimationController(
      vsync: this,
      duration: _SlidingSegmentControl._kDuration,
      value: widget.selected == FeedbackTabKind.idea ? 0.0 : 1.0,
    );
  }

  @override
  void didUpdateWidget(covariant _SlidingSegmentControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected != oldWidget.selected) {
      if (widget.selected == FeedbackTabKind.idea) {
        _slide.reverse();
      } else {
        _slide.forward();
      }
    }
  }

  @override
  void dispose() {
    _slide.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: ColoredBox(
        color: FeedbacksScreen._segmentTrack,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final segmentW = constraints.maxWidth * 0.5;
              return SizedBox(
                height: 48,
                child: AnimatedBuilder(
                  animation: _slide,
                  builder: (context, child) {
                    final t = _SlidingSegmentControl._kCurve.transform(_slide.value);
                    final pillLeft = t * segmentW;
                    final ideaColor = Color.lerp(
                      AppColors.primary,
                      AppColors.k6B7280,
                      t,
                    )!;
                    final bugColor = Color.lerp(
                      AppColors.k6B7280,
                      AppColors.primary,
                      t,
                    )!;
                    final ideaWeight =
                        (1.0 - t) > 0.52 ? FontWeight.w600 : FontWeight.w500;
                    final bugWeight =
                        t > 0.52 ? FontWeight.w600 : FontWeight.w500;

                    return Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        Positioned(
                          left: pillLeft,
                          top: 0,
                          bottom: 0,
                          width: segmentW,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () =>
                                    widget.onSelect(FeedbackTabKind.idea),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.lightbulb_outline,
                                        size: 18,
                                        color: ideaColor,
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          widget.ideaLabel,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: stylePoppins(
                                            fontSize: 14,
                                            fontWeight: ideaWeight,
                                            color: ideaColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () =>
                                    widget.onSelect(FeedbackTabKind.bug),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.bug_report_outlined,
                                        size: 18,
                                        color: bugColor,
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          widget.bugLabel,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: stylePoppins(
                                            fontSize: 14,
                                            fontWeight: bugWeight,
                                            color: bugColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
