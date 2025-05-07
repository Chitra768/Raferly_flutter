import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../resources/app_assets.dart';
import '../../resources/app_colors.dart';
import '../../widgets/app_drawer.dart';

class IndividualHome extends StatefulWidget {
  static String pageId = "/homeWithoutPrimum";

  const IndividualHome({super.key});

  @override
  State<IndividualHome> createState() => _IndividualHomeState();
}

class _IndividualHomeState extends State<IndividualHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.grey100,
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 20),
              child: Text(
                'Company Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildCompanyOverview(),
            _buildConnectionSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          CmnAppBar(scaffoldKey: _scaffoldKey),
          _buildAnalyticsCards(),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCards() {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Row(
        children: [
          Expanded(
            child: _buildAnalyticsCard(title: 'Leads\nSent', value: '80', iconPath: AppAssets.imgLeadIcon),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: _buildAnalyticsCard(
                title: 'Commissions\nReceived', value: '80', iconPath: AppAssets.imgCommissionIcon),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard({required String title, required String value, required String iconPath}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Image.asset(
            iconPath,
            width: 25,
            height: 25,
          )
        ],
      ),
    );
  }

  Widget _buildCompanyOverview() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: Icon(Icons.person, color: AppColors.grey600),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'GreenTech Servicesr',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Tech Services',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 15, 0, 15),
            child: Text(
              'GreenTech Services provide top-notch home maintenance solutions, including plumbing, electrician at your doorstep.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.k6B7280,
              ),
            ),
          ),
          _buildDocumentRow('Term & Condition.pdf'),
          _buildDocumentRow('Terms & Condition.pdf'),
          _buildDocumentRow('Price List'),
          const SizedBox(height: 15),
          _buildSendLeadButton(),
        ],
      ),
    );
  }

  Widget _buildDocumentRow(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.pdfBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'PDF',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          Container(
              height: 40,
              width: 40,
              margin: const EdgeInsets.only(right: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SvgPicture.asset(
                AppAssets.imgDocIcon,
                height: 20,
                width: 20,
              )),
          Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SvgPicture.asset(
                AppAssets.imgShareIcon,
                height: 20,
                width: 20,
              )),
        ],
      ),
    );
  }

  Widget _buildSendLeadButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {},
        child: const Text(
          'Send a lead',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Let\'s Get You Connected!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildConnectionCard(
                  title: 'Are you a\nprofessional?',
                  icon: AppAssets.imgProfessionalIcon,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildConnectionCard(
                  title: 'How it \nworks',
                  icon: AppAssets.imgHowItWorksIcon,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionCard({required String title, required String icon}) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Image.asset(
            icon,
          ),
          const SizedBox(height: 15),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15)
        ],
      ),
    );
  }
}

class CmnAppBar extends StatelessWidget {
  const CmnAppBar({
    super.key,
    required GlobalKey<ScaffoldState> scaffoldKey,
  }) : _scaffoldKey = scaffoldKey;

  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: AppColors.whiteColor,
              child: ClipOval(
                child: Image.asset(
                  AppAssets.imgProfileImage,
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.person,
                    size: 30,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello,',
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Arnaud Attencia !!',
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.menu,
              color: AppColors.whiteColor,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }
}
