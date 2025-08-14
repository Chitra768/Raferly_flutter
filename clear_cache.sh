#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧹 Flutter Cache Cleanup Script${NC}"
echo -e "${BLUE}===============================${NC}"
echo ""

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    exit 1
fi

print_info "Starting cache cleanup process..."

# 1. Clean Flutter cache
print_info "Cleaning Flutter cache..."
flutter clean
if [ $? -eq 0 ]; then
    print_status "Flutter cache cleaned successfully"
else
    print_error "Failed to clean Flutter cache"
    exit 1
fi

# 2. Clean Dart cache
print_info "Cleaning Dart cache..."
dart pub cache clean
if [ $? -eq 0 ]; then
    print_status "Dart cache cleaned successfully"
else
    print_warning "Dart cache clean failed (this is usually okay)"
fi

# 3. Clean Android build cache
print_info "Cleaning Android build cache..."
cd android
./gradlew clean
if [ $? -eq 0 ]; then
    print_status "Android build cache cleaned successfully"
else
    print_warning "Android clean failed (this might be okay if no Android build exists)"
fi
cd ..

# 4. Clean iOS build cache
print_info "Cleaning iOS build cache..."
cd ios
rm -rf build/
rm -rf Pods/
rm -rf .symlinks/
rm -rf Podfile.lock
if [ $? -eq 0 ]; then
    print_status "iOS build cache cleaned successfully"
else
    print_warning "iOS clean failed (this might be okay if no iOS build exists)"
fi
cd ..

# 5. Clean pub cache
print_info "Cleaning pub cache..."
flutter pub cache clean
if [ $? -eq 0 ]; then
    print_status "Pub cache cleaned successfully"
else
    print_warning "Pub cache clean failed"
fi

# 6. Get dependencies
print_info "Getting dependencies..."
flutter pub get
if [ $? -eq 0 ]; then
    print_status "Dependencies fetched successfully"
else
    print_error "Failed to get dependencies"
    exit 1
fi

# 7. Install iOS pods
print_info "Installing iOS pods..."
cd ios
pod install
if [ $? -eq 0 ]; then
    print_status "iOS pods installed successfully"
else
    print_error "Failed to install iOS pods"
    exit 1
fi
cd ..

echo ""
print_status "All caches cleared successfully!"
echo ""
print_info "Your project is now clean and ready for a fresh build."
print_info "Run './build_release.sh' to create a release build." 