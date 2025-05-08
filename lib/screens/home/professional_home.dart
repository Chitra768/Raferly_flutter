import 'package:flutter/material.dart';
import 'package:referaly/screens/home/widget/connected_section.dart';
import 'package:referaly/screens/home/widget/home_header.dart';
import 'package:referaly/screens/home/widget/referral_banner.dart';
import 'package:referaly/screens/home/widget/section_tiles.dart';
import 'package:referaly/widgets/app_drawer.dart';

class ProfessionalHome extends StatelessWidget {
  const ProfessionalHome({super.key});

  @override
  Widget build(BuildContext context) {
    final drawerKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      drawer: const AppDrawer(),
      key: drawerKey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomeHeader(drawerKey: drawerKey),
            const SizedBox(
              height: 10,
            ),
            const SectionTiles(),
            const SizedBox(
              height: 10,
            ),
            const ReferralBanner(),
            const SizedBox(
              height: 10,
            ),
            const ConnectedSection(),
          ],
        ),
      ),
    );
  }
}
