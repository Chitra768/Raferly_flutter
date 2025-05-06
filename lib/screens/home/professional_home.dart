
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:referaly/screens/home/widget/connected_section.dart';
import 'package:referaly/screens/home/widget/home_header.dart';
import 'package:referaly/screens/home/widget/referral_banner.dart';
import 'package:referaly/screens/home/widget/section_tiles.dart';
import 'package:referaly/screens/home/widget/stats_grid.dart';

class ProfessionalHome extends StatelessWidget
{
  const ProfessionalHome({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomeHeader(),
            SizedBox(height: 10,),
            SectionTiles(),
            SizedBox(height: 10,),
            ReferralBanner(),
            SizedBox(height: 10,),
            ConnectedSection(),
          ],
        ),
      ),
    );
  }

}