import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/lead_tracking_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_lead_tracking.dart';
import 'package:referaly/models/model_send_lead.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/utils/translations.dart';

class LeadTrackingScreen extends StatelessWidget {
  LeadTrackingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LeadTrackingController controller = Get.put(LeadTrackingController());

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          tr(LanguageKeys.leadTracking),
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Show more options
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            // _buildHeader(),

            // Lead Information Section
            _buildLeadInfoSection(controller),

            // Lead Tracking Timeline
            Expanded(
              child: _buildLeadTrackingTimeline(controller),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.fontBlack),
            onPressed: () => Get.back(),
          ),
          Expanded(
            child: Text(
              'Lead Tracking',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.fontBlack,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: AppColors.fontBlack),
            onPressed: () {
              // Show more options
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLeadInfoSection(LeadTrackingController controller) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr(LanguageKeys.leadName),
            style: TextStyle(
              fontSize: 14,
              color: AppColors.greyFontColor,
            ),
          ),
          Obx(() => Text(
                '${controller.currentLead.value?.firstName ?? ''} ${controller.currentLead.value?.lastName ?? ''}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.fontBlack,
                ),
              )),
          const SizedBox(height: 10),
          Text(
            tr(LanguageKeys.businessReferrer),
            style: TextStyle(
              fontSize: 14,
              color: AppColors.bgDark,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
            ),
          ),
          Obx(() => GestureDetector(
                onTap: () {
                  // Navigate to business referrer profile
                },
                child: Text(
                  controller.currentLead.value?.deal?.createdDetail
                          ?.companyName ??
                      '',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.primary,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildLeadTrackingTimeline(LeadTrackingController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      // if (controller.currentLead.value?.stages == null) {
      //   return const Center(child: Text('No stages available'));
      // }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.currentLead.value!.leadTrack!.length,
        itemBuilder: (context, index) {
          final stage = controller.currentLead.value!.leadTrack![index];
          final isLast =
              index == controller.currentLead.value!.leadTrack!.length - 1;

          return _buildTimelineStage(controller, stage, index, isLast);
        },
      );
    });
  }

  Widget _buildTimelineStage(LeadTrackingController controller, LeadTrack stage,
      int index, bool isLast) {
    // Get the completed track count from the current lead data
    final completedTrack =
        int.tryParse(controller.currentLead.value?.completedTrack ?? '0') ?? 0;

    // A stage is completed if its index is less than the completed track count
    // completed_track: "1" means first stage (index 0) is completed
    // completed_track: "2" means first and second stages (index 0, 1) are completed
    final isCompleted = index < completedTrack;

    // A stage is current if it's the next stage to be completed
    final isCurrent = index == completedTrack;

    // A stage is upcoming if it's after the current stage
    final isUpcoming = index > completedTrack;

    AppHelper.showLog(
        'completedTrack=$completedTrack, isCompleted=$isCompleted, isCurrent=$isCurrent, isUpcoming=$isUpcoming');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline Icon and Line
        Column(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.primary
                    : isCurrent
                        ? AppColors.primary.withOpacity(0.2)
                        : Colors.grey[300],
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted
                      ? AppColors.primary
                      : isCurrent
                          ? AppColors.primary
                          : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    )
                  : isCurrent
                      ? Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            shape: BoxShape.circle,
                          ),
                        )
                      : Icon(
                          Icons.circle,
                          color: Colors.grey[400]!,
                          size: 15,
                        ),
            ),
            const SizedBox(height: 5),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: isCompleted
                    ? AppColors.primary
                    : isCurrent
                        ? AppColors.primary.withOpacity(0.5)
                        : Colors.grey[300],
              ),
            const SizedBox(height: 20),
          ],
        ),

        const SizedBox(width: 16),

        // Stage Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stage Title and Description
              Text(
                stage?.name ?? '',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isCompleted
                      ? AppColors.fontBlack
                      : isCurrent
                          ? AppColors.fontBlack
                          : AppColors.greyFontColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                stage?.comment ?? '',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.greyFontColor,
                ),
              ),

              // Status and Date
              if (isCompleted) ...[
                const SizedBox(height: 8),
                Text(
                  'Completed • ${_getCurrentDate()}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],

              // Comment Section
              if (stage.comment != null && stage.comment!.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildCommentBox(stage, controller),
              ],

              // Action Buttons for Current Stage
              if (isCurrent) ...[
                const SizedBox(height: 16),
                _buildActionButtons(controller, stage),
              ],

              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  // Helper method to get current date in formatted string
  String _getCurrentDate() {
    final now = DateTime.now();
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }

  Widget _buildCommentBox(LeadTrack stage, LeadTrackingController controller) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryLightPink,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  stage.comment ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.fontBlack,
                  ),
                ),
              ),
              if (stage.comment != null)
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  onPressed: () {
                    // Handle edit comment
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          // Comment Link for Completed Stages
          const SizedBox(height: 12),
          _buildCommentLink(controller, stage),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
      LeadTrackingController controller, LeadTrack stage) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () {
              controller.moveToNextStage(stage.id ?? '');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(tr(LanguageKeys.nextStep)),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward, size: 16),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () {
              _showAddCommentDialog(controller, stage);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(AppAssets.imgChat,
                    width: 16, height: 16, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(tr(LanguageKeys.comment)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentLink(LeadTrackingController controller, LeadTrack stage) {
    return GestureDetector(
      onTap: () {
        _showAddCommentDialog(controller, stage);
      },
      child: Text(
        'Comment to ${controller.currentLead.value?.deal?.createdDetail?.companyName ?? ''}',
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.primary,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  void _showAddCommentDialog(
      LeadTrackingController controller, LeadTrack stage) {
    final TextEditingController commentController = TextEditingController(
      text: stage.comment ?? '',
    );

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Comment for ${stage.name}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.fontBlack,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Enter your comment...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.grey300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.greyFontColor,
                        side: BorderSide(color: AppColors.grey300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (commentController.text.isNotEmpty) {
                          controller.addComment(
                              stage.id ?? '', commentController.text);
                          Get.back();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
