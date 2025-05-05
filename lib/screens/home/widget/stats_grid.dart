// widgets/stats_grid.dart
import 'package:flutter/material.dart';

class StatsGrid extends StatelessWidget {
  const StatsGrid({super.key});

  Widget buildStat(String label, String value, IconData icon, bool purple) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: purple ? const Color(0xFF8E2DE2) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: purple ? Colors.white : Colors.orange),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              color: purple ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: purple ? Colors.white : Colors.black54,
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        crossAxisCount: 2,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
        children: [
          buildStat('Leads Received', '80', Icons.card_giftcard, false),
          buildStat('Leads Sent', '80', Icons.send, false),
          buildStat('Number of Partners', '80', Icons.handshake, false),
          buildStat('Commissions Received', '80', Icons.attach_money, false),
        ],
      ),
    );
  }
}
