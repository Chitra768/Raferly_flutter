import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_coworkerlist_deal.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';

class LikeAddCoworkerDialog extends StatelessWidget {
  final List<CoworkerlistDealData> coworkers;
  final void Function(int index)? onQrTap;

  const LikeAddCoworkerDialog({
    Key? key,
    required this.coworkers,
    this.onQrTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      tr(LanguageKeys.addCoworkers),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: stylePoppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close, size: 28),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ...coworkers.map((name) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () => onQrTap!(coworkers.indexOf(name)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(
                            name.dealName ?? '',
                            style: stylePoppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          trailing: GestureDetector(
                            onTap: onQrTap != null
                                ? () => onQrTap!(coworkers.indexOf(name))
                                : null,
                            child: Icon(FontAwesome.qrcode,
                                color: AppColors.primary, size: 28),
                          ),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
