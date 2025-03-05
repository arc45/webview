import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_horizon/controller/controller.dart';
import 'package:web_horizon/model/app_settings.dart';
import 'package:web_horizon/model/navigation_model.dart';
import 'package:web_horizon/res/app_url.dart';
import 'package:web_horizon/services/apiService/base_api_services.dart';
import 'package:web_horizon/services/apiService/network_api_services.dart';
import 'package:web_horizon/utils/global.dart' as global;
import 'package:web_horizon/utils/utils.dart';

class HomeController extends GetxController {
  AppSettingsData? get globalSettingsData => global.appSettings;
  AdNetwork? get adNetworkSettings => globalSettingsData?.adNetworks?[0];

  InAppWebViewController? inAppWebViewController;
  PullToRefreshController? pullToRefreshController;

  var selectedTileIndex = Rx<int?>(null);
  var homeSelected = Rx<int?>(0);

  RxDouble loadingValue = 0.0.obs;

  var drawerList = <NavigationData>[].obs;
  var weburi = "".obs;

  Rx<bool> isLocationServiceEnable = true.obs;

  BaseApiService apiService = NetworkApiServices();

  Rx<bool> clickVariable = false.obs;

  final _adsController = Get.find<AdsController>();

  Rx<String> appBarTitle = "Home".obs;

  @override
  void onInit() {
    Get.put(SettingsController());
    initializedWebUri();
    initializedRefresh();
    super.onInit();
  }

  initializedWebUri() {
    weburi.value = globalSettingsData?.initialPageUrl ?? '';
  }

  onHomeWebSelected() {
    homeSelected.value = 0;
    selectedTileIndex.value = null;

    appBarTitle.value = globalSettingsData?.initialPageName ?? "";

    changeWebUri(globalSettingsData?.initialPageUrl ?? '');

    clickVariableChange(true);

    if (adNetworkSettings?.interstitialAdOnClickDrawerMenu == 1) {
      _adsController.interstitialAdShow();
    }
  }

  clickVariableChange(bool value) {
    clickVariable.value = value;
    update();
    debugPrint("<<<clickVariable ${clickVariable.value}>>>");
  }

  void changeListTileIndex(int? index, String uri) async {
    if (selectedTileIndex.value != index) {
      if (drawerList[index!].target == "external") {
        Utils.uriLaunch(Uri.parse(drawerList[index].url.toString()));
        if (adNetworkSettings?.interstitialAdOnClickDrawerMenu == 1) {
          _adsController.interstitialAdShow();
        }
      } else {
        homeSelected.value = null;
        selectedTileIndex.value = index;
        appBarTitle.value = drawerList[index].name.toString();

        if (drawerList[index].type == "web url") {
          //This is for when  the user clicks on a web url tile

          changeWebUri(uri);

          //This for ads when ads is show or not

          clickVariableChange(true);

          if (adNetworkSettings?.interstitialAdOnClickDrawerMenu == 1) {
            _adsController.interstitialAdShow();
          }
        } else {
          if (adNetworkSettings?.interstitialAdOnClickDrawerMenu == 1) {
            _adsController.interstitialAdShow();
          }
        }
      }
    }

    update();
  }

  void changeWebUri(String uri) {
    weburi.value = uri;
    update();
  }

  void changeLoadingValue(double progress) {
    loadingValue.value = progress;
  }

  initializedRefresh() {
    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
            settings: PullToRefreshSettings(
              // color: themeController.theme == ThemeMode.light ? primaryColor : whiteColor,
              // backgroundColor: themeController.theme == ThemeMode.light
              //     ? whiteColor
              //     : darkScreenColor,
              color: Colors.white,
              backgroundColor: Colors.black,
            ),
            onRefresh: () async {
              // if (pullToRefreshController != null) {
              //   debugPrint("<<< Theme :: ${themeController.theme} s>>>");
              //   pullToRefreshController?.setBackgroundColor(
              //       themeController.theme == ThemeMode.light ? whiteColor : darkScreenColor);
              //   pullToRefreshController?.setColor(
              //       themeController.theme == ThemeMode.light ? primaryColor : whiteColor);
              //   update();
              // }
              if (defaultTargetPlatform == TargetPlatform.android) {
                inAppWebViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                inAppWebViewController?.loadUrl(
                  urlRequest: URLRequest(
                    url: await inAppWebViewController?.getUrl(),
                  ),
                );
              }
            },
          );
  }

  /* Future<NavigationActionPolicy?> shouldOverrideUrlLoadingFunction(
      InAppWebViewController controller, NavigationAction navigationAction) async {
    String uri = navigationAction.request.url!.toString();

    if (uri.startsWith('tel')) {
      Utils.uriLaunch(Uri.parse(uri));

      return NavigationActionPolicy.CANCEL;
    }
    if (uri.startsWith('sms')) {
      Utils.uriLaunch(Uri.parse(uri));

      return NavigationActionPolicy.CANCEL;
    }
    if (uri.startsWith('mailto')) {
      String? encodeQueryParameters(Map<String, String> params) {
        return params.entries
            .map((MapEntry<String, String> e) =>
                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
            .join('&');
      }

      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: uri,
        query: encodeQueryParameters(<String, String>{
          'subject': 'Example Subject & Symbols are allowed!',
        }),
      );
      try {
        launchUrl(emailLaunchUri);
      } catch (e) {
        debugPrint("Could not launch :: $e");
      }
      return NavigationActionPolicy.CANCEL;
    }

    return NavigationActionPolicy.ALLOW;
  }
 */

  Future<GeolocationPermissionShowPromptResponse?> geoLocationServiceForWebView(
      InAppWebViewController controller, dynamic origin) async {
    var enabled =
        GeolocationPermissionShowPromptResponse(allow: true, retain: true, origin: origin);
    var disabled =
        GeolocationPermissionShowPromptResponse(allow: false, retain: false, origin: origin);

    if (globalSettingsData?.geolocation == 1) {
      if (await Permission.location.request().isGranted) {
        bool serviceEnabled = await Location().serviceEnabled();
        if (serviceEnabled) {
          // await Location().serviceEnabled();
          return enabled;
        } else {
          bool reqEnabled = await Location().requestService();
          await Location().serviceEnabled();
          if (reqEnabled) {
            return enabled;
          } else {
            return disabled;
          }
        }
      } else {
        final locationPer = await Permission.location.request();
        if (locationPer.isGranted) {
          bool serviceEnabled = await Location().serviceEnabled();
          if (serviceEnabled) {
            return enabled;
          } else {
            bool reqEnabled = await Location().requestService();
            await Location().serviceEnabled();
            if (reqEnabled) {
              return enabled;
            } else {
              return disabled;
            }
          }
        } else {
          return disabled;
        }
      }
    } else {
      return disabled;
    }
  }

  setProgress(int newProgress) {
    loadingValue.value = newProgress.toDouble();
  }

  void onWebViewCreated(InAppWebViewController controller) {
    inAppWebViewController = controller;
  }

  Future fetchNavigationData() async {
    var headers = {
      'Authorization': global.apiSecretKey,
    };
    try {
      var response = await apiService.getGetApiResponse(
        url: AppUrl.navigationUrl,
        headers: headers,
      );

      final navigationData = NavigationModel.fromJson(response);
      drawerList.value = navigationData.data!;
    } catch (error) {
      debugPrint("home Error During Commnunication :: $error");
    }
  }

  @override
  void onReady() async {
    await fetchNavigationData();
    super.onReady();
  }
}
