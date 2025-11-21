import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'app_preference.dart';

/// Detects when the OS-level “clear cache” action wiped the temporary
/// directory so we can invalidate sensitive session data proactively.
class CacheIntegrityGuard {
  CacheIntegrityGuard._();

  static const _sentinelFileName = '.referaly_cache_sentinel';

  /// Returns true if the cache directory appears to have been cleared.
  static Future<bool> wasCacheCleared() async {
    final tempDir = await getTemporaryDirectory();
    final sentinelFile = File('${tempDir.path}/$_sentinelFileName');
    final storedToken =
        AppPreference.readString(AppPreference.cacheSentinelToken);

    if (storedToken == null || storedToken.isEmpty) {
      final token = _generateToken();
      await _persistSentinel(sentinelFile, token);
      await AppPreference.writeString(
          AppPreference.cacheSentinelToken, token);
      return false;
    }

    final exists = await sentinelFile.exists();
    if (exists) {
      return false;
    }

    // Cache directory was cleared; recreate sentinel for future runs.
    await _persistSentinel(sentinelFile, storedToken);
    return true;
  }

  static Future<void> _persistSentinel(File file, String token) async {
    try {
      if (!await file.parent.exists()) {
        await file.parent.create(recursive: true);
      }
      await file.writeAsString(token, flush: true);
    } catch (_) {
      // If writing fails, we silently ignore; worst case the next run
      // will also detect cache clearance.
    }
  }

  static String _generateToken() {
    final now = DateTime.now().microsecondsSinceEpoch;
    final random = now.hashCode ^ Platform.operatingSystem.hashCode;
    return '$now-$random';
  }
}

