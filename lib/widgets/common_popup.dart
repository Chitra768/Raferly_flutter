import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';

class CommonPopup extends StatefulWidget {
  final String title;
  final String description;
  final List<String> options;
  final void Function(String? selectedValue) onYes;
  final VoidCallback? onCancel;
  final String yesText;
  final String cancelText;

  const CommonPopup({
    Key? key,
    required this.title,
    required this.description,
    required this.options,
    required this.onYes,
    this.onCancel,
    this.yesText = 'Yes',
    this.cancelText = 'Cancel',
  }) : super(key: key);

  @override
  State<CommonPopup> createState() => _CommonPopupState();
}

class _CommonPopupState extends State<CommonPopup> {
  late List<bool> _checked;
  final TextEditingController _otherController = TextEditingController();
  bool _showError = false;

  @override
  void initState() {
    super.initState();
    _checked = List.filled(widget.options.length, false);
  }

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isOtherChecked = _checked.isNotEmpty && _checked.last;

    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 64,
                    width: 64,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFFF5ECFF), Color(0xFFE6D7FF)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: SvgPicture.asset(AppAssets.imgInfoSvg),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.title,
                    style: stylePoppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    tr(LanguageKeys.lostLeadSubTitle),
                    style: stylePoppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (widget.description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      widget.description,
                      style: stylePoppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 24),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.options.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final isSelected = _checked[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            for (int i = 0; i < _checked.length; i++) {
                              _checked[i] = false;
                            }
                            _checked[index] = true;
                            _showError = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : const Color(0xFFE5E5EA),
                              width: 1.5,
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : const Color(0xFFD1D1D6),
                                    width: 2,
                                  ),
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.transparent,
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check,
                                        size: 14,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  widget.options[index],
                                  style: stylePoppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  if (_showError) ...[
                    const SizedBox(height: 8),
                    Obx(
                      () => Text(
                        tr(LanguageKeys.reasonValidation),
                        textAlign: TextAlign.center,
                        style: stylePoppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                  if (isOtherChecked) ...[
                    const SizedBox(height: 16),
                    TextField(
                      controller: _otherController,
                      decoration: InputDecoration(
                        hintText: tr(LanguageKeys.enterReason),
                        hintStyle: stylePoppins(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF7F7F9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                      minLines: 1,
                      maxLines: 3,
                    ),
                  ],
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xFFF5F5F7),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          onPressed: () {
                            if (widget.onCancel != null) {
                              widget.onCancel!();
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text(
                            widget.cancelText.isNotEmpty
                                ? widget.cancelText
                                : tr(LanguageKeys.cancel),
                            style: stylePoppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          onPressed: () {
                            final selectedIndex =
                                _checked.indexWhere((v) => v == true);
                            if (selectedIndex == -1) {
                              setState(() {
                                _showError = true;
                              });
                              return;
                            }

                            String? selectedValue;
                            if (selectedIndex == widget.options.length - 1) {
                              selectedValue = _otherController.text.trim();
                              if (selectedValue.isEmpty) {
                                setState(() {
                                  _showError = true;
                                });
                                return;
                              }
                            } else {
                              selectedValue = widget.options[selectedIndex];
                            }

                            widget.onYes(selectedValue);
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            tr(LanguageKeys.confirm),
                            style: stylePoppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
