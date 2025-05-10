#import "AppDelegate.h"

#import <FirebaseCore/FirebaseCore.h>
#import <React/RCTBundleURLProvider.h>
// #import <GoogleSignIn/GoogleSignIn.h>
#import <AuthenticationServices/AuthenticationServices.h>
#import <SafariServices/SafariServices.h>
#import <FBSDKCoreKit/FBSDKCoreKit-Swift.h>
#import <React/RCTLinkingManager.h>
#import <RNBranch/RNBranch.h>


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

   [[FBSDKApplicationDelegate sharedInstance] application:application
                         didFinishLaunchingWithOptions:launchOptions];
  
    //  [RNBranch useTestInstance];
    [RNBranch initSessionWithLaunchOptions:launchOptions isReferrable:YES];
      NSURL *jsCodeLocation;
  [FIRApp configure];
  self.moduleName = @"referaly";
  // You can add your custom initial props in the dictionary below.
  // They will be passed down to the ViewController used by React Native.
  self.initialProps = @{};

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

// - (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options {
//   return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url options:options] || [GIDSignIn.sharedInstance handleURL:url];
// }
- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

- (BOOL)application:(UIApplication *)application
   openURL:(NSURL *)url
   options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
  if ([RNBranch application:application openURL:url options:options]) {
     return YES;
   }

   if ([RCTLinkingManager application:application openURL:url options:options]) {
     return YES;
   }

   return NO;

}
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
  [RNBranch continueUserActivity:userActivity];
  return YES;
}

 
@end
