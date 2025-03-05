/*url_launcher :
  Info.plist =:
      
   Already Addded::
   <key>LSApplicationQueriesSchemes</key>
   <array>
      <string>sms</string>
      <string>tel</string>
   </array>
*/     

/* 
  flutter_local_notifications :

  AppDelegate.swift

     if #available(iOS 10.0, *) {
  UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
}
*/

/*

 firebase_messaging ::-

• Add APNS certs to your project in Project Settings > Notifications in the console
• Run pod install --repo-update
• Copy in the GoogleServices-Info.plist to your project
• Update the app Bundle ID in Xcode to match the Bundle ID of your APNs cert.
• Run the sample on your iOS device.

*/

/*

  location:-

  // already added::

<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to your location to provide you with accurate information.</string>

<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app needs access to your location at all times to provide you with accurate information, even when the app is not running.</string>

*/


/*

     flutter_inappwebview:-

     https://inappwebview.dev/docs/intro
*/ 
