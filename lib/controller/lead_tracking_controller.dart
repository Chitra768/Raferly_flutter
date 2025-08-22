import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/models/model_lead_tracking.dart';
import 'package:referaly/models/model_send_lead.dart';
import 'package:referaly/resources/app_colors.dart';

class LeadTrackingController extends GetxController {
  // Observable variables
  final Rx<SendLeadData?> currentLead = Rx<SendLeadData?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxBool isEditingComment = false.obs;
  final RxString editingCommentId = ''.obs;
  final RxString editingCommentText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    currentLead.value = Get.arguments;
    print('lead: ${currentLead.value?.companyName}');
    

    // loadSampleData(); // For development, replace with actual API call
  }

  // Load sample data for development
  // void loadSampleData() {
  //   try {
  //     isLoading.value = true;
  //     error.value = '';

  //     // Simulate API delay
  //     Future.delayed(const Duration(milliseconds: 500), () {
  //       currentLead.value = SendLeadData.getSampleLead();
  //       isLoading.value = false;
  //     });
  //   } catch (e) {
  //     error.value = e.toString();
  //     isLoading.value = false;
  //   }
  // }

  // Load lead data from API (replace with actual implementation)
  Future<void> loadLeadData(String leadId) async {
    // try {
    //   isLoading.value = true;
    //   error.value = '';

    //   // TODO: Replace with actual API call
    //   // final response = await RESTAuth.getLeadTracking(leadId);
    //   // if (response is ApiSuccess<LeadTrackingModel>) {
    //   //   currentLead.value = response.data;
    //   // } else if (response is ApiFailure) {
    //   //   error.value = response.error.message ?? 'Failed to load lead data';
    //   // }

    //   // For now, use sample data
    //   currentLead.value = SendLeadData.getSampleLead();
    // } catch (e) {
    //   error.value = e.toString();
    // } finally {
    //   isLoading.value = false;
    // }
  }

  // Move to next stage
  void moveToNextStage(String currentStageId) {
    // if (currentLead.value?.leadStages == null) return;

    // final stages = currentLead.value!.leadStages!;
    // final currentIndex =
    //     stages.indexWhere((stage) => stage.id == currentStageId);

    // if (currentIndex >= 0 && currentIndex < stages.length - 1) {
    //   // Mark current stage as completed
    //   stages[currentIndex] = stages[currentIndex].copyWith(
    //     status: 'completed',
    //     completedDate: _getCurrentDate(),
    //   );

    //   // Mark next stage as current
    //   stages[currentIndex + 1] = stages[currentIndex + 1].copyWith(
    //     status: 'current',
    //   );

    //   currentLead.refresh();
    //   update();
    // }
  }

  // Add or update comment
  void addComment(String stageId, String comment) {
    // if (currentLead.value?.stages == null) return;

    // final stages = currentLead.value!.stages!;
    // final stageIndex = stages.indexWhere((stage) => stage.id == stageId);

    // if (stageIndex >= 0) {
    //   stages[stageIndex] = stages[stageIndex].copyWith(
    //     comment: comment,
    //   );

    //   currentLead.refresh();
    //   update();
    // }
  }

  // Start editing comment
  void startEditingComment(String stageId, String currentComment) {
    editingCommentId.value = stageId;
    editingCommentText.value = currentComment;
    isEditingComment.value = true;
  }

  // Save edited comment
  void saveEditedComment() {
    if (editingCommentId.value.isNotEmpty) {
      addComment(editingCommentId.value, editingCommentText.value);
      cancelEditingComment();
    }
  }

  // Cancel editing comment
  void cancelEditingComment() {
    editingCommentId.value = '';
    editingCommentText.value = '';
    isEditingComment.value = false;
  }

  // Get current date in formatted string
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

  // Get stage status color
  Color getStageStatusColor(String? status) {
    switch (status) {
      case 'completed':
        return AppColors.primary;
      case 'current':
        return AppColors.primary;
      case 'upcoming':
        return AppColors.grey300;
      default:
        return AppColors.grey300;
    }
  }

  // Get stage status icon
  IconData getStageStatusIcon(String? status) {
    switch (status) {
      case 'completed':
        return Icons.check;
      case 'current':
        return Icons.circle;
      case 'upcoming':
        return Icons.circle;
      default:
        return Icons.circle;
    }
  }

  // Check if stage is completed
  bool isStageCompleted(String? status) {
    return status == 'completed';
  }

  // Check if stage is current
  bool isStageCurrent(String? status) {
    return status == 'current';
  }

  // Check if stage is upcoming
  bool isStageUpcoming(String? status) {
    return status == 'upcoming';
  }
}

// Extension to create copy of LeadStage
extension LeadStageExtension on LeadStage {
  LeadStage copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    String? completedDate,
    String? comment,
    bool? isEditable,
  }) {
    return LeadStage(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      completedDate: completedDate ?? this.completedDate,
      comment: comment ?? this.comment,
      isEditable: isEditable ?? this.isEditable,
    );
  }
}
