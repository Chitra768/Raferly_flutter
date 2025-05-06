// widgets/connected_section.dart
import 'package:flutter/material.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
class ConnectedSection extends StatelessWidget {
  const ConnectedSection({super.key});

  Widget card(String label, String imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
             borderRadius: const BorderRadius.only(topRight: Radius.circular(8),topLeft:  Radius.circular(8)),
              child: Image.asset(imagePath,height:148,width: 140, fit: BoxFit.cover,)),
          const SizedBox(height: 8),
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Text(
              label ,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                       ),
           ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Let’s Get You Connected!",
                  style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: AppColors.fontBlack))),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              card("connected\ncard", AppAssets.imgFrame1),
              card("Consulting call with\nan expert", AppAssets.imgFrame2),
              card("How it\nsworks",AppAssets.imgFrame3),
            ],
          ),
        )
      ],
    );
  }
}
