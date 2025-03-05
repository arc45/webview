import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:web_horizon/controller/ads_controller.dart';
import 'package:web_horizon/model/app_settings.dart';
import 'package:web_horizon/res/app_url.dart';
import 'package:web_horizon/res/theme.dart';
import 'package:web_horizon/services/apiService/base_api_services.dart';
import 'package:web_horizon/services/apiService/network_api_services.dart';
import 'package:web_horizon/utils/global.dart' as global;
import 'package:web_horizon/utils/routes/routes_name.dart';
import 'package:web_horizon/utils/utils.dart';

class SplashController extends GetxController {
  BaseApiService apiService = NetworkApiServices();

  AppSettingsData? get globalSettingsData => global.appSettings;
  AdNetwork? get adNetworkSettings => globalSettingsData?.adNetworks?[0];

  // static Global global = Global();

  // static AppSettingsData? globalSettingsData = global.appSettings;
  // static AdNetwork? adNetworkSettings = globalSettingsData?.adNetworks?[0];

  checkAppUpdate() async {
    final packageInfo = await PackageInfo.fromPlatform();

    double buildNumber = double.parse(packageInfo.buildNumber);

    if (Platform.isAndroid) {
      if (globalSettingsData?.androidUpdatePopup == 1) {
        if ((globalSettingsData?.androidAppVersionCode.toDouble() ?? 0.0) > buildNumber) {
          updateDialog(globalSettingsData?.androidForceUpdate == 0);
        } else {
          navigateRoute();
        }
      } else {
        navigateRoute();
      }
    } else if (Platform.isIOS) {
      if (globalSettingsData?.iosUpdatePopup == 1) {
        if ((globalSettingsData?.iosAppVersionCode.toDouble() ?? 0.0) > buildNumber) {
          updateDialog(globalSettingsData?.iosForceUpdate == 0);
        } else {
          navigateRoute();
        }
      } else {
        navigateRoute();
      }
    }
  }

  Future<dynamic> updateDialog(bool isForceToUpdate) {
    return Get.dialog(
      barrierDismissible: false,
      PopScope(
        canPop: false,
        child: Transform.translate(
          offset: const Offset(0, -35),
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            shape: const RoundedRectangleBorder(),
            insetPadding: const EdgeInsets.all(fixPadding * 2.0),
            child: Center(
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 70),
                    padding: const EdgeInsets.only(top: 70),
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(fixPadding * 2.0),
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              bottom:
                                  globalSettingsData?.updateAppMessage == null ? fixPadding : 0),
                          child: const Text(
                            "Update Available",
                            style: bold18Black,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        if (globalSettingsData?.updateAppMessage != null)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(fixPadding * 2.0),
                              child: HtmlWidget(
                                globalSettingsData?.updateAppMessage ?? '',
                                textStyle: const TextStyle(
                                  color: blackColor,
                                ),
                              ),
                            ),
                          ),
                        GestureDetector(
                          onTap: () {
                            onUpdate();
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: fixPadding),
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
                              "Update",
                              style: semibold16White,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        heightSpace,
                        if (isForceToUpdate)
                          Center(
                            child: InkWell(
                              onTap: () {
                                navigateRoute();
                              },
                              child: const Text(
                                "Skip",
                                style: bold16Primary,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    child: Center(
                      child: Image.asset(
                        "assets/images/update_vector.png",
                        height: 140,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onUpdate() async {
    Uri url = Uri.parse(Platform.isAndroid
        ? globalSettingsData?.androidAppLink ?? ''
        : globalSettingsData?.iosAppLink ?? '');

    Utils.uriLaunch(url);
  }

  Future fetchAppSettings() async {
    var headers = {'Authorization': global.apiSecretKey};
    try {
      var response = await apiService.getGetApiResponse(
        url: AppUrl.appSettingsUrl,
        headers: headers,
      );

      global.appSettings = AppSettingsModel.fromJson(response).data?[0];

      await initializedAds();
      Get.lazyPut(() => AdsController());

      await checkAppUpdate();
    } catch (error) {
      debugPrint("e :: $error");
      if (error is DioException) {
        if (error.type == DioExceptionType.connectionError) {
          noConnectionDialog();
        } else {
          debugPrint("Error During Commnunication : ${error.type}");
        }
      } else {
        debugPrint("Error During Commnunication:: $error");
      }
    }
  }

  Future<void> initializedAds() async {
    if (adNetworkSettings?.adStatus == 1 && adNetworkSettings?.primaryAdNetwork == "AdMob") {
      await MobileAds.instance.initialize();
    }
  }

  Future<dynamic> noConnectionDialog() {
    return Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(fixPadding * 2.0),
          children: [
            Center(
              child: Image.asset(
                "assets/images/no-internet-connection.png",
                height: 65.0,
                fit: BoxFit.cover,
              ),
            ),
            heightSpace,
            Text(
              "Hey, you are offline or have a bad connection.",
              style: Get.isDarkMode ? semibold16White : semibold16OrignalBlack,
              textAlign: TextAlign.center,
            ),
            heightSpace,
            heightSpace,
            GestureDetector(
              onTap: () {
                Get.back();
                fetchAppSettings();
              },
              child: Container(
                padding: const EdgeInsets.all(fixPadding * 1.2),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(color: orignalBlackColor.withValues(alpha: 0.2), blurRadius: 6.0)
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  "PLEASE TRY AGAIN",
                  style: bold16White,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  navigateRoute() {
    Get.offAllNamed(RoutesName.bottombar);
  }

  @override
  void onReady() async {
    super.onReady();
    Future.delayed(const Duration(seconds: 2), () async {
      await fetchAppSettings();
    });
  }
}
