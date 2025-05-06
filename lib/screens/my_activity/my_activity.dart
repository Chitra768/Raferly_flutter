
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/resources/app_colors.dart';

import '../../controller/controller_my_activity.dart';

class MyActivityScreen extends GetView<MyActivityController> {
  static String pageId = '/screenActivity';

  const MyActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        title: const Text("For my activity"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Obx(
            () =>
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Tab Section
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20), // Rounded corners for the grey box
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => controller.changeTab(0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                color: controller.selectedTab.value == 0 ? Colors.purple : Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),

                                ),
                                border: Border.all(
                                  color: Colors.transparent// a border to make it visually consistent
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "My contracts",
                                  style: TextStyle(
                                    color: controller.selectedTab.value == 0 ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => controller.changeTab(1),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                color: controller.selectedTab.value == 1 ? Colors.purple : Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                border: Border.all(
                                  color: Colors.transparent, // Add a border to make it visually consistent
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "My Network",
                                  style: TextStyle(
                                    color: controller.selectedTab.value == 1 ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Referrers Card
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 16), // Margin on both sides
                    child: Card(
                      color: Colors.purple,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Icon(Icons.people, color: Colors.white, size: 40),
                            const Text(
                              "Referrers",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${controller.referrersCount}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Icons Row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(5, (index) {
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.group,
                                color: Colors.purple,
                                size: 32,
                              ),
                            ),
                            Positioned(
                              top: -4,
                              right: -4,
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.blueAccent,
                                child: Text(
                                  index == 0 ? "0" : "+", // Example: Badge content
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Business Referrers
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Business Referrers",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.businessReferrers.length,
                      itemBuilder: (context, index) {
                        final referrer = controller.businessReferrers[index];
                        return Card(
                          margin:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Column(
                            children: [
                              ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  child: Icon(Icons.person, color: Colors.white),
                                ),
                                title: Text(referrer['name'] as String),
                                trailing: IconButton(
                                  icon: Icon(referrer['expanded'] as bool
                                      ? Icons.expand_less
                                      : Icons.expand_more),
                                  onPressed: () =>
                                      controller.toggleReferrerExpansion(index),
                                ),
                              ),
                              if (referrer['expanded'] as bool)
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    "Additional information about ${referrer['name']}",
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  // Footer
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "With the free version, you can add a maximum of 5 business referrers.",
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
