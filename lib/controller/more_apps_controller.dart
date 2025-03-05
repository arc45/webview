import 'package:get/get.dart';
import 'package:web_horizon/controller/ads_controller.dart';
import 'package:web_horizon/model/app_settings.dart';
import 'package:web_horizon/model/more_apps_model.dart';
import 'package:web_horizon/res/app_url.dart';
import 'package:web_horizon/services/apiService/base_api_services.dart';
import 'package:web_horizon/services/apiService/network_api_services.dart';
import 'package:web_horizon/utils/global.dart' as global;
import 'package:web_horizon/utils/utils.dart';

class MoreAppsController extends GetxController {
  BaseApiService apiService = NetworkApiServices();

  AppSettingsData? get globalSettingsData => global.appSettings;
  AdNetwork? get adNetworkSettings => globalSettingsData?.adNetworks?[0];

  var moreAppsList = <MoreAppsData>[].obs;

  Future fetchNavigationData() async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': global.apiSecretKey,
    };
    try {
      var response = await apiService.getGetApiResponse(
        url: AppUrl.appsListUrl,
        headers: headers,
      );
      final appsListData = MoreAppsModel.fromJson(response);
      moreAppsList.value = appsListData.data!;
    } catch (error) {
      // debugPrint("more apps e :: $error");
      // debugPrint("more appes Error During Commnunication :: $error");
      return;
    }
  }

  // onAppTap(String uri) {
  //   final homeController = Get.find<HomeController>();
  //   final bottombarController = Get.find<BottombarController>();

  //   homeController.selectedTileIndex.value = null;
  //   homeController.homeSelected.value = null;

  //   bottombarController.selectedIndex.value = 0;
  //   homeController.changeWebUri(uri);

  //   if (Global.interstitialAdOnClickWebPageLink == 0) {
  //     Get.find<AdsController>().interstitialAdShow();
  //   }

  //   Get.until((route) => Get.currentRoute == RoutesName.bottombar);
  // }

  onAppTap(String uri) {
    if (adNetworkSettings?.interstitialAdOnClickWebPageLink == 0) {
      Get.find<AdsController>().interstitialAdShow();
    }

    Utils.uriLaunch(Uri.parse(uri));
  }

  @override
  void onReady() {
    fetchNavigationData();
    super.onReady();
  }
}
