import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:referaly/controller/controller_main_professional.dart';
import 'package:referaly/get/screens.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/screens/auth/screen_profile_type.dart';
import 'package:referaly/screens/home/screen_main.dart';
import 'package:referaly/screens/splash.dart' show SplashScreen;
import 'package:referaly/controller/language_controller.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/custom_toast_msg.dart';

import 'fcm/push_notification_service.dart';
import 'get/get_routes.dart';
import 'helpers/branch_deep_link/branch_deep_link_controller.dart';
import 'languages/languagekeys.dart';
import 'resources/app_colors.dart';

Future<void> main() async {
  // Ensure Flutter engine and plugin services are initialized
  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp();
  await AppPreference.init(); // Initialize preferences

  // Set first time flag only if it's not already set
  if (AppPreference.readInt(AppPreference.isFirstTime) == 0) {
    await AppPreference.writeInt(AppPreference.isFirstTime, 0);
  }

  final pushService = PushNotificationService();
  await pushService.initialize();
  // branch io
  await FlutterBranchSdk.init(
    enableLogging: true,
    branchAttributionLevel: BranchAttributionLevel.FULL,
  );
  //FlutterBranchSdk.validateSDKIntegration();
  FlutterBranchSdk.setConsumerProtectionAttributionLevel(
    BranchAttributionLevel.FULL,
  );

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
  String? _lastHandledBranchViewId;

  @override
  void initState() {
    super.initState();
    _branchController = Get.put(BranchDeepLinkController());

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
        // home: ScreenProfileType(),
        home: SplashScreen(),
        getPages: AppPages.pages,
        color: AppColors.whiteColor,
        initialBinding: BindingsBuilder(() {
          Get.put(LanguageController());
        }),
      ),
    );
  }
}
