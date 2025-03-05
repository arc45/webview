import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:web_horizon/res/theme.dart';

class NotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() async {
    // Initialization  setting

    const InitializationSettings initializationSettingsAndroid =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(),
    );
    _notificationsPlugin.initialize(
      initializationSettingsAndroid,
      // to handle event when we receive notification
      onDidReceiveNotificationResponse: (details) {
        if (details.input != null) {}
      },
    );
  }

  Future<void> display(RemoteMessage message) async {
    // To display the notification in device

    debugPrint("data :: ${message.data}");
    debugPrint("image  :: ${message.notification!.android!.imageUrl}");
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      final String? image = message.notification!.android!.imageUrl;

      String? attachmentPicturePath;

      if (image != null) {
        attachmentPicturePath = await downloadAndSaveFile(
          image.toString(),
          "notification-image.png",
        );
      }

      NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "default_channel_id",
          message.notification!.android!.sound ?? "Main Channel",
          groupKey: "Groupe key",
          color: primaryColor,
          importance: Importance.max,
          playSound: true,
          indeterminate: true,
          priority: Priority.high,
          styleInformation: image != null
              ? BigPictureStyleInformation(
                  FilePathAndroidBitmap(attachmentPicturePath.toString()),
                )
              : null,
        ),
      );

      await _notificationsPlugin.show(
        id,
        message.notification?.title,
        message.notification?.body,
        notificationDetails,
      );
    } catch (e) {
      debugPrint("Error :: $e");
    }
  }

  static Future backgroundHandler(RemoteMessage msg) async {
    debugPrint("<<<BG Notification $msg>>>");

    // To initialise when app is not terminated
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        NotificationService().display(message);
      }
      debugPrint("<<<<on message app is not terminate>>>>");
    });
  }

  initializedNotification() {
    NotificationService.initialize();

    FirebaseMessaging.onBackgroundMessage(
        NotificationService.backgroundHandler);

    _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    // To initialise when app is not terminated
    FirebaseMessaging.onMessage.listen((message) async {
      if (message.notification != null) {
        NotificationService().display(message);
      }
      debugPrint("<<<message1 :: $message>>>");
    });
  }

  Future<String> downloadAndSaveFile(String url, String fileName) async {
    final directory = await getExternalStorageDirectory();
    final filePath = '${directory?.path}/$fileName';

    final http.Response response = await http.get(Uri.parse(url));

    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    return filePath;
  }
}
