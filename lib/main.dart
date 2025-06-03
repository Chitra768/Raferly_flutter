import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:referaly/get/screens.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/screens/home/screen_main.dart';
import 'package:referaly/screens/splash.dart' show SplashScreen;

import 'get/get_routes.dart';
import 'helpers/branch_deep_link/branch_deep_link_controller.dart';
import 'resources/app_colors.dart';

Future<void> main() async {
  // Ensure Flutter engine and plugin services are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // branch io
  await FlutterBranchSdk.init(
    enableLogging: true,
    branchAttributionLevel: BranchAttributionLevel.FULL,
  );
  //FlutterBranchSdk.validateSDKIntegration();
  FlutterBranchSdk.setConsumerProtectionAttributionLevel(
    BranchAttributionLevel.FULL,
  );

  // Initialize preferences
  await AppPreference.init();

  // Check if first time
  if (!AppPreference.preferences.containsKey(AppPreference.isFirstTime)) {
    await AppPreference.writeInt(
        AppPreference.isFirstTime, 0); // 0 = first time
  }

  // Request notification permissions and get FCM token
  try {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await AppPreference.writeString(AppPreference.fcmToken, token);
        debugPrint("FCM Token initialized: $token");
      }
    }
  } catch (e) {
    debugPrint("Error initializing FCM: $e");
  }

  // Optional: Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final BranchDeepLinkController _branchController;
  StreamSubscription<Map<dynamic, dynamic>>? _branchSubscription;

  @override
  void initState() {
    super.initState();
    _branchController = Get.put(BranchDeepLinkController());
    _listenToBranchDeepLinks();
  }

  void _listenToBranchDeepLinks() {
    _branchSubscription = FlutterBranchSdk.listSession().listen(
      (data) {
        debugPrint(' DeepLink Data: ${jsonEncode(data)}');

        if (data['+clicked_branch_link'] == true) {
          _branchController.updateBranchData(data);

          debugPrint('-> Branch Link Clicked');
          debugPrint('-> Referring link: ${data['~referring_link']}');
          debugPrint('-> deeplink_path: ${data['deeplink_path']}');

          final sendLeadOut = data['send_lead_out'];
          final dealId = data['deal_id'];

          debugPrint('-> sendLeadOut: $sendLeadOut');
          debugPrint('-> dealId: $dealId}');

          // if (sendLeadOut == 0 && dealId != null && AppPreference.accessToken.isNotEmpty) {
          //   debugPrint('------> Navigating with lead out : $sendLeadOut');
          //   // Navigate to the invite deal screen with the given deal ID
          //   //Get.offAllNamed('/invite-deal/$dealId');
          //   Get.offNamed(ScreenMain.pageId, arguments: {
          //     'dealId': dealId.toString(),
          //   });
          // } else {
          //   // Navigate to ScreenLogin if the condition isn't met
          //   Get.offAllNamed(ScreenLogin.pageId);
          // }
        }
      },
      onError: (error) => debugPrint(' Branch SDK error: $error'),
    );
  }

  @override
  void dispose() {
    _branchSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X reference size
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
        title: 'REFERALY',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Poppins',
          useMaterial3: true,
          primaryColor: AppColors.primaryLightPink,
          inputDecorationTheme: InputDecorationTheme(
            errorStyle: TextStyle(color: AppColors.redColor),
          ),
        ),
        home: SplashScreen(),
        getPages: AppPages.pages,
        color: AppColors.whiteColor,
      ),
    );
  }
}
