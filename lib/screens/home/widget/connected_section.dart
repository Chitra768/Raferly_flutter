// widgets/connected_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class ConnectedSection extends StatelessWidget {
  const ConnectedSection({super.key});

  Widget card(String label, String imagePath) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
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
          SvgPicture.asset("assetPath", width: 40),
          const SizedBox(height: 8),
          Text(
            "Test",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Let’s Get You Connected!",
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              card("connected card", 'assets/card.png'),
              card("Consulting call with an expert", 'assets/expert.png'),
              card("How it works", 'assets/settings.png'),
            ],
          ),
        )
      ],
    );
  }
}
