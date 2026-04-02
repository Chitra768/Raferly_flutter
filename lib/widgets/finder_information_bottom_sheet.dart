import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/apis/api_result.dart';
import 'package:referaly/apis/rest_auth.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_finder_basic_details.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/text_style.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/network_circle_avatar.dart';

class FinderInformationBottomSheet extends StatefulWidget {
  final int userId;

  const FinderInformationBottomSheet({
    super.key,
    required this.userId,
  });

  @override
  State<FinderInformationBottomSheet> createState() =>
      _FinderInformationBottomSheetState();
}

class _FinderInformationBottomSheetState
    extends State<FinderInformationBottomSheet> {
  bool _isLoading = true;
  FinderBasicDetailsData? _finderData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchFinderDetails();
  }

  Future<void> _fetchFinderDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await RESTAuth.getFinderBasicDetails(
      userId: widget.userId,
    );

    if (result is ApiSuccess<ModelFinderBasicDetails>) {
      setState(() {
        _finderData = result.data.data;
        _isLoading = false;
      });
    } else if (result is ApiFailure) {
      setState(() {
        _errorMessage = result.error.message ?? tr(LanguageKeys.somethingWent);
        _isLoading = false;
      });
    }
  }

  String _buildLocationWorkPreferenceText() {
    final finderDetail = _finderData?.finderDetail;
    if (finderDetail == null) {
      return tr(LanguageKeys.notSpecified);
    }

    final List<String> parts = [];

    if (finderDetail.city != null && finderDetail.city!.isNotEmpty) {
      parts.add(finderDetail.city!);
    }

    if (finderDetail.workPreferences != null &&
        finderDetail.workPreferences!.isNotEmpty) {
      parts.add(finderDetail.workPreferences!);
    }

    if (parts.isEmpty) {
      return tr(LanguageKeys.notSpecified);
    }

    return parts.join(' • ');
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Container(
        // height: AppHelper.getScreenHeight(context) * 0.19,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ------------------ APP BAR ------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      tr(LanguageKeys.finderInformationTitle),
                      style: stylePoppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(Icons.close, size: 20),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 0.5),

            // ------------------ BODY ------------------
            Flexible(
              child: _isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _errorMessage != null
                      ? Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: Colors.red.shade300,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: stylePoppins(
                                    fontSize: 16,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _fetchFinderDetails,
                                  child: Text(tr(LanguageKeys.pleaseTry)),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // ---------- USER INFO ----------
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18.0),
                                child: ListTile(
                                  leading: NetworkCircleAvatar(
                                    imageUrl: _finderData?.avatarUrl ?? '',
                                    radius: 40,
                                  ),
                                  title: Text(
                                    _finderData?.userName ?? 'N/A',
                                    style: stylePoppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    _finderData?.companyName ?? 'N/A',
                                    style: stylePoppins(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              const Divider(
                                height: 1,
                                thickness: 0.5,
                              ),

                              // ---------- ADDITIONAL INFO ----------
                              if (_finderData?.job != null &&
                                  _finderData!.job!.isNotEmpty)
                                InfoTile(
                                  label: tr(LanguageKeys.job),
                                  value: _finderData!.job!,
                                ),
                              if (_finderData?.city != null &&
                                  _finderData!.city!.isNotEmpty)
                                InfoTile(
                                  label: tr(LanguageKeys.city),
                                  value: _finderData!.city!,
                                ),

                              if (_finderData?.companyDescription != null &&
                                  _finderData!.companyDescription!.isNotEmpty)
                                InfoTile(
                                  label: tr(LanguageKeys.companyDescription),
                                  value: _finderData!.companyDescription!,
                                ),

                              // ---------- FAQ LIST ----------
                              FAQTile(
                                question: tr(LanguageKeys
                                    .faqQuestionWhatTypeOfProfessionals),
                                answer: _finderData?.finderDetail
                                                ?.professionalIRefer !=
                                            null &&
                                        _finderData!.finderDetail!
                                            .professionalIRefer!.isNotEmpty
                                    ? _finderData!
                                        .finderDetail!.professionalIRefer!
                                        .map((e) => e.name)
                                        .whereType<String>()
                                        .join(', ')
                                    : tr(LanguageKeys.notSpecified),
                              ),
                              FAQTile(
                                question:
                                    tr(LanguageKeys.faqQuestionWhoCanReferYou),
                                answer: _finderData
                                                ?.finderDetail?.whoCanReferMe !=
                                            null &&
                                        _finderData!.finderDetail!
                                            .whoCanReferMe!.isNotEmpty
                                    ? _finderData!.finderDetail!.whoCanReferMe!
                                        .map((e) => e.name)
                                        .whereType<String>()
                                        .join(', ')
                                    : tr(LanguageKeys.notSpecified),
                              ),
                              FAQTile(
                                question: tr(LanguageKeys
                                    .faqQuestionDoYouShareCommissions),
                                answer: _finderData
                                            ?.finderDetail?.shareCommissions !=
                                        null
                                    ? (_finderData!.finderDetail!
                                                .shareCommissions ==
                                            1
                                        ? tr(LanguageKeys.commissionSharedYes)
                                        : tr(LanguageKeys.commissionSharedNo))
                                    : tr(LanguageKeys.notSpecified),
                              ),
                              FAQTile(
                                question: tr(LanguageKeys
                                    .faqQuestionLocationWorkPreference),
                                answer: _buildLocationWorkPreferenceText(),
                              ),
                              const SizedBox(
                                height: 16,
                              )
                            ],
                          ),
                        ),
            ),

            // ------------------ BOTTOM BUTTON ------------------
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                  )
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF963ADD),
                          Color(0xFFB466E8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // SVG Icon
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: SvgPicture.asset(
                              AppAssets.imgHandshake, // your SVG path
                              height: 30,
                              width: 30,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),

                          // Button Text
                          Text(
                            tr(LanguageKeys.connectNow),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// ------------------ INFO TILE ------------------
//
class InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const InfoTile({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.primary,
            radius: 12,
            child: Icon(
              Icons.info_outline,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//
// ------------------ FAQ TILE ------------------
//
class FAQTile extends StatelessWidget {
  final String question;
  final String answer;

  const FAQTile({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.primary,
            radius: 12,
            child: Icon(
              Icons.question_mark,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  answer,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
