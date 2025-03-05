import 'dart:io';

class AppUrl {
  static String baseUrl = "https://webhorizon.apphorizontechnology.com";
  static String imageUrl = "$baseUrl/storage/";
  static String appSettingsUrl = "$baseUrl/api/v1/app-settings";
  static String navigationUrl = "$baseUrl/api/v1/navigation";
  static String appsListUrl = Platform.isAndroid
      ? "$baseUrl/api/v1/apps_list?platform=Android"
      : "$baseUrl/api/v1/apps_list?platform=iOS";
}
