import UIKit
import Flutter
import FirebaseCore
import Firebase
//import FirebaseAuth
import FirebaseMessaging
import flutter_local_notifications
import FBAudienceNetwork

@main
@objc class AppDelegate: FlutterAppDelegate {

  //? This method added for fcm token
  // https://stackoverflow.com/questions/58246620/apns-device-token-not-set-before-retrieving-fcm-token-for-sender-id-react-nati
  override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      // Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.unknown)
      // Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.prod)
//      Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)
      Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
  }


  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    //? according flutter_local_notifications readme Start
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
        GeneratedPluginRegistrant.register(with: registry)
    }
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    //? according flutter_local_notifications readme End
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
