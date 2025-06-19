import UIKit
import Flutter
import Branch

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Register Flutter plugins
    GeneratedPluginRegistrant.register(with: self)

    // ✅ Initialize Branch
    Branch.getInstance().initSession(launchOptions: launchOptions) { (params, error) in
      if let error = error {
        print("Branch Init Error: \(error.localizedDescription)")
      } else if let data = params as? [String: Any] {
        print("Branch Deep Link Params: \(data)")

        // ✅ Optional: Send data to Flutter using MethodChannel
        if let controller = self.window?.rootViewController as? FlutterViewController {
          let channel = FlutterMethodChannel(name: "com.referaly/branch", binaryMessenger: controller.binaryMessenger)
          channel.invokeMethod("onBranchLink", arguments: data)
        }
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // ✅ Handle deep link open URL
  override func application(
    _ application: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    Branch.getInstance().application(application, open: url, options: options)
    return super.application(application, open: url, options: options)
  }

  // ✅ Handle Universal Link (important for iOS 13+)
  override func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
  ) -> Bool {
    Branch.getInstance().continue(userActivity)
    return super.application(application, continue: userActivity, restorationHandler: restorationHandler)
  }
}
