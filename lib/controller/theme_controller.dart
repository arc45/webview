import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_horizon/services/get_storage_service.dart';

class ThemeController extends GetxController {
  final GSService _gsService = GSService();

  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  bool _loadThemeFromBox() => _gsService.read(GSKeys.isDarkMode) ?? false;

  _saveThemeToBox(bool isDarkMode) => _gsService.write(GSKeys.isDarkMode, isDarkMode);

  void switchTheme() {
    // final homeController = Get.find<HomeController>();

    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
    // if (homeController.pullToRefreshController != null) {
    //   debugPrint("<<< Theme :: $theme s>>>");
    // homeController.pullToRefreshController
    //     ?.setBackgroundColor(theme == ThemeMode.light ? whiteColor : darkScreenColor);
    // homeController.pullToRefreshController
    //     ?.setColor(theme == ThemeMode.light ? primaryColor : whiteColor);
    // update();
    // }
    update();
  }
}
