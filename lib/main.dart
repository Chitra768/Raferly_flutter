import 'dart:async';
import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:referaly/get/screens.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/screens/splash.dart' show SplashScreen;
import 'package:referaly/controller/language_controller.dart';
import 'package:referaly/languages/en.dart';
import 'package:referaly/languages/es.dart';
import 'package:referaly/languages/fr.dart';

import 'fcm/push_notification_service.dart';
import 'get/get_routes.dart';
import 'helpers/branch_deep_link/branch_deep_link_controller.dart';
import 'resources/app_colors.dart';

// Custom Translations class
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': en,
        'es': es,
        'fr': fr,
      };
}

Future<void> main() async {
  // Ensure Flutter engine and plugin services are initialized
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    await AppPreference.init(); // Initialize preferences

    // // Set first time flag only if it's not already set
    // if (AppPreference.readInt(AppPreference.isFirstTime) == 0) {
    //   await AppPreference.writeInt(AppPreference.isFirstTime, 1);
    // }

    final pushService = PushNotificationService();
    await pushService.initialize();

    // iOS-specific initialization with timeout
    if (Platform.isIOS) {
      // Initialize Branch with timeout for iOS
      try {
        await FlutterBranchSdk.init(
          enableLogging: true,
          branchAttributionLevel: BranchAttributionLevel.FULL,
        ).timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            debugPrint('Branch SDK initialization timeout on iOS - proceeding');
            return;
          },
        );

        FlutterBranchSdk.setConsumerProtectionAttributionLevel(
          BranchAttributionLevel.FULL,
        );
      } catch (e) {
        debugPrint('Branch SDK initialization error on iOS: $e - proceeding');
      }
    } else {
      // Android initialization
      await FlutterBranchSdk.init(
        enableLogging: true,
        branchAttributionLevel: BranchAttributionLevel.FULL,
      );

      FlutterBranchSdk.setConsumerProtectionAttributionLevel(
        BranchAttributionLevel.FULL,
      );
    }

    // Request notification permissions and get FCM token with timeout
    try {
      NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        String? token = await FirebaseMessaging.instance.getToken().timeout(
          const Duration(seconds: 3),
          onTimeout: () {
            debugPrint('FCM token retrieval timeout - proceeding');
            return null;
          },
        );
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
  } catch (e) {
    debugPrint("Error during app initialization: $e");
    // Even if initialization fails, try to run the app
    runApp(const MyApp());
  }
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

    // iOS-specific launch screen optimization
    if (Platform.isIOS) {
      // Ensure smooth transition from iOS launch screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Force a frame update to ensure smooth transition
        setState(() {});
      });
    }
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
      child: GetBuilder<LanguageController>(
        init: LanguageController(),
        builder: (languageController) => GetMaterialApp(
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
          // Internationalization configuration
          locale: Locale(languageController.currentLanguage),
          fallbackLocale: const Locale('en', 'US'),
          translations: AppTranslations(),
          // home: ScreenProfileType(),
          home: SplashScreen(),
          getPages: AppPages.pages,
          color: AppColors.whiteColor,
          initialBinding: BindingsBuilder(() {
            Get.put(LanguageController());
          }),
        ),
      ),
    );
  }
}
