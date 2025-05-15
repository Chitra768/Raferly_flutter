import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/document_screen.dart';
import '../controllers/active_goal_controller.dart';
import '../models/model_active_goal.dart';

class ActiveGoalScreen extends StatelessWidget {
  static String pageId = "/activeGoal";
  final controller = Get.put(ActiveGoalController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Active Deals",
          style: stylePoppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.activeGoals.isEmpty) {
          return const Center(child: Text('No active goals found.'));
        }
        return ListView.builder(
          itemCount: controller.activeGoals.length,
          itemBuilder: (context, index) {
            final Data goal = controller.activeGoals[index];
            return Container(
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.grey200),
              ),
              margin: const EdgeInsets.all(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image or placeholder
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child:
                              goal.createdDetail?.avatarUrl?.isNotEmpty == true
                                  ? Image.network(
                                      goal.createdDetail!.avatarUrl!,
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      width: 48,
                                      height: 48,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.person,
                                          size: 32, color: Colors.blue),
                                    ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (goal.createdDetail?.firstName ?? '') +
                                            (goal.createdDetail?.lastName ??
                                                '') !=
                                        ''
                                    ? '${goal.createdDetail?.firstName ?? ''} ${goal.createdDetail?.lastName ?? ''}'
                                        .trim()
                                    : 'NA',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                goal.dealName ?? 'No description',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Divider(
                      color: AppColors.grey200,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(DocumentScreen.pageId, arguments: {
                            'id': goal.id.toString(),
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.primary),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            'Documents',
                            style: stylePoppins(
                              color: AppColors.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
