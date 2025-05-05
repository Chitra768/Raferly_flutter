import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/controller_bottom_navigation.dart';
import '../controller/controller_main_professional.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ControllerMainProfessional>();

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // Bottom Sheet Background
        Container(
          height: 90,
          margin: const EdgeInsets.only(top: 25),
          padding: const EdgeInsets.symmetric(horizontal: 62),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
          ),
          child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              navItem(
                icon: Icons.home,
                label: 'Home',
                isSelected: controller.pageIndex.value == 0,
                onTap: () => controller.changeTab(0),
              ),
              navItem(
                icon: Icons.search,
                label: 'Track',
                isSelected: controller.pageIndex.value == 1,
                onTap: () => controller.changeTab(1),
              ),
            ],
          )),
        ),

        // Floating Button
        Positioned(
          top: 0,
          child: Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 32),
          ),
        ),
      ],
    );
  }

  Widget navItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Icon(icon, color: isSelected ? Colors.purple : Colors.grey),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.purple : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
