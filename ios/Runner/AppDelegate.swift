import UIKit
import Flutter
import BranchSDK

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Register Flutter plugins
    GeneratedPluginRegistrant.register(with: self)

    // ✅ Configure Branch settings
    configureBranch()


    // ✅ Initialize Branch with better error handling
    Branch.getInstance().initSession(launchOptions: launchOptions) { (params, error) in
      if let error = error {
        print("Branch Init Error: \(error.localizedDescription)")
      } else if let data = params as? [String: Any] {
        print("Branch Deep Link Params: \(data)")
        
        // Check if this is a deep link click
        if let clickedBranchLink = data["+clicked_branch_link"] as? Bool, clickedBranchLink {
          print("✅ Branch link clicked successfully")
        }

        // ✅ Send data to Flutter using MethodChannel
        if let controller = self.window?.rootViewController as? FlutterViewController {
          let channel = FlutterMethodChannel(name: "com.referaly/branch", binaryMessenger: controller.binaryMessenger)
          channel.invokeMethod("onBranchLink", arguments: data)
        }
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // ✅ Handle deep link open URL with better logging
  override func application(
    _ application: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    print("🔗 Handling URL: \(url)")
    
    // Validate URL before processing
    if validateDeepLink(url) {
      let handled = Branch.getInstance().application(application, open: url, options: options)
      print("Branch handled URL: \(handled)")
      return handled || super.application(application, open: url, options: options)
    } else {
      print("⚠️ URL not recognized as Branch link: \(url)")
      return super.application(application, open: url, options: options)
    }
  }

  // ✅ Handle Universal Link (important for iOS 13+)
  override func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
  ) -> Bool {
    print("🌐 Handling Universal Link: \(userActivity.webpageURL?.absoluteString ?? "no URL")")
    
    if let url = userActivity.webpageURL, validateDeepLink(url) {
      let handled = Branch.getInstance().continue(userActivity)
      print("Branch handled Universal Link: \(handled)")
      return handled || super.application(application, continue: userActivity, restorationHandler: restorationHandler)
    } else {
      print("⚠️ Universal Link not recognized as Branch link")
      return super.application(application, continue: userActivity, restorationHandler: restorationHandler)
    }
  }
  
  // MARK: - Branch Configuration Methods
  
  private func configureBranch() {
    // Set Branch to use live keys in production
    #if DEBUG
    // Debug mode is automatically enabled in debug builds
    print("🔧 Branch Debug Mode: Enabled")
    #endif
    
    // Configure Branch settings - using supported methods only
    print("🔧 Branch Configuration: Initialized")
  }
  
  private func validateDeepLink(_ url: URL) -> Bool {
    // Check if URL matches our configured domains
    let validDomains = [
      "link.referaly.fr",
      "xcnym-alternate.app.link",
      "xcnym.test-app.link",
      "referaly.app.link",
      "app.referaly.fr",
      "xcnym-alternate.test-app.link",
      
    ]
    
    guard let host = url.host else { return false }
    return validDomains.contains(host)
  }
  

}
