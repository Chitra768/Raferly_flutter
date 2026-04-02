import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ReferralLinkSuccessScreen extends StatefulWidget {
  static const String routeName = '/referralLinkSuccess';

  final String referralLink;
  final String? dealId;

  const ReferralLinkSuccessScreen({
    super.key,
    required this.referralLink,
    this.dealId,
  });

  @override
  State<ReferralLinkSuccessScreen> createState() =>
      _ReferralLinkSuccessScreenState();
}

class _ReferralLinkSuccessScreenState extends State<ReferralLinkSuccessScreen> {
  bool _notifyProfessional = false;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          tr(LanguageKeys.success),
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSuccessHeader(context),
              SizedBox(height: 28.h),
              _buildReferralLinkSection(context),
              SizedBox(height: 24.h),
              _buildShareViaSection(context),
              SizedBox(height: 28.h),
              _buildNotifyProfessionalSection(context),
              if (_notifyProfessional) ...[
                SizedBox(height: 20.h),
                _buildProfessionalDetailsForm(context),
              ],
              SizedBox(height: 32.h),
              _buildDoneButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            color: AppColors.primaryLightPink,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.check,
            size: 44.w,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          tr(LanguageKeys.contractGenerated),
          textAlign: TextAlign.center,
          style: stylePoppins(
            fontWeight: FontWeight.w700,
            color: AppColors.textTitle,
            fontSize: 22.sp,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          tr(LanguageKeys.referralContractReadyDescription),
          textAlign: TextAlign.center,
          style: stylePoppins(
            fontWeight: FontWeight.w400,
            color: AppColors.greyFontColor,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildReferralLinkSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr(LanguageKeys.referallink).toUpperCase(),
          style: stylePoppins(
            fontWeight: FontWeight.w600,
            color: AppColors.greyFontColor,
            fontSize: 12.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: AppColors.textFieldBorderColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.textFieldColor),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                  child: Text(
                    widget.referralLink,
                    style: stylePoppins(
                      fontSize: 13.sp,
                      color: AppColors.textTitle,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: widget.referralLink));
                    Get.snackbar(
                      tr(LanguageKeys.success),
                      tr(LanguageKeys.linkCopied),
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.success300,
                      colorText: Colors.white,
                    );
                  },
                  borderRadius: BorderRadius.circular(8.r),
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: SvgPicture.asset(
                      AppAssets.imgCopy,
                      width: 22.w,
                      height: 22.w,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShareViaSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr(LanguageKeys.shareVia),
          style: stylePoppins(
            fontWeight: FontWeight.w600,
            color: AppColors.textTitle,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 14.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _shareOption(
              context,
              icon: Image.asset(AppAssets.imgWhatsapp, width: 44.w),
              label: tr(LanguageKeys.whatsapp),
              onTap: () => _share(context, 'whatsapp', widget.referralLink),
            ),
            _shareOption(
              context,
              icon: Image.asset(AppAssets.imgMessage, width: 44.w),
              label: tr(LanguageKeys.sms),
              onTap: () => _share(context, 'sms', widget.referralLink),
            ),
            _shareOption(
              context,
              icon: Image.asset(AppAssets.imgFacebook, width: 44.w),
              label: tr(LanguageKeys.facebook),
              onTap: () => _share(context, 'facebook', widget.referralLink),
            ),
            _shareOption(
              context,
              icon: Image.asset(AppAssets.imgEmail, width: 44.w),
              label: tr(LanguageKeys.email),
              onTap: () => _share(context, 'email', widget.referralLink),
            ),
          ],
        ),
      ],
    );
  }

  Widget _shareOption(
    BuildContext context, {
    required Widget icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          icon,
          SizedBox(height: 6.h),
          SizedBox(
            width: 70.w,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: stylePoppins(
                fontSize: 11.sp,
                color: AppColors.greyFontColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _share(
      BuildContext context, String platform, String referralLink) async {
    final encodedLink = Uri.encodeComponent(referralLink);
    String? url;

    switch (platform) {
      case 'whatsapp':
        url = 'https://wa.me/?text=$encodedLink';
        break;
      case 'sms':
        url = 'sms:?body=$encodedLink';
        break;
      case 'email':
        url =
            'mailto:?subject=${Uri.encodeComponent(tr(LanguageKeys.referallink))}&body=$encodedLink';
        break;
      case 'facebook':
        url = 'https://www.facebook.com/sharer/sharer.php?u=$encodedLink';
        break;
      default:
        Share.share(referralLink);
        return;
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Share.share(referralLink);
    }
  }

  Widget _buildNotifyProfessionalSection(BuildContext context) {
    final isNo = !_notifyProfessional;
    final isYes = _notifyProfessional;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr(LanguageKeys.wantToNotifyProfessionalViaEmail),
          style: stylePoppins(
            fontWeight: FontWeight.w600,
            color: AppColors.textTitle,
            fontSize: 15.sp,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          tr(LanguageKeys.weWillSendOfficialInvitation),
          style: stylePoppins(
            fontWeight: FontWeight.w400,
            color: AppColors.greyFontColor,
            fontSize: 13.sp,
          ),
        ),
        SizedBox(height: 14.h),
        Row(
          children: [
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() => _notifyProfessional = false);
                  },
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      color: isNo ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isNo ? AppColors.primary : AppColors.grey300,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      tr(LanguageKeys.noIllShareItMyself),
                      textAlign: TextAlign.center,
                      style: stylePoppins(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: isNo ? Colors.white : AppColors.textTitle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() => _notifyProfessional = true);
                  },
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      color: isYes ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isYes ? AppColors.primary : AppColors.grey300,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      tr(LanguageKeys.yesNotifyThem),
                      textAlign: TextAlign.center,
                      style: stylePoppins(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: isYes ? Colors.white : AppColors.textTitle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfessionalDetailsForm(BuildContext context) {
    final _inputDecoration = (String hint) => InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textTitleHint,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: AppColors.textFieldColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: AppColors.textFieldColor),
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        );

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr(LanguageKeys.firstName),
                      style: stylePoppins(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textTitle,
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    TextField(
                      controller: _firstNameController,
                      decoration: _inputDecoration(tr(LanguageKeys.firstNamePlaceholder)),
                      style: stylePoppins(
                          fontSize: 14.sp, color: AppColors.textTitle),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr(LanguageKeys.lastName),
                      style: stylePoppins(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textTitle,
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    TextField(
                      controller: _lastNameController,
                      decoration: _inputDecoration(tr(LanguageKeys.lastNamePlaceholder)),
                      style: stylePoppins(
                          fontSize: 14.sp, color: AppColors.textTitle),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Text(
            tr(LanguageKeys.emailAddress),
            style: stylePoppins(
              fontWeight: FontWeight.w500,
              color: AppColors.textTitle,
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 6.h),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: _inputDecoration(tr(LanguageKeys.emailPlaceholder)),
            style: stylePoppins(fontSize: 14.sp, color: AppColors.textTitle),
          ),
        ],
      ),
    );
  }

  Widget _buildDoneButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pop(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          elevation: 0,
        ),
        child: Text(
          tr(LanguageKeys.iHaveSharedAndSavedMyLink),
          style: stylePoppins(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
