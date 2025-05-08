
import 'package:flutter/material.dart';



class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 80,
          decoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.emoji_events, color: Colors.white54, size: 30),
              Icon(Icons.pie_chart, color: Colors.white54, size: 30),
              SizedBox(width: 50), // Space for FAB
              Icon(Icons.video_library, color: Colors.white54, size: 30),
              Icon(Icons.person, color: Colors.white54, size: 30),
            ],
          ),
        ),
        Positioned(
          top: -10,
          child: Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.limeAccent,
              border: Border.all(color: Colors.purple, width: 3),
            ),
            child: const Center(
              child: Icon(Icons.home, color: Colors.blue, size: 30),
            ),
          ),
        ),
      ],
    );
  }
}


