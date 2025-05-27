import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../resources/app_colors.dart';
import '../resources/app_helper.dart';
import '../resources/app_preference.dart';

// Author : Ketan Ramani
// Use : Push Notification (Android & iOS)

class PushNotificationService {
  final FirebaseMessaging _fcm;
  PushNotificationService(this._fcm);

  Future initialise(BuildContext context) async {
    // Initialize the Firebase app
    // void main() async {
    //   WidgetsFlutterBinding.ensureInitialized();
    //   await Firebase.initializeApp();
    // }

    // For Apple notifications
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    if (Platform.isIOS) {
      // For iOS, request permissions
      final result = await _fcm.requestPermission(
        alert: true,
        badge: true,
        provisional: true,
        sound: true,
      );
      if (result.authorizationStatus == AuthorizationStatus.authorized) {
        AppHelper.showLog('FCM: iOS User have granted permission');
        // For handling the received notifications
        await setupListenerCallbacks();
      } else {
        AppHelper.showLog(
            'FCM: iOS User have declined or not accepted permission');
      }
    }

    await requestNotificationPermission();
    await setupListenerCallbacks();

    // If you want to test the push notification locally,
    // you need to get the token and input to the Firebase console
    // https://console.firebase.google.com/project/YOUR_PROJECT_ID/notification/compose
    String? token = await _fcm.getToken();
    AppHelper.showLog("FCM: FirebaseMessaging token: $token");

    // final preference = await SharedPreferences.getInstance();
    // preference.setString('fcmToken', token!);
    await AppPreference.writeString(AppPreference.fcmToken, token!);

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        AppHelper.showLog('FCM: getInitialMessage ${message.data.toString()}');
        redirectScreen(message.data);
      }
    });

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await initLocalNotification();
  }

  static Future<void> setupListenerCallbacks() async {
    //Triggered if a message is received while the app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification!;
      AndroidNotification? android = message.notification?.android;
      // ignore: unnecessary_null_comparison
      if (notification != null && android != null) {
        AppHelper.showLog('FCM: onMessage ${message.data.toString()}');
      }
      if (Platform.isAndroid) {
        showNotification(message);
      }
    });

    //Triggered if a message is received while the app is in background and notification clicked
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      AppHelper.showLog('FCM: onMessageOpenedApp ${message.data.toString()}');
      redirectScreen(message.data);
    });
  }
}

Future initLocalNotification() async {
  var initializationSettingsAndroid =
  const AndroidInitializationSettings('app_icon');

  var initializationSettingsIOS = const DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
    notificationCategories: [],
  );

  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) {
      AppHelper.showLog(
          'FCM: onDidReceiveNotificationResponse ${jsonDecode(notificationResponse.payload!)}');
      _selectNotification(notificationResponse.payload);
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );
}

void notificationTapBackground(NotificationResponse notificationResponse) {
  _selectNotification(notificationResponse.payload);
}

Future _onDidReceiveLocalNotification(
    int? id, String? title, String? body, String? payload) async {
  AppHelper.showLog(
      'FCM: _onDidReceiveLocalNotification ${jsonDecode(payload!)}');
  await handleNotificationClick(jsonDecode(payload));
}

Future _selectNotification(String? payload) async {
  AppHelper.showLog('FCM: _selectNotification ${jsonDecode(payload!)}');
  await handleNotificationClick(jsonDecode(payload));
}

handleNotificationClick(dynamic notificationData) {
  AppHelper.showLog('FCM: Local Notification Data: $notificationData');
  redirectScreen(notificationData);
}

AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
);

// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<Uint8List> _getByteArrayFromUrl(String url) async {
  final http.Response response = await http.get(Uri.parse(url));
  return response.bodyBytes;
}

showNotification(RemoteMessage remote) async {
  Map<String, dynamic> notificationData = remote.data;
  AppHelper.showLog(
      'FCM: showNotification Data: ${notificationData.toString()}');
  Map<dynamic, dynamic> map = jsonDecode(notificationData['data']);

  String title = remote.notification?.title ?? "",
      message = remote.notification?.body ?? "";

  BigPictureStyleInformation? bigPictureStyleInformation;
  if (map.containsKey('image') && map['image'].toString().isNotEmpty) {
    final ByteArrayAndroidBitmap bigPicture = ByteArrayAndroidBitmap(
        await _getByteArrayFromUrl(map['image'].toString()));

    bigPictureStyleInformation = BigPictureStyleInformation(
      bigPicture,
      contentTitle: title,
      htmlFormatContentTitle: true,
      summaryText: message,
      htmlFormatSummaryText: true,
    );
  }

  await flutterLocalNotificationsPlugin.show(
    notificationData.hashCode,
    title,
    message,
    NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        icon: 'app_icon',
        color: AppColors.primary,
        styleInformation:
        (map.containsKey('image') && map['image'].toString().isNotEmpty)
            ? bigPictureStyleInformation
            : null,
      ),
      iOS: const DarwinNotificationDetails(),
      macOS: const DarwinNotificationDetails(),
    ),
    payload: jsonEncode(notificationData),
  );
}

Future<void> requestNotificationPermission() async {
  if (Platform.isIOS || Platform.isMacOS) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
      critical: true,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
      critical: true,
    );
  } else if (Platform.isAndroid) {
    // Request permission (API 33+)
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    // final bool? granted = await androidImplementation?.requestPermission();
    // AppHelper.showLog('FCM: User local permission result $granted');
  }
}

void redirectScreen(dynamic data) {
  //here dynamic will be data of RemoteMessage
  AppHelper.showLog('FCM: redirectScreen Data: ${data.toString()}');
  // String type = data['order_type'].toString();
  // AppHelper.showLog('FCM: Type: $type');
  // if (type.trim() == '0') {
  //   Map<dynamic, dynamic> map = jsonDecode(data['data']);
  //   SchedulerBinding.instance.addPostFrameCallback((_) {
  //     // Customer Order
  //     Get.toNamed(
  //       CustomerOrderView.pageId,
  //       arguments: [
  //         {
  //           'id': map['order_id'].toString(),
  //           'orderType': '0',
  //           'from': NotificationAction.pushNotification,
  //           'isRead': map['is_read'].toString(),
  //           'notificationId': map['notification_id'].toString(),
  //         },
  //       ],
  //     );
  //   });
  // }

}
