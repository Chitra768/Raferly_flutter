import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'lib/social_logins/google_sign_in_service.dart';

/// Test script for Facebook login debugging
/// Run this in your app to test Facebook login and diagnose issues
class FacebookLoginTest {
  
  /// Run comprehensive Facebook login test
  static Future<void> runTest() async {
    debugPrint("🚀 Starting Facebook Login Test");
    debugPrint("=================================");
    
    try {
      // Test 1: Check configuration
      await GoogleSignInService.generateFacebookHashKey();
      
      // Test 2: Run comprehensive test
      await GoogleSignInService.testFacebookLogin();
      
    } catch (e) {
      debugPrint("❌ Test failed with error: $e");
    }
  }
  
  /// Quick test for (#100) error
  static Future<void> testForError100() async {
    debugPrint("🔍 Testing specifically for (#100) error");
    
    try {
      final user = await GoogleSignInService.loginWithFacebook();
      
      if (user != null) {
        debugPrint("✅ SUCCESS: No (#100) error");
        await GoogleSignInService.logoutFacebook();
      } else {
        debugPrint("❌ FAILED: Likely (#100) error");
        debugPrint("📋 Solutions:");
        debugPrint("   1. Use a test user account");
        debugPrint("   2. Check Facebook app settings");
        debugPrint("   3. Verify app is in correct mode");
      }
    } catch (e) {
      debugPrint("❌ ERROR: $e");
      if (e.toString().contains('(#100)')) {
        debugPrint("🎯 CONFIRMED: (#100) error detected");
        debugPrint("📋 Immediate fixes:");
        debugPrint("   - Add yourself as test user in Facebook app");
        debugPrint("   - Use test user account to login");
        debugPrint("   - Check Facebook app configuration");
      }
    }
  }
}

/// Usage in your app:
/// 
/// 1. Add this to any screen or button:
/// ```dart
/// ElevatedButton(
///   onPressed: () => FacebookLoginTest.runTest(),
///   child: Text('Test Facebook Login'),
/// )
/// ```
/// 
/// 2. Or call directly:
/// ```dart
/// await FacebookLoginTest.testForError100();
/// ```
/// 
/// 3. Check console logs for detailed debugging information 