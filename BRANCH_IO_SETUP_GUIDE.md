# Branch.io Deep Link Setup Guide

## Issue: Deep links opening App Store instead of app when not installed

### Root Causes & Solutions:

#### 1. **App Store ID Configuration**
**Problem**: Branch needs your App Store ID to redirect users to the correct app when it's not installed.

**Solution**: 
- Replace `YOUR_APP_STORE_ID` in `ios/Runner/Info.plist` with your actual App Store ID
- Find your App Store ID in App Store Connect or use this URL format: `https://apps.apple.com/app/idYOUR_APP_STORE_ID`

#### 2. **Branch Dashboard Configuration**

**Required Steps in Branch Dashboard:**

1. **Go to your Branch Dashboard** → Link Settings → App Settings
2. **iOS App Settings:**
   - App Store ID: Add your actual App Store ID
   - Bundle ID: `com.referaly.referaly` (verify this matches your Xcode project)
   - Team ID: Your Apple Developer Team ID
   - Associated Domains: Ensure these are added:
     - `link.referaly.fr`
     - `xcnym-alternate.app.link`
     - `xcnym.test-app.link`
     - `referaly.app.link`
     - `xcnym-alternate.test-app.link`

3. **Universal Link Domains:**
   - Add all your custom domains to the Universal Link Domains section
   - Ensure the domains match exactly with your `Info.plist` and `Runner.entitlements`

#### 3. **Apple Developer Console Configuration**

**Required Steps:**

1. **Go to Apple Developer Console** → Certificates, Identifiers & Profiles
2. **Select your App ID** (com.referaly.referaly)
3. **Enable Associated Domains capability**
4. **Add Associated Domains:**
   ```
   applinks:link.referaly.fr
   applinks:xcnym-alternate.app.link
   applinks:xcnym.test-app.link
   applinks:referaly.app.link
   applinks:xcnym-alternate.test-app.link
   ```

#### 4. **Xcode Project Configuration**

**Verify these settings:**

1. **Bundle Identifier**: Should match your Branch dashboard
2. **Team**: Should match your Apple Developer account
3. **Signing & Capabilities**:
   - Associated Domains capability should be enabled
   - All domains should be listed

#### 5. **Testing Steps**

**To test if deep links work when app is not installed:**

1. **Uninstall your app** from the test device
2. **Create a Branch link** with your custom domain
3. **Open the link** in Safari or Messages
4. **Should redirect to App Store** with your app page
5. **After installing**, the same link should open your app

#### 6. **Common Issues & Fixes**

**Issue**: Links still open App Store even after app is installed
**Fix**: 
- Clear Safari cache and data
- Restart the device
- Verify Associated Domains are properly configured

**Issue**: Universal links not working on iOS 13+
**Fix**:
- Ensure `continue userActivity` method is properly implemented in `AppDelegate.swift`
- Verify all domains are added to Associated Domains capability

**Issue**: Test links work but production links don't
**Fix**:
- Check if you're using the correct Branch keys (live vs test)
- Verify production domains are configured in Branch dashboard
- Ensure App Store ID is correct for production

#### 7. **Verification Commands**

**Test your configuration:**

```bash
# Check if your app can handle universal links
xcrun simctl openurl booted "https://link.referaly.fr/test"

# Verify Associated Domains
grep -r "associated-domains" ios/Runner/Runner.entitlements
```

#### 8. **Branch Link Structure**

**Your links should follow this pattern:**
```
https://link.referaly.fr/your-path
https://xcnym-alternate.app.link/your-path
https://referaly.app.link/your-path
```

#### 9. **Next Steps**

1. **Update App Store ID** in `Info.plist`
2. **Verify Branch Dashboard** configuration
3. **Check Apple Developer Console** settings
4. **Test with uninstalled app**
5. **Test with installed app**

### Important Notes:

- **Universal Links require HTTPS** - no HTTP support
- **Associated Domains must be verified** by Apple
- **App Store ID is crucial** for redirecting when app is not installed
- **Test on real devices** - simulator behavior may differ
- **Clear cache** between tests to ensure fresh behavior

### Support Resources:

- [Branch Universal Links Documentation](https://help.branch.io/using-branch/docs/universal-links)
- [Apple Universal Links Guide](https://developer.apple.com/ios/universal-links/)
- [Branch Dashboard](https://dashboard.branch.io/) 