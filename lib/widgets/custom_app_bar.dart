// // App Bar
//
// import 'package:flutter/material.dart';
//
//
// class CustomAppBar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Image.asset(AppAssets.imgLogo),
//              Row(
//               children: [
//                 _buildNotificationIcon(7), // Notification Bell with Badge
//                 SizedBox(width: 20),
//                 SvgPicture.asset(AppAssets.imgSearch, color:AppColors.buttonBlue), // Search Icon
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
//   Widget _buildNotificationIcon(int count) {
//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         SvgPicture.asset(AppAssets.imgNotification, color:AppColors.buttonBlue),
//         if (count > 0)
//           Positioned(
//             right: -5,
//             top: -12,
//             child: Container(
//               padding: EdgeInsets.all(6),
//               decoration: BoxDecoration(
//                 color:AppColors.indicatorColor, // Translucent Yellow
//                 shape: BoxShape.circle,
//               ),
//               child: Text(
//                 count.toString(),
//                 style: TextStyle(
//                   color:AppColors.buttonBlue,
//                   fontSize: 10,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }