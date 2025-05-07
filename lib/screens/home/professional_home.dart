import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:referaly/screens/home/widget/connected_section.dart';
import 'package:referaly/screens/home/widget/home_header.dart';
import 'package:referaly/screens/home/widget/referral_banner.dart';
import 'package:referaly/screens/home/widget/section_tiles.dart';
import 'package:referaly/screens/home/widget/stats_grid.dart';
import 'package:referaly/widgets/app_drawer.dart';

class ProfessionalHome extends StatelessWidget {
  const ProfessionalHome({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomeHeader(scaffoldKey: _scaffoldKey),
            const SizedBox(
              height: 10,
            ),
            SectionTiles(),
            const SizedBox(
              height: 10,
            ),
            ReferralBanner(),
            const SizedBox(
              height: 10,
            ),
            ConnectedSection(),
          ],
        ),
      ),
    );
  }
}
