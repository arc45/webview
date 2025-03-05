import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:web_horizon/model/app_settings.dart';
import 'package:web_horizon/services/get_storage_service.dart';
import 'package:web_horizon/res/theme.dart';
import 'package:web_horizon/utils/global.dart' as global;
import 'package:web_horizon/utils/utils.dart';

class SettingsController extends GetxController {
  final GSService _gsService = GSService();

  // static Global global = Global();

  // static AppSettingsData? globalSettingsData = global.appSettings;

  // Global get global => Global();
  AppSettingsData? get globalSettingsData => global.appSettings;

  final _firebaseMessaging = FirebaseMessaging.instance;

  var isNotificationOn = false.obs;

  @override
  void onInit() {
    isNotificationOn.value = _gsService.read(GSKeys.isNotifEnabled) ?? false;
    if (!(_gsService.read(GSKeys.isAskPermission) ?? false)) {
      handleNoitificationPermission();
    }

    super.onInit();
  }

  Future<void> rateUs() async {
    final url = Uri.parse(Platform.isIOS
        ? globalSettingsData?.iosAppLink ?? ''
        : globalSettingsData!.androidAppLink ?? '');

    Utils.uriLaunch(url);
  }

  void changeNotificationSettings() async {
    var settings = await _firebaseMessaging.getNotificationSettings();

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      openSettingsDialog();
    } else if (isNotificationOn.value == true) {
      isNotificationOn.value = false;
      _gsService.write(GSKeys.isNotifEnabled, false);
      _firebaseMessaging.unsubscribeFromTopic(global.topic);
    } else {
      isNotificationOn.value = true;
      _gsService.write(GSKeys.isNotifEnabled, true);
      _firebaseMessaging.subscribeToTopic(global.topic);
    }
  }

  openSettingsDialog() {
    return Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.all(fixPadding * 2.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(fixPadding * 2.0),
          physics: const BouncingScrollPhysics(),
          children: [
            const Text(
              "Allow notification from settings",
              style: bold18Black,
              textAlign: TextAlign.center,
            ),
            heightSpace,
            heightSpace,
            const Text(
              "Please enable notification from your settings to stay updated!",
              style: semibold16Grey,
              textAlign: TextAlign.center,
            ),
            heightSpace,
            heightSpace,
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(fixPadding * 1.2),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: blackColor.withValues(alpha: 0.2),
                            blurRadius: 6.0,
                          )
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Cancel",
                        style: semibold16Primary,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                widthSpace,
                widthSpace,
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      Get.back();
                      await AppSettings.openAppSettings();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(fixPadding * 1.2),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.2),
                            blurRadius: 6.0,
                          )
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Settings",
                        style: semibold16White,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void handleNoitificationPermission() async {
    var settings = await _firebaseMessaging.getNotificationSettings();

    _gsService.write(GSKeys.isAskPermission, true);

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      await _firebaseMessaging.requestPermission().then(
        (value) async {
          if (value.authorizationStatus == AuthorizationStatus.authorized) {
            isNotificationOn.value = true;
            await _gsService.write(GSKeys.isNotifEnabled, true);
            await _firebaseMessaging.subscribeToTopic(global.topic);
          } else {
            isNotificationOn.value = false;
            await _gsService.write(GSKeys.isNotifEnabled, false);
            await _firebaseMessaging.unsubscribeFromTopic(global.topic);
          }
        },
      );
    } else {
      isNotificationOn.value = true;
      await _gsService.write(GSKeys.isNotifEnabled, true);
      await _firebaseMessaging.subscribeToTopic(global.topic);
    }
  }

  sharedAppData() {
    Share.share(
      "Download this amazing app and share with your friends.\nAndroid :- ${globalSettingsData?.androidAppLink}\nIOS :- ${globalSettingsData?.iosAppLink}",
    );
  }

  Future<void> clearCache(Directory cacheDirectory) async {
    try {
      if (cacheDirectory.existsSync()) {
        cacheDirectory.deleteSync(recursive: true);
      }
    } catch (e) {
      debugPrint("Error deleting cache directory: $e");
    }
  }
}
