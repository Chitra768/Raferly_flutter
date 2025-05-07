import 'package:flutter/material.dart';
import 'package:referaly/resources/app_colors.dart';

class CustomSegmentControl extends StatelessWidget {
  final bool isFirstSelected;
  final String firstLabel;
  final String secondLabel;
  final ValueChanged<bool> onSelectionChanged;
  final double fontSize;

  const CustomSegmentControl({
    super.key,
    required this.isFirstSelected,
    required this.firstLabel,
    required this.secondLabel,
    required this.onSelectionChanged,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onSelectionChanged(true),
              child: Container(
                decoration: BoxDecoration(
                  color: isFirstSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  firstLabel,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: isFirstSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onSelectionChanged(false),
              child: Container(
                decoration: BoxDecoration(
                  color: !isFirstSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  secondLabel,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: !isFirstSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
