import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
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
    final purple = const Color(0xFF8B3AFF);
    final isOtherChecked = _checked.isNotEmpty && _checked.last;
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.title,
              style: stylePoppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (widget.description.isNotEmpty)
              Text(
                widget.description,
                style: stylePoppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            if (widget.description.isNotEmpty) const SizedBox(height: 16),
            ...List.generate(widget.options.length, (index) {
              return CheckboxListTile(
                value: _checked[index],
                onChanged: (val) {
                  setState(() {
                    for (int i = 0; i < _checked.length; i++) {
                      _checked[i] = false;
                    }
                    _checked[index] = val ?? false;
                    _showError = false;
                  });
                },
                title: Text(widget.options[index],
                    style: stylePoppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    )),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                dense: true,
                visualDensity: VisualDensity.compact,
              );
            }),
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
              const SizedBox(height: 8),
              TextField(
                controller: _otherController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
                minLines: 1,
                maxLines: 2,
              ),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.black, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(width: 1),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 17),
                    ),
                    onPressed: () {
                      if (widget.onCancel != null) {
                        widget.onCancel!();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(tr(LanguageKeys.cancel),
                        style: stylePoppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(width: 1),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 17),
                    ),
                    onPressed: () {
                      final selectedIndex = _checked.indexWhere((v) => v);
                      if (selectedIndex == -1) {
                        setState(() {
                          _showError = true;
                        });
                        return;
                      }

                      String? selectedValue;
                      if (selectedIndex == widget.options.length - 1) {
                        // 'Other' selected
                        selectedValue = _otherController.text.trim();
                      } else {
                        selectedValue = widget.options[selectedIndex];
                      }

                      widget.onYes(selectedValue);
                      Navigator.of(context).pop();
                    },
                    child: Text(tr(LanguageKeys.yes),
                        style: stylePoppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
