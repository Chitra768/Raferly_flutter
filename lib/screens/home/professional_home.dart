
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:referaly/screens/home/widget/connected_section.dart';
import 'package:referaly/screens/home/widget/home_header.dart';
import 'package:referaly/screens/home/widget/referral_banner.dart';
import 'package:referaly/screens/home/widget/section_tiles.dart';
import 'package:referaly/screens/home/widget/stats_grid.dart';

class ProfessionalHome extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomeHeader(),
            SectionTiles(),
            ReferralBanner(),
            ConnectedSection(),
          ],
        ),
      ),
    );
  }

}