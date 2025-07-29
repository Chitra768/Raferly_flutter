# Google Sign-In iOS Troubleshooting Guide

## Issues Fixed

### 1. AppDelegate.swift Updates
- ✅ Added `import GoogleSignIn`
- ✅ Added Google Sign-In URL handling in `application(_:open:options:)`
- ✅ Proper URL scheme handling for Google Sign-In

### 2. Google Sign-In Service Improvements
- ✅ Added detailed logging for debugging
- ✅ Added iOS-specific client ID configuration
- ✅ Improved error handling with specific error messages
- ✅ Added profile scope for better user data access
- ✅ Added proper session management

### 3. Configuration Verification

#### Info.plist Configuration ✅
Your `Info.plist` has the correct URL scheme:
```xml
<key>CFBundleURLSchemes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>com.googleusercontent.apps.985082913550-7fje7ug1b6t9j8d9i8brqcu79tra6tq9</string>
    </array>
  </dict>
</array>
```

#### GoogleService-Info.plist ✅
Your configuration looks correct with:
- CLIENT_ID: `985082913550-7fje7ug1b6t9j8d9i8brqcu79tra6tq9.apps.googleusercontent.com`
- REVERSED_CLIENT_ID: `com.googleusercontent.apps.985082913550-7fje7ug1b6t9j8d9i8brqcu79tra6tq9`

## Common Issues and Solutions

### Issue 1: "Sign in failed" Error
**Symptoms:** User sees "Sign in failed" message
**Solutions:**
1. Verify Google Cloud Console configuration
2. Check that the bundle ID matches exactly
3. Ensure Google Sign-In API is enabled in Google Cloud Console

### Issue 2: "Configuration error" 
**Symptoms:** App crashes or shows configuration error
**Solutions:**
1. Clean and rebuild the project:
   ```bash
   flutter clean
   flutter pub get
   cd ios && pod install
   ```
2. Verify GoogleService-Info.plist is in the correct location
3. Check that the bundle ID in Xcode matches your Google Cloud Console

### Issue 3: "Network error"
**Symptoms:** Network-related errors during sign-in
**Solutions:**
1. Check internet connection
2. Verify device can reach Google services
3. Check if device is in airplane mode

### Issue 4: "User cancelled"
**Symptoms:** Sign-in process is cancelled
**Solutions:**
1. This is normal user behavior
2. Check if user has Google account configured on device
3. Verify Google app is installed and updated

## Testing Steps

### 1. Debug Logging
The updated code now includes detailed logging. Check the console for:
- 🔍 Starting Google Sign-In process...
- ✅ Google Sign-In successful for: [email]
- 🔑 Getting authentication tokens...
- ✅ Tokens received successfully
- 🔥 Signing in to Firebase...
- ✅ Firebase authentication successful

### 2. Manual Testing
1. Open the app on iOS device/simulator
2. Try to sign in with Google
3. Check console logs for detailed error messages
4. Verify the sign-in flow completes successfully

### 3. Configuration Verification
1. Open Xcode
2. Check that GoogleService-Info.plist is included in the project
3. Verify bundle identifier matches Google Cloud Console
4. Ensure Google Sign-In capability is enabled

## Additional Debugging

### Check Google Cloud Console
1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Select your project
3. Go to APIs & Services > Credentials
4. Verify your iOS client ID is configured correctly
5. Check that Google Sign-In API is enabled

### Xcode Configuration
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner target
3. Go to Signing & Capabilities
4. Verify bundle identifier matches your configuration
5. Check that GoogleService-Info.plist is in the project

### Firebase Configuration
1. Verify Firebase project is correctly configured
2. Check that the iOS app is added to Firebase project
3. Download and replace GoogleService-Info.plist if needed

## If Issues Persist

### 1. Complete Reset
```bash
flutter clean
flutter pub get
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter run
```

### 2. Check Dependencies
Ensure you have the latest compatible versions:
```yaml
google_sign_in: ^6.2.2
firebase_auth: ^5.5.0
firebase_core: ^3.13.0
```

### 3. Test on Different Devices
- Test on physical iOS device
- Test on iOS simulator
- Test with different iOS versions

### 4. Contact Support
If issues persist after trying all solutions:
1. Collect detailed error logs
2. Note the exact iOS version and device model
3. Provide steps to reproduce the issue

## Success Indicators

When Google Sign-In is working correctly, you should see:
- ✅ User can select their Google account
- ✅ Sign-in completes without errors
- ✅ User data is retrieved (email, name)
- ✅ Firebase authentication succeeds
- ✅ App navigates to the main screen

## Notes

- The updated code includes better error handling and logging
- iOS-specific client ID is now properly configured
- URL scheme handling is improved in AppDelegate
- Session management is enhanced for better reliability 