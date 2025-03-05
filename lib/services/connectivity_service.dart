import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../controller/controller.dart';

class ConnectivityService {
  checkConnectivity() {
    Connectivity connectivity = Connectivity();
    initConnectivity(connectivity);
    connectivity.onConnectivityChanged.listen((result) async {
      if (result.contains(ConnectivityResult.none)) {
        Get.find<BottombarController>().isOnlineChange(false);
      } else {
        Get.find<BottombarController>().isOnlineChange(true);
        // Get.find<AdsController>().initializedAd();
      }
    });
  }

  initConnectivity(Connectivity connectivity) async {
    late List<ConnectivityResult> result;
    result = await connectivity.checkConnectivity();
    if (result.contains(ConnectivityResult.none)) {
      Get.find<BottombarController>().isOnlineChange(false);
    } else {
      Get.find<BottombarController>().isOnlineChange(true);
    }
  }
}
