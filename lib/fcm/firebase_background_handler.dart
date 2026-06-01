import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:referaly/resources/app_log.dart';

/// Top-level handler for FCM messages when the app is in the background/terminated.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  AppLog.d('FCM: background message => ${message.messageId}');
}
