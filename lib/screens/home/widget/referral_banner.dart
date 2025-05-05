// widgets/referral_banner.dart
import 'package:flutter/material.dart';

class ReferralBanner extends StatelessWidget {
  const ReferralBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF9F8FEF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            "Referaly Finder match your leads with trusted professionals.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.purple,
            ),
            child: const Text("Find Referalers"),
          )
        ],
      ),
    );
  }
}
