#!/bin/bash

echo "🔗 Branch.io Deep Link Configuration Test"
echo "=========================================="

echo ""
echo "📱 iOS Configuration Check:"
echo "---------------------------"

# Check Info.plist for Branch configuration
if grep -q "branch_key" ios/Runner/Info.plist; then
    echo "✅ Branch keys found in Info.plist"
else
    echo "❌ Branch keys missing in Info.plist"
fi

# Check for App Store ID
if grep -q "branch_app_store_id" ios/Runner/Info.plist; then
    echo "✅ App Store ID configuration found"
    APP_STORE_ID=$(grep -A 1 "branch_app_store_id" ios/Runner/Info.plist | tail -1 | sed 's/<string>//g' | sed 's/<\/string>//g' | tr -d ' ')
    if [ "$APP_STORE_ID" = "YOUR_APP_STORE_ID" ]; then
        echo "⚠️  App Store ID needs to be updated (currently placeholder)"
    else
        echo "✅ App Store ID configured: $APP_STORE_ID"
    fi
else
    echo "❌ App Store ID configuration missing"
fi

# Check Associated Domains
echo ""
echo "🌐 Associated Domains Check:"
if grep -q "associated-domains" ios/Runner/Runner.entitlements; then
    echo "✅ Associated Domains capability found"
    echo "📋 Configured domains:"
    grep -A 10 "associated-domains" ios/Runner/Runner.entitlements | grep "applinks:" | sed 's/.*<string>//g' | sed 's/<\/string>.*//g' | sed 's/^/   - /'
else
    echo "❌ Associated Domains capability missing"
fi

echo ""
echo "🤖 Android Configuration Check:"
echo "-------------------------------"

# Check Android manifest for Branch domains
if grep -q "xcnym-alternate.app.link" android/app/src/main/AndroidManifest.xml; then
    echo "✅ Branch domains found in AndroidManifest.xml"
else
    echo "❌ Branch domains missing in AndroidManifest.xml"
fi

echo ""
echo "🔧 Next Steps:"
echo "--------------"
echo "1. Update App Store ID in ios/Runner/Info.plist"
echo "2. Verify Branch Dashboard configuration"
echo "3. Check Apple Developer Console settings"
echo "4. Test with uninstalled app"
echo "5. Test with installed app"

echo ""
echo "📚 For detailed setup instructions, see: BRANCH_IO_SETUP_GUIDE.md" 