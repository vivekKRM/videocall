import Flutter
import UIKit
import FirebaseCore


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
     
     if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { success, error in
          
      }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

   override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Will Present Notification")
            super.userNotificationCenter(center, willPresent: notification, withCompletionHandler: completionHandler)
        }

    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Did Receive Notification")
                // self.communicationChannel.invokeMethod("Show Notification", arguments: notification.request.content.userInfo)
            super.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)

        }
}
