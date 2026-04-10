import 'package:referaly/models/model_profile.dart';
import 'package:referaly/resources/app_preference.dart';

class PremiumHelper {
  PremiumHelper._();

  /// Project rule: treat user as premium when is_paid != 0.
  static bool isPremiumFromInt(int? isPaid) => (isPaid ?? 0) != 0;

  static bool isPremiumUser(Data? profileData) {
    if (profileData != null) {
      return isPremiumFromInt(profileData.isPaid);
    }
    final v = AppPreference.readString(AppPreference.isPaid);
    return v != null && v.isNotEmpty && v != '0';
  }
}

