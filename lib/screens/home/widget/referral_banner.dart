// widgets/referral_banner.dart
import 'package:flutter/material.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:referaly/resources/app_colors.dart';

class ReferralBanner extends StatelessWidget {
  const ReferralBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return

      Container(
          margin: const EdgeInsets.symmetric(horizontal: 8,vertical: 30),
        child: Stack(
          children: [
            // SVG background
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SvgPicture.asset(
                  AppAssets.imgHomeBg,
                ),
              ),
            ),
            // Foreground content
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Referaly  ",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 14,fontWeight: FontWeight.w500),
                      ),
                      DecoratedBox(

                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(5.0),
                                bottomRight: Radius.circular(5.0),
                                topLeft: Radius.circular(5.0),
                                bottomLeft: Radius.circular(5.0)),
                            color: AppColors.whiteColor
                        ),
                        child:  Text(" Finder ", textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.fontBlue, fontSize: 14,fontWeight: FontWeight.w500),),
                      ),
                       const Text(
                        "  match your leads with",
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.white, fontSize: 14,fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "trusted professionals",
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(5.0),
                            bottomRight: Radius.circular(5.0),
                            topLeft: Radius.circular(5.0),
                            bottomLeft: Radius.circular(5.0)),
                        color: AppColors.whiteColor
                    ),
                    child:  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(" Find Referalers ", textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.fontBlue, fontSize: 14,fontWeight: FontWeight.w500),),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      );

  }
}
