import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/controller_feedback.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/widgets/custom_app_bar.dart';
import 'package:referaly/widgets/primary_button.dart';

/// Screen for submitting user feedback
class FeedbacksScreen extends GetView<FeedbackController> {
  static const String pageId = '/feedbacks';

  const FeedbacksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: const CommonAppBar(
        title: 'Feedbacks',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Feedback types',
                style: stylePoppins(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedType.value.isEmpty ? null : controller.selectedType.value,
                  items: controller.feedbackTypes
                      .map((type) => DropdownMenuItem<String>(
                            value: type,
                            child: Text(
                              type,
                              style: stylePoppins(fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                          ))
                      .toList(),
                  onChanged: controller.onTypeChanged,
                  decoration: InputDecoration(
                    hintText: 'Choose One option',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Description',
                    style: stylePoppins(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    ' *',
                    style: stylePoppins(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.error300),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Description',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: PrimaryButton(
                  text: 'Submit',
                  onPressed: controller.onSubmit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
