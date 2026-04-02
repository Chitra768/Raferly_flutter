import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/search_professionals_controller.dart';
import 'package:referaly/languages/languagekeys.dart';
import 'package:referaly/models/model_ongoing_requests.dart';
import 'package:referaly/models/model_finder_suggestions.dart';
import 'package:referaly/resources/app_assets.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/screens/onboarding/complete_profile_screen.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/finder_information_bottom_sheet.dart';

class SearchProfessionalsScreen extends StatelessWidget {
  const SearchProfessionalsScreen({super.key});

  static String pageId = '/searchProfessionals';

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SearchProfessionalsController>();

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Referaly logo
            _buildHeader(),
            // Tab Navigation
            Obx(() => _buildTabNavigation(controller)),
            // Content based on selected tab
            Expanded(
              child: Obx(() {
                if (controller.selectedTab.value == 0) {
                  // Matchmaking Tab
                  return _buildMatchmakingContent(controller);
                } else {
                  // Search Professionals Tab
                  return Column(
                    children: [
                      // Available Credits Banner
                      _buildCreditsBanner(controller),
                      // Keyword Search Bar
                      _buildSearchBar(controller),
                      // Professional List
                      Expanded(
                        child: _buildProfessionalList(controller),
                      ),
                    ],
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 24.sp,
                      color: AppColors.fontBlack,
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      width: 30.w,
                      height: 30.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppAssets.imgHandshake,
                          width: 24.w,
                          height: 24.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                "Referaly",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.fontBlack,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabNavigation(SearchProfessionalsController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTab(
              label: tr(LanguageKeys.matchmaking),
              isSelected: controller.selectedTab.value == 0,
              onTap: () {
                controller.setSelectedTab(0);
              },
            ),
          ),
          Expanded(
            child: _buildTab(
              label: tr(LanguageKeys.searchProfessionals),
              isSelected: controller.selectedTab.value == 1,
              onTap: () {
                controller.setSelectedTab(1);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.fontBlack,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreditsBanner(SearchProfessionalsController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.account_balance_wallet,
            color: Colors.white,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr(LanguageKeys.availableCredits),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "${controller.availableCredits.value}/${controller.totalCredits.value}",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              // Handle buy more credits
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    color: AppColors.primary,
                    size: 18.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    tr(LanguageKeys.buyMore),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(SearchProfessionalsController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextField(
        onChanged: (value) {
          controller.setSearchQuery(value);
        },
        decoration: InputDecoration(
          hintText: tr(LanguageKeys.keywordSearch),
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: AppColors.grey600,
          ),
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.grey600,
            size: 20.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildProfessionalList(SearchProfessionalsController controller) {
    return Obx(() {
      if (controller.isLoadingSuggestions.value) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(24.h),
            child: const CircularProgressIndicator(),
          ),
        );
      }

      if (controller.suggestionsErrorMessage.value.isNotEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(24.h),
            child: Text(
              controller.suggestionsErrorMessage.value,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.fontBlack,
              ),
            ),
          ),
        );
      }

      if (controller.finderSuggestions.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(24.h),
            child: Text(
              tr(LanguageKeys.noDataFounds),
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.grey600,
              ),
            ),
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        itemCount: controller.finderSuggestions.length,
        itemBuilder: (context, index) {
          return _buildProfessionalCard(
              controller.finderSuggestions[index], controller);
        },
      );
    });
  }

  Widget _buildProfessionalCard(FinderSuggestionData professional,
      SearchProfessionalsController controller) {
    final currentUserId = professional.userId; // Capture userId for closure
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.grey200,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.r),
                  child: professional.userImage != null &&
                          professional.userImage!.isNotEmpty
                      ? Image.network(
                          professional.userImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                            AppAssets.imgDefaultPerson,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          AppAssets.imgDefaultPerson,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name with dots and lock icon - all left-aligned inline
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          professional.userName ?? '',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.fontBlack,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.lock,
                          size: 16.sp,
                          color: AppColors.grey600,
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    // Job - left-aligned
                    if (professional.job != null &&
                        professional.job!.isNotEmpty)
                      Text(
                        professional.job!,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.fontBlack,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    SizedBox(height: 4.h),
                    // Company with dots before and lock icon - all left-aligned inline
                    if (professional.companyName != null &&
                        professional.companyName!.isNotEmpty)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            professional.companyName!,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.grey600,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Icon(
                            Icons.lock,
                            size: 14.sp,
                            color: AppColors.grey600,
                          ),
                        ],
                      ),
                    SizedBox(height: 12.h),
                    // Description - left-aligned with name, not justified
                    if (professional.city != null &&
                        professional.city!.isNotEmpty)
                      Text(
                        professional.city!,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.grey600,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                        textDirection: TextDirection.ltr,
                      ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // View Finder Information Button
          if (professional.hasFinderDetail == true)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // Handle view finder information
                  showModalBottomSheet(
                    context: Get.context!,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    barrierColor: Colors.black54,
                    isDismissible: true,
                    enableDrag: true,
                    builder: (context) => FinderInformationBottomSheet(
                      userId: professional.userId ?? 0,
                    ),
                  );
                },
                icon: Icon(
                  Icons.remove_red_eye,
                  size: 18.sp,
                  color: AppColors.grey700,
                ),
                label: Text(
                  tr(LanguageKeys.viewFinderInformation),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey700,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  side: BorderSide(color: AppColors.grey300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ),
          if (professional.hasFinderDetail == true) SizedBox(height: 8.h),
          // Ask for Networking Button
          SizedBox(
            width: double.infinity,
            child: Obx(() => ElevatedButton(
                  onPressed: controller.askingForNetworkingUserId.value != null
                      ? null
                      : () {
                          if (currentUserId != null) {
                            controller.askForNetworking(userId: currentUserId);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding:
                        EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: (controller.askingForNetworkingUserId.value != null &&
                          controller.askingForNetworkingUserId.value ==
                              currentUserId)
                      ? SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              AppAssets.imgHandshake,
                              width: 18.w,
                              height: 18.h,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Flexible(
                              child: Text(
                                tr(LanguageKeys.askForNetworking),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            // Credit container inside button
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.primaryLightPink.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                "1 ${tr(LanguageKeys.credit)}",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchmakingContent(SearchProfessionalsController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(24.h),
            child: const CircularProgressIndicator(),
          ),
        );
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.all(24.h),
            child: Text(
              controller.errorMessage.value,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.fontBlack,
              ),
            ),
          ),
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12.h),
            // Edit Information Button
            _buildEditInformationButton(),
            SizedBox(height: 24.h),
            // Ongoing Requests
            if (controller.ongoingRequests.isNotEmpty)
              ...controller.ongoingRequests
                  .map((request) =>
                      _buildOngoingRequestCard(request, controller))
                  .toList(),
            if (controller.ongoingRequests.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(24.h),
                  child: Text(
                    tr(LanguageKeys.noDataFound),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.grey600,
                    ),
                  ),
                ),
              ),
            SizedBox(height: 24.h),
          ],
        ),
      );
    });
  }

  Widget _buildEditInformationButton() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(CompleteProfileScreen.pageId);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: AppColors.primaryLightPink,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.edit,
              color: AppColors.primary,
              size: 18.sp,
            ),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                tr(LanguageKeys.editMyFinderInformation),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOngoingRequestCard(
      OngoingRequestData request, SearchProfessionalsController controller) {
    final userData = request.userData;
    final bool isPending = request.status == "Pending";
    final bool showAcceptReject = isPending && (request.needToRespond == true);
    final bool isPendingAwaitingResponse =
        isPending && (request.needToRespond == false);
    final statusColor = _getStatusColor(request.status);
    final borderColor = _getBorderColor(request.status);
    final contactBgColor = _getContactBgColor(request.status);
    final bool showDeleteNetworkingMenu = isPendingAwaitingResponse;
    final bool isDeletingThisRequest =
        controller.deletingNetworkingRequestId.value == request.id;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isPendingAwaitingResponse ? AppColors.Darkorange : borderColor,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Indicator Badge - Show for pending awaiting response
          if (isPendingAwaitingResponse) ...[
            Row(
              children: [
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.Darkorange,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  tr(LanguageKeys.pendingApproval),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.Darkorange,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
          ] else if (!showAcceptReject) ...[
            // Status Indicator Badge (only show when not Pending awaiting response and not showing Accept/Reject)
            Row(
              children: [
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: statusColor,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  request.status == 'Pending'
                      ? tr(LanguageKeys.pending)
                      : request.status == 'Accepted'
                          ? tr(LanguageKeys.connected)
                          : request.status == 'Rejected'
                              ? "Rejected"
                              : '',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.grey200,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.r),
                  child: userData?.avatarUrl != null &&
                          userData!.avatarUrl!.isNotEmpty
                      ? Image.network(
                          userData.avatarUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                            AppAssets.imgDefaultPerson,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          AppAssets.imgDefaultPerson,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userData?.userName ?? '',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.fontBlack,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      userData?.companyName ?? '',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (userData?.job != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        userData!.job!,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.grey600,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                    if (userData?.city != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        userData!.city!,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.grey600,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (showDeleteNetworkingMenu)
                PopupMenuButton<String>(
                  enabled: !isDeletingThisRequest && request.id != null,
                  tooltip: tr(LanguageKeys.moreOptions),
                  icon: isDeletingThisRequest
                      ? SizedBox(
                          width: 18.w,
                          height: 18.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.grey700),
                          ),
                        )
                      : Icon(
                          Icons.more_vert,
                          size: 22.sp,
                          color: AppColors.grey700,
                        ),
                  onSelected: (value) {
                    if (value == 'delete_networking_request' &&
                        request.id != null) {
                      controller.deleteNetworkingRequest(
                        requestId: request.id!,
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem<String>(
                      value: 'delete_networking_request',
                      child: Text(
                        tr(LanguageKeys.deleteNetworkingRequest),
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.fontBlack,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(height: 16.h),
          // View Finder Information Button - Show for pending awaiting response
          if (isPendingAwaitingResponse) ...[
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: Get.context!,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    barrierColor: Colors.black54,
                    isDismissible: true,
                    enableDrag: true,
                    builder: (context) => FinderInformationBottomSheet(
                      userId: userData?.userId ?? 0,
                    ),
                  );
                },
                icon: Icon(
                  Icons.remove_red_eye,
                  size: 18.sp,
                  color: AppColors.grey700,
                ),
                label: Text(
                  tr(LanguageKeys.viewFinderInformation),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey700,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  side: BorderSide(color: AppColors.grey300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            // Nested card with awaiting response message
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.lightorange,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppColors.Darkorange,
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 18.sp,
                        color: AppColors.Darkorange,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          tr(LanguageKeys.awaitingProfessionalResponse),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.Darkorange,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    tr(LanguageKeys.pendingApprovalInstruction),
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.fontBlack,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ] else if (showAcceptReject) ...[
            // Show Accept/Reject buttons only when status is "Pending" and need_to_respond is true
            SizedBox(height: 12.h),
            // Accept/Refuse Buttons
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: controller.isRespondingToRequest.value
                          ? null
                          : () {
                              controller.respondToFinderRequest(
                                requestId: request.id ?? 0,
                                status: 1, // 1 for accept
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.circleGreen,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: controller.isRespondingToRequest.value
                          ? SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.check,
                                          size: 18.sp,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          tr(LanguageKeys.acceptNetworking)
                                              .split(' ')[0],
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      tr(LanguageKeys.acceptNetworking)
                                          .split(' ')
                                          .skip(1)
                                          .join(' '),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: controller.isRespondingToRequest.value
                          ? null
                          : () {
                              controller.respondToFinderRequest(
                                requestId: request.id ?? 0,
                                status: 0, // 0 for reject
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.pdfBg,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: controller.isRespondingToRequest.value
                          ? SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.close,
                                          size: 18.sp,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          tr(LanguageKeys.refuseNetworking)
                                              .split(' ')[0],
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      tr(LanguageKeys.refuseNetworking)
                                          .split(' ')
                                          .skip(1)
                                          .join(' '),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            // Info Message
            Container(
              padding: EdgeInsets.all(12.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.blueColor2.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppColors.blueColor2.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_rounded,
                    size: 18.sp,
                    color: AppColors.blueColor2,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      tr(LanguageKeys.acceptConnectionInfo),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.blueColor2,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            // Other UI - Show Contact Information when status is not Pending
            SizedBox(height: 16.h),
            // Contact Information Section
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: contactBgColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.folder_outlined,
                        size: 20.sp,
                        color: statusColor,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        tr(LanguageKeys.contactInformation),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  // Email Row
                  if (userData?.email != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon in rounded square container
                        Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.email_outlined,
                            size: 20.sp,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        // Label and Value Column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tr(LanguageKeys.email),
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.grey600,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                userData!.email!,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.fontBlack,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  if (userData?.email != null && userData?.phoneNumber != null)
                    SizedBox(height: 16.h),
                  // Phone Row
                  if (userData?.phoneNumber != null)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon in rounded square container
                        Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.phone_outlined,
                            size: 20.sp,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        // Label and Value Column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tr(LanguageKeys.phone),
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.grey600,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                userData!.phoneNumber!,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.fontBlack,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'accepted':
        return AppColors.circleGreen;
      case 'rejected':
        return AppColors.pdfBg;
      case 'pending':
        return AppColors.Darkorange;
      default:
        return AppColors.grey600;
    }
  }

  Color _getBorderColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'accepted':
        return AppColors.success300;
      case 'rejected':
        return AppColors.pdfBg;
      case 'pending':
        return AppColors.Darkorange; // Orange border for pending
      default:
        return Colors.transparent;
    }
  }

  Color _getContactBgColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'accepted':
        return const Color(0xFFE8F8E8); // Light green
      case 'rejected':
        return const Color(0xFFFFEBEE); // Light red/pink
      default:
        return const Color(0xFFE8F8E8); // Default light green
    }
  }
}
