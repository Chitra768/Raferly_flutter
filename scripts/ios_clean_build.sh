#!/bin/bash
# Run from project root to fix iOS "Linker command failed with exit code 1"
set -e
cd "$(dirname "$0")/.."
echo "Cleaning Flutter..."
flutter clean
flutter pub get
echo "Cleaning iOS Pods..."
rm -rf ios/Pods ios/Podfile.lock ios/.symlinks
echo "Reinstalling Pods..."
cd ios && pod install --repo-update && cd ..
echo "Done. Try: flutter run (or build from Xcode)."
