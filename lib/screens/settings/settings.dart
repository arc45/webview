import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web_horizon/controller/controller.dart';
import 'package:web_horizon/model/app_settings.dart';
import 'package:web_horizon/res/theme.dart';
import 'package:web_horizon/utils/global.dart' as global;
import 'package:web_horizon/utils/routes/routes_name.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // Global get global => Global();
  AppSettingsData? get globalSettingsData => global.appSettings;

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.put(SettingsController());
    final adsController = Get.find<AdsController>();
    final moreAppsController = Get.find<MoreAppsController>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 0.0,
        titleSpacing: 20.0,
        title: const Text(
          "Settings",
          style: bold20White,
        ),
      ),
      body: ListView(
        padding:
            const EdgeInsets.only(bottom: fixPadding * 2.0, top: fixPadding),
        physics: const BouncingScrollPhysics(),
        children: [
          darkTheme(context),
          heightSpace,
          divider(),
          pushNotification(context, settingsController),
          divider(),
          if (globalSettingsData?.webviewCache == 1)
            Column(
              children: [
                commanListTileWidget(context, "Clear cache", () {
                  cacheDialog(settingsController, adsController);
                  adsController.interstitialAdShow();
                }),
                divider(),
              ],
            ),
          commanListTileWidget(context, "Privacy Policy", () {
            Get.toNamed(RoutesName.privacyPolicy);
            adsController.interstitialAdShow();
          }),
          divider(),
          commanListTileWidget(context, "Share", () {
            settingsController.sharedAppData();
            adsController.interstitialAdShow();
          }),
          divider(),
          commanListTileWidget(context, "Rate us", () {
            settingsController.rateUs();
            adsController.interstitialAdShow();
          }),
          divider(),
          moreAppsOption(moreAppsController, context, adsController),
          commanListTileWidget(context, "About us", () {
            Get.toNamed(RoutesName.about);
            adsController.interstitialAdShow();
          }),
        ],
      ),
    );
  }

  Obx moreAppsOption(MoreAppsController moreAppsController,
      BuildContext context, AdsController adsController) {
    return Obx(() {
      if (moreAppsController.moreAppsList.isNotEmpty) {
        return Column(
          children: [
            commanListTileWidget(context, "More apps", () {
              Get.toNamed(RoutesName.moreApps);
              adsController.interstitialAdShow();
            }),
            divider()
          ],
        );
      } else {
        return const SizedBox();
      }
    });
  }

  cacheDialog(SettingsController settingsController,
      AdsController adsController) async {
    var directory = await getTemporaryDirectory();

    var temporaryBytes = dirStatSync(directory.path);

    return Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.all(fixPadding * 2.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(fixPadding * 2.0),
          children: [
            Text(
              "Free up ${getFileSizeString(bytes: temporaryBytes)} of space",
              style: Get.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            heightSpace,
            Text(
              "Are you sure you want to clear the cache?",
              style: Get.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            heightSpace,
            heightSpace,
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      adsController.interstitialAdShow();
                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(fixPadding * 1.2),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: orignalBlackColor.withValues(alpha: 0.2),
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
                    onTap: () {
                      settingsController.clearCache(directory);
                      adsController.interstitialAdShow();
                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(fixPadding * 1.2),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.25),
                            blurRadius: 6.0,
                          )
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Clear",
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

  String getFileSizeString({required int bytes, int decimals = 0}) {
    const suffixes = [" B", " KB", " MB", " GB", " TB"];
    if (bytes == 0) return '0${suffixes[0]}';
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }

  int dirStatSync(String dirPath) {
    int totalSize = 0;
    var dir = Directory(dirPath);
    try {
      if (dir.existsSync()) {
        dir
            .listSync(recursive: true, followLinks: false)
            .forEach((FileSystemEntity entity) {
          if (entity is File) {
            totalSize += entity.lengthSync();
          }
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return totalSize;
  }

  commanListTileWidget(BuildContext context, String title, Function() onTap) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(fixPadding * 2.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            widthSpace,
            const Icon(
              Icons.arrow_forward_ios,
              size: 18.0,
            )
          ],
        ),
      ),
    );
  }

  divider() {
    return Container(
      width: double.maxFinite,
      color: greyD4Color,
      height: 1.0,
    );
  }

  pushNotification(BuildContext context, SettingsController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: fixPadding * 2.0, vertical: fixPadding),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Push Notification",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          widthSpace,
          Obx(
            () => Switch(
              activeColor: primaryColor,
              value: controller.isNotificationOn.value,
              activeTrackColor: primaryColor,
              thumbColor: WidgetStateProperty.all(whiteColor),
              trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
              trackOutlineWidth: WidgetStateProperty.all(0),
              inactiveTrackColor: greyColor,
              inactiveThumbColor: whiteColor,
              onChanged: (value) {
                controller.changeNotificationSettings();
              },
            ),
          )
        ],
      ),
    );
  }

  darkTheme(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: fixPadding * 2.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Dark theme",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          widthSpace,
          GetBuilder<ThemeController>(
            builder: (themeController) => Switch(
              activeColor: primaryColor,
              value: themeController.theme == ThemeMode.light ? false : true,
              activeTrackColor: primaryColor,
              thumbColor: WidgetStateProperty.all(whiteColor),
              trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
              trackOutlineWidth: WidgetStateProperty.all(0),
              inactiveTrackColor: greyColor,
              inactiveThumbColor: whiteColor,
              onChanged: (value) {
                themeController.switchTheme();
              },
            ),
          )
        ],
      ),
    );
  }
}
