import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart' show Get;
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:referaly/controller/controller_main_professional.dart'
    show ControllerMainProfessional;
import 'package:referaly/controller/track_lead.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_dashboard.dart';
import 'package:referaly/resources/app_helper.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/screens/activity/activity_category_screen.dart';
import 'package:referaly/screens/dashboard/my_activity_screen.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/share_popup.dart';

import '../../resources/app_assets.dart';
import '../../resources/app_colors.dart';
import '../../widgets/app_drawer.dart';

class IndividualHome extends StatefulWidget {
  static String pageId = "/homeWithoutPrimum";
  final ControllerMainProfessional controller;
  final TrackLeadsController trackLeadCntrl;
  const IndividualHome(
      {super.key, required this.controller, required this.trackLeadCntrl});

  @override
  State<IndividualHome> createState() => _IndividualHomeState();
}

class _IndividualHomeState extends State<IndividualHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<void> downloadAndOpenPdf(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/temp.pdf');
      await file.writeAsBytes(response.bodyBytes);

      final result = await OpenFilex.open(file.path);

      if (result.type != ResultType.done) {
        // handle error
        debugPrint('Failed to open: ${result.message}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.grey100,
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          final controller = Get.find<ControllerMainProfessional>();
          await controller.getProfile();
          await controller.getDashboard();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildCompanyOverview(),
              _buildConnectionSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      decoration: const BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
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
            child: _buildAnalyticsCard(
              title: tr(LanguageKeys.leadSent),
              value: widget.controller.dashboard.value?.data?.totalLeads
                      ?.toString() ??
                  '0',
              iconPath: AppAssets.imgHomeSent,
              onTap: () {
                widget.trackLeadCntrl.toggleLeadType(false);
                widget.controller.changeTab(1);
              },
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: _buildAnalyticsCard(
              title: tr(LanguageKeys.commissionReceived),
              value: widget.controller.formatCompact(int.parse(widget
                      .controller.dashboard.value?.data?.incomeGenerated
                      ?.toString() ??
                  '0')),
              iconPath: AppAssets.imgHomeReceived,
              onTap: () {
                Get.toNamed(MyActivityScreen.pageId);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard(
      {required String title,
      required String value,
      required String iconPath,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 110,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 22,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                SvgPicture.asset(iconPath, height: 36, width: 36),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyOverview() {
    // final List<String> documents = [
    //   'Term & Condition.pdf',
    //   'Terms & Condition.pdf',
    //   'Price List',
    // ];

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
                    Text(
                      widget.controller.profile.value?.data?.companyName ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.controller.profile.value?.data?.companyNumber ??
                          '',
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
            padding: const EdgeInsets.fromLTRB(5, 15, 0, 0),
            child: Text(
              widget.controller.profile.value?.data?.companyDescription ?? '',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.k6B7280,
              ),
            ),
          ),
          Obx(
            () => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.controller.documentList.value.length,
              itemBuilder: (context, index) {
                return _buildDocumentRow(
                    widget.controller.documentList.value[index]);
              },
            ),
          ),
          const SizedBox(height: 15),
          _buildSendLeadButton(),
        ],
      ),
    );
  }

  Widget _buildDocumentRow(DealDocuments object) {
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
              object.name ?? '',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              AppHelper.showLog('object.url ?? ${object.document}');
              downloadAndOpenPdf(object.document ?? '');
            },
            child: Container(
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
          ),
          GestureDetector(
            onTap: () {
              Get.dialog(
                SharePopup(
                  title: object.name ?? '',
                  link: object.document ?? '',
                ),
              );
            },
            child: Container(
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
          ),
        ],
      ),
    );
  }

  Widget _buildSendLeadButton() {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          widget.trackLeadCntrl.toggleLeadType(false);
          widget.controller.changeTab(1);
        },
        child: Obx(
          () => Text(
            tr(LanguageKeys.sendLead),
            style: stylePoppins(
              color: AppColors.whiteColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
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
          Text(tr(LanguageKeys.LetsGetYouConnected),
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: AppColors.fontBlack)),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildConnectionCard(
                  title: tr(LanguageKeys.areYouAProfessional),
                  icon: AppAssets.imgProfessionalIcon,
                  onTap: () {
                    _showProfessionalDialog();
                  },
                ),
              ),
              Expanded(
                child: _buildConnectionCard(
                  title: tr(LanguageKeys.howItWorks),
                  icon: AppAssets.imgHowItWorksIcon,
                  onTap: () {
                    Get.toNamed(ActivityCategoryScreen.pageId);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionCard(
      {required String title,
      required String icon,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 178,
        height: 235,
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8), topLeft: Radius.circular(8)),
                child: Image.asset(
                  icon,
                  height: 148,
                  width: 178,
                  fit: BoxFit.cover,
                )),
            const SizedBox(height: 8),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfessionalDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => Text(
                    tr(LanguageKeys
                        .ifYouAreAProfessionalYouWillGainAccessToADifferentInterfaceNotOnlyToSendLeadsButAlsoToReceiveThemForYourOwnBusiness),
                    textAlign: TextAlign.center,
                    style:
                        stylePoppins(fontSize: 16, color: AppColors.fontBlack),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("⚠️", style: TextStyle(fontSize: 18)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Obx(
                        () => Text(
                          tr(LanguageKeys
                              .onlySwitchIfYouAreLookingToReceiveClientsThroughReferaly),
                          textAlign: TextAlign.center,
                          style: stylePoppins(
                              fontSize: 15, color: AppColors.fontBlack),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8E2DE2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Obx(
                        () => Text(tr(LanguageKeys.okay),
                            style: stylePoppins(color: AppColors.whiteColor)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CmnAppBar extends StatelessWidget {
  CmnAppBar({
    super.key,
    required GlobalKey<ScaffoldState> scaffoldKey,
  }) : _scaffoldKey = scaffoldKey;

  final GlobalKey<ScaffoldState> _scaffoldKey;

  final ControllerMainProfessional controllerr =
      Get.find<ControllerMainProfessional>();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Obx(
                  () => controllerr.profileImagePath.isNotEmpty
                      ? Image.network(
                          controllerr.profileImagePath.value,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.person,
                            size: 50,
                            color: AppColors.primary,
                          ),
                        )
                      : Image.asset(
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
                )),
            const SizedBox(width: 15),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    tr(LanguageKeys.hi),
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  ",",
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(
                  () => Text(
                    '${controllerr.profile.value?.data?.firstName ?? ''} ${controllerr.profile.value?.data?.lastName ?? ''}',
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
          child: Icon(
            Icons.menu,
            color: AppColors.whiteColor,
            size: 40,
          ),
        ),
      ],
    );
  }
}
