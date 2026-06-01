import 'dart:convert';

import 'package:referaly/fcm/notification_router.dart';
import 'package:referaly/resources/app_preference.dart';

/// Persists FCM tap payload until the user is logged in and [ScreenMain] is ready.
class PendingNotificationStore {
  PendingNotificationStore._();

  static const String _key = 'pending_notification_payload';

  static Future<void> save(Map<String, dynamic> data) async {
    await AppPreference.writeString(_key, jsonEncode(data));
  }

  static Map<String, dynamic>? read() {
    final raw = AppPreference.readString(_key);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}
    return null;
  }

  static Future<void> clear() async {
    await AppPreference.writeString(_key, '');
  }

  /// Called after login when home is ready.
  static Future<void> consumeAfterLogin() async {
    final data = read();
    if (data == null || data.isEmpty) return;
    await clear();
    await Future.delayed(const Duration(milliseconds: 800));
    NotificationRouter.handle(data, fromColdStart: true);
  }
}
