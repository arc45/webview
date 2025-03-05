import 'package:get/get.dart';
import 'package:web_horizon/controller/controller.dart';
import 'package:web_horizon/services/connectivity_service.dart';

class BottombarController extends GetxController {
  bool get _isRegistered => Get.isRegistered<AdsController>();

  @override
  void onInit() async {
    Get.put(HomeController());
    Get.put(MoreAppsController());
    if (_isRegistered) {
      await Get.find<AdsController>().appOpenAdLoadAndShowOnStart();
    }
    super.onInit();
  }

  @override
  void onReady() async {
    ConnectivityService().checkConnectivity();
    super.onReady();
  }

  var selectedIndex = 0.obs;

  var isOnline = true.obs;

  void changeIndex(int index) {
    if (selectedIndex.value != index) {
      selectedIndex.value = index;
      if (_isRegistered) {
        Get.find<AdsController>().interstitialAdShow();
      }
    }

    final homeController = Get.find<HomeController>();

    if (homeController.selectedTileIndex.value != null &&
        homeController
                .drawerList[homeController.selectedTileIndex.value!].type ==
            'web url') {
      if (index == 0) {
        homeController.inAppWebViewController?.resume();
      } else {
        homeController.inAppWebViewController?.pause();
      }
    }
  }

  void isOnlineChange(bool value) {
    isOnline.value = value;
  }
}
