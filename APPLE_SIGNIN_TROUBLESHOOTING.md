# Apple Sign-In Troubleshooting Guide

## Current Configuration Status

### ✅ What's Working
1. **Bundle Identifier**: `com.referaly` (correctly configured)
2. **Apple Sign-In Capability**: Enabled in `Runner.entitlements`
3. **Dependencies**: `sign_in_with_apple: ^7.0.1` (latest version)
4. **iOS Implementation**: Properly implemented with nonce validation
5. **Firebase Integration**: Correctly configured with OAuth provider

### 🔧 Configuration Files

#### Runner.entitlements ✅
```xml
<key>com.apple.developer.applesignin</key>
<array>
    <string>Default</string>
</array>
```

#### Info.plist ✅
```xml
<key>NSUserAuthenticationUsageDescription</key>
<string>We use Sign in with Apple to authenticate you securely.</string>
```

## 🚨 CRITICAL ISSUE: Firebase Invalid Credential Error

### Error: `[firebase_auth/invalid-credential] Invalid OAuth response from apple.com`

This is the specific error you're experiencing. Here's how to fix it:

### 🔧 **Immediate Solutions**

#### Solution 1: Firebase Console Configuration
1. **Go to Firebase Console** → Authentication → Sign-in method
2. **Enable Apple provider** if not already enabled
3. **Add your Apple Service ID** (if you have one)
4. **Save the changes**

#### Solution 2: Apple Developer Console Configuration
1. **Go to Apple Developer Console** → Certificates, Identifiers & Profiles
2. **Select your App ID** (`com.referaly`)
3. **Enable "Sign In with Apple" capability**
4. **Create a new provisioning profile** that includes Apple Sign-In
5. **Download and install the new provisioning profile**

#### Solution 3: Alternative Implementation
The improved code now includes an alternative method that:
- Removes the `accessToken` parameter from the OAuth credential
- Uses only the `idToken` and `rawNonce`
- Automatically falls back to this method if the main one fails

### 🔍 **Root Cause Analysis**

The error occurs because:
1. **Firebase expects a valid Apple ID token** but receives an invalid one
2. **The OAuth credential format** might be incorrect for your Firebase configuration
3. **Apple Developer Console** might not have Apple Sign-In properly configured
4. **Provisioning profile** might not include Apple Sign-In capability

### 🛠️ **Step-by-Step Fix**

#### Step 1: Verify Apple Developer Console
```bash
# Check your current bundle identifier
cd ios && grep -r "PRODUCT_BUNDLE_IDENTIFIER" . | grep "com.referaly"
```

#### Step 2: Check Firebase Console
1. Go to Firebase Console → Authentication → Sign-in method
2. Look for Apple provider
3. If not enabled, enable it
4. If enabled, check the configuration

#### Step 3: Test the Improved Implementation
The new implementation will:
1. Try the main method first
2. If it fails with `invalid-credential`, automatically try the alternative method
3. Provide detailed debug logs to identify the exact issue

#### Step 4: Check Debug Logs
Look for these specific log messages:
- 🍎 Apple Sign-In available: true/false
- 🍎 Identity Token: Present/Missing
- 🍎 ID Token length: [number]
- ❌ Firebase invalid credential error - check Apple Developer Console configuration

### 🔄 **Alternative Method Details**

The alternative method removes the `accessToken` parameter:
```dart
final oauthCredential = OAuthProvider("apple.com").credential(
  idToken: appleCredential.identityToken,
  rawNonce: rawNonce,
  // No accessToken parameter
);
```

This often resolves the invalid credential error.

## Common Issues and Solutions

### Issue 1: "Apple Sign-In is not available"
**Symptoms**: Debug log shows "Apple Sign-In available: false"
**Solutions**:
1. **Check iOS Version**: Apple Sign-In requires iOS 13.0+
2. **Check Device**: Must be a physical device (not simulator)
3. **Check Apple ID**: User must be signed into iCloud with Apple ID
4. **Check App Store**: App must be distributed through App Store or TestFlight

### Issue 2: "Identity token is null"
**Symptoms**: Debug log shows "Identity Token: Missing"
**Solutions**:
1. **Check Apple Developer Console**:
   - Go to Certificates, Identifiers & Profiles
   - Select your App ID (`com.referaly`)
   - Ensure "Sign In with Apple" capability is enabled
   - Verify the bundle ID matches exactly

2. **Check Provisioning Profile**:
   - Ensure you're using a provisioning profile that includes Apple Sign-In
   - Development profiles must have Apple Sign-In enabled

### Issue 3: "Firebase authentication failed"
**Symptoms**: Debug log shows "Firebase authentication failed with Apple credential"
**Solutions**:
1. **Check Firebase Console**:
   - Go to Authentication → Sign-in method
   - Enable Apple provider
   - Add your Apple Service ID (if using custom domain)

2. **Check Apple Service ID** (if using custom domain):
   - Create Service ID in Apple Developer Console
   - Configure domains and redirect URLs
   - Add Service ID to Firebase Apple provider settings

### Issue 4: "Authorization exception"
**Symptoms**: Specific authorization error codes
**Solutions by Error Code**:

#### AuthorizationErrorCode.canceled
- User cancelled the sign-in process
- This is normal behavior, not an error

#### AuthorizationErrorCode.failed
- Check Apple Developer Console configuration
- Verify bundle identifier matches exactly
- Ensure Apple Sign-In capability is enabled

#### AuthorizationErrorCode.invalidResponse
- Check network connectivity
- Verify Apple servers are accessible
- Try again later

#### AuthorizationErrorCode.notHandled
- Check if user is signed into iCloud
- Verify Apple ID is properly configured
- Try signing out and back into iCloud

#### AuthorizationErrorCode.unknown
- Generic error, check all configurations
- Verify iOS version compatibility
- Check device settings

## Testing Steps

### 1. Basic Availability Test
```dart
final isAvailable = await SignInWithApple.isAvailable();
print("Apple Sign-In available: $isAvailable");
```

### 2. Manual Testing Checklist
- [ ] Test on physical iOS device (not simulator)
- [ ] Ensure iOS 13.0 or later
- [ ] User signed into iCloud with Apple ID
- [ ] App installed via App Store or TestFlight
- [ ] Apple Sign-In capability enabled in Apple Developer Console
- [ ] Bundle identifier matches exactly: `com.referaly`
- [ ] Firebase Console has Apple provider enabled
- [ ] Provisioning profile includes Apple Sign-In capability

### 3. Debug Information
The improved implementation now provides detailed debug logs:
- 🍎 Starting Apple Sign-In process...
- 🍎 Apple Sign-In available: true/false
- 🍎 Generated nonce for Apple Sign-In
- 🍎 Requesting Apple ID credential...
- 🍎 Apple ID credential received
- 🍎 Identity Token: Present/Missing
- 🍎 Authorization Code: Present/Missing
- 🍎 Email: [email or "Not provided"]
- 🍎 Full Name: [name or empty]
- 🔄 Trying alternative Apple Sign-In method... (if main method fails)

## Apple Developer Console Configuration

### Required Steps:
1. **Go to Apple Developer Console** → Certificates, Identifiers & Profiles
2. **Select your App ID** (`com.referaly`)
3. **Enable "Sign In with Apple" capability**
4. **Configure for Development and Production**
5. **Update provisioning profiles** to include Apple Sign-In

### Optional: Custom Domain Configuration
If you want to use a custom domain for Apple Sign-In:
1. **Create a Service ID** in Apple Developer Console
2. **Configure domains and redirect URLs**
3. **Add Service ID to Firebase Console** → Authentication → Apple provider

## Firebase Console Configuration

### Required Steps:
1. **Go to Firebase Console** → Authentication → Sign-in method
2. **Enable Apple provider**
3. **Add your Apple Service ID** (if using custom domain)
4. **Configure OAuth redirect URLs** (if needed)

## Common Debugging Commands

### Check Bundle Identifier
```bash
cd ios && grep -r "PRODUCT_BUNDLE_IDENTIFIER" . | grep "com.referaly"
```

### Check Entitlements
```bash
cat ios/Runner/Runner.entitlements
```

### Check Info.plist
```bash
grep -A 5 -B 5 "NSUserAuthenticationUsageDescription" ios/Runner/Info.plist
```

## Next Steps

1. **Test the improved implementation** with detailed logging
2. **Check debug output** to identify the specific issue
3. **Verify Apple Developer Console** configuration
4. **Test on physical device** with iOS 13.0+
5. **Ensure user is signed into iCloud**
6. **Check Firebase Console** Apple provider configuration

## Error Messages for Users

The improved implementation now shows user-friendly error messages:
- **"Apple Sign-In was cancelled or failed."** - User cancelled or basic failure
- **"Apple Sign-In failed. Please try again."** - API call failed
- **"Apple Sign-In error: [specific error]"** - Detailed error information

## Support Resources

- [Apple Sign-In Documentation](https://developer.apple.com/documentation/sign_in_with_apple)
- [Firebase Apple Auth Documentation](https://firebase.google.com/docs/auth/ios/apple)
- [Flutter sign_in_with_apple Package](https://pub.dev/packages/sign_in_with_apple) 