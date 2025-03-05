class AppSettingsModel {
  final bool? status;
  final String? message;
  final List<AppSettingsData>? data;

  AppSettingsModel({
    this.status,
    this.message,
    this.data,
  });

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) => AppSettingsModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<AppSettingsData>.from(json["data"]!.map((x) => AppSettingsData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class AppSettingsData {
  final int? id;
  final num androidAppVersionCode;
  final num iosAppVersionCode;
  final int? androidUpdatePopup;
  final int? appBarVisibility;
  final int? iosUpdatePopup;
  final int? androidForceUpdate;
  final int? iosForceUpdate;
  final String? androidAppLink;
  final String? iosAppLink;
  final int? geolocation;
  final int? webviewCache;
  // final String apiSecretKey;
  final String? initialPageUrl;
  final String? initialPageName;
  final String? initialPageImage;
  final dynamic privacyPolicy;
  final dynamic aboutUs;
  final dynamic updateAppMessage;
  final dynamic adStatus;
  final List<AdNetwork>? adNetworks;

  AppSettingsData({
    this.id,
    this.androidAppVersionCode = 0.0,
    this.iosAppVersionCode = 0.0,
    this.androidUpdatePopup,
    this.iosUpdatePopup,
    this.androidForceUpdate,
    this.iosForceUpdate,
    this.androidAppLink,
    this.iosAppLink,
    this.geolocation,
    this.webviewCache,
    // this.apiSecretKey = "",
    this.initialPageUrl,
    this.initialPageName,
    this.initialPageImage,
    this.privacyPolicy,
    this.aboutUs,
    this.updateAppMessage,
    this.adStatus,
    this.adNetworks,
    this.appBarVisibility,
  });

  factory AppSettingsData.fromJson(Map<String, dynamic> json) => AppSettingsData(
        id: json["id"],
        appBarVisibility: json["AppBarVisibility"],
        androidAppVersionCode: json["android_app_version_code"],
        iosAppVersionCode: json["ios_app_version_code"]?.toDouble(),
        androidUpdatePopup: json["android_update_popup"],
        iosUpdatePopup: json["ios_update_popup"],
        androidForceUpdate: json["android_force_update"],
        iosForceUpdate: json["ios_force_update"],
        androidAppLink: json["android_app_link"],
        iosAppLink: json["ios_app_link"],
        geolocation: json["geolocation"],
        webviewCache: json["webview_cache"],
        // apiSecretKey: json["api_secret_key"],
        initialPageUrl: json["Initial_page_url"],
        initialPageImage: json["Initial_page_image"],
        initialPageName: json["Initial_page_name"],
        privacyPolicy: json["privacy_policy"],
        aboutUs: json["about_us"],
        updateAppMessage: json["update_app_message"],
        adStatus: json["ad_status"],
        adNetworks: json["ad_networks"] == null
            ? []
            : List<AdNetwork>.from(json["ad_networks"]!.map((x) => AdNetwork.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "android_app_version_code": androidAppVersionCode,
        "ios_app_version_code": iosAppVersionCode,
        "android_update_popup": androidUpdatePopup,
        "ios_update_popup": iosUpdatePopup,
        "android_force_update": androidForceUpdate,
        "ios_force_update": iosForceUpdate,
        "android_app_link": androidAppLink,
        "ios_app_link": iosAppLink,
        "geolocation": geolocation,
        "webview_cache": webviewCache,
        // "api_secret_key": apiSecretKey,
        "Initial_page_url": initialPageUrl,
        "Initial_page_image": initialPageImage,
        "Initial_page_name": initialPageName,
        "privacy_policy": privacyPolicy,
        "about_us": aboutUs,
        "update_app_message": updateAppMessage,
        "ad_status": adStatus,
        "AppBarVisibility": appBarVisibility,
        "ad_networks":
            adNetworks == null ? [] : List<dynamic>.from(adNetworks!.map((x) => x.toJson())),
      };
}

class AdNetwork {
  final int? id;
  final int? adStatus;
  final int adCount;
  final String? primaryAdNetwork;
  final String? adMobAndroidAppId;
  final String? adMobIosAppId;
  final String? adMobAndroidBannerAdUnitId;
  final String? adMobIosBannerAdUnitId;
  final String? adMobAndroidInterstitialAdUnitId;
  final String? adMobIosInterstitialAdUnitId;
  final String? adMobAndroidAppOpenAdUnitId;
  final String? adMobIosAppOpenAdUnitId;
  final String? audianceNetworkBannerPlacementName;
  final String? audianceNetworkInterstitialPlacementName;
  final int? bannerAdOnBottomNavigation;
  final int? interstitialAdOnClickDrawerMenu;
  final int? interstitialAdOnClickWebPageLink;
  final int? appOpenAdOnStart;
  final int? appOpenAdOnResume;

  AdNetwork({
    this.id,
    this.adStatus,
    this.adCount = 0,
    this.primaryAdNetwork,
    this.adMobAndroidAppId,
    this.adMobIosAppId,
    this.adMobAndroidBannerAdUnitId,
    this.adMobIosBannerAdUnitId,
    this.adMobAndroidInterstitialAdUnitId,
    this.adMobIosInterstitialAdUnitId,
    this.adMobAndroidAppOpenAdUnitId,
    this.adMobIosAppOpenAdUnitId,
    this.audianceNetworkBannerPlacementName,
    this.audianceNetworkInterstitialPlacementName,
    this.bannerAdOnBottomNavigation,
    this.interstitialAdOnClickDrawerMenu,
    this.interstitialAdOnClickWebPageLink,
    this.appOpenAdOnStart,
    this.appOpenAdOnResume,
  });

  factory AdNetwork.fromJson(Map<String, dynamic> json) => AdNetwork(
        id: json["id"],
        adStatus: json["ad_status"],
        adCount: json["ad_count"],
        primaryAdNetwork: json["primary_ad_network"],
        adMobAndroidAppId: json["AdMob_android_app_id"],
        adMobIosAppId: json["AdMob_ios_app_id"],
        adMobAndroidBannerAdUnitId: json["AdMob_android_banner_ad_unit_id"],
        adMobIosBannerAdUnitId: json["AdMob_ios_banner_ad_unit_id"],
        adMobAndroidInterstitialAdUnitId: json["AdMob_android_interstitial_ad_unit_id"],
        adMobIosInterstitialAdUnitId: json["AdMob_ios_interstitial_ad_unit_id"],
        adMobAndroidAppOpenAdUnitId: json["AdMob_android_app_open_ad_unit_id"],
        adMobIosAppOpenAdUnitId: json["AdMob_ios_app_open_ad_unit_id"],
        audianceNetworkBannerPlacementName: json["audiance_network_banner_placement_name"],
        audianceNetworkInterstitialPlacementName:
            json["audiance_network_interstitial_placement_name"],
        bannerAdOnBottomNavigation: json["banner_ad_on_bottom_navigation"],
        interstitialAdOnClickDrawerMenu: json["interstitial_ad_on_click_drawer_menu"],
        interstitialAdOnClickWebPageLink: json["interstitial_ad_on_click_web_page_link"],
        appOpenAdOnStart: json["app_open_ad_on_start"],
        appOpenAdOnResume: json["app_open_ad_on_resume"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ad_status": adStatus,
        "ad_count": adCount,
        "primary_ad_network": primaryAdNetwork,
        "AdMob_android_app_id": adMobAndroidAppId,
        "AdMob_ios_app_id": adMobIosAppId,
        "AdMob_android_banner_ad_unit_id": adMobAndroidBannerAdUnitId,
        "AdMob_ios_banner_ad_unit_id": adMobIosBannerAdUnitId,
        "AdMob_android_interstitial_ad_unit_id": adMobAndroidInterstitialAdUnitId,
        "AdMob_ios_interstitial_ad_unit_id": adMobIosInterstitialAdUnitId,
        "AdMob_android_app_open_ad_unit_id": adMobAndroidAppOpenAdUnitId,
        "AdMob_ios_app_open_ad_unit_id": adMobIosAppOpenAdUnitId,
        "audiance_network_banner_placement_name": audianceNetworkBannerPlacementName,
        "audiance_network_interstitial_placement_name": audianceNetworkInterstitialPlacementName,
        "banner_ad_on_bottom_navigation": bannerAdOnBottomNavigation,
        "interstitial_ad_on_click_drawer_menu": interstitialAdOnClickDrawerMenu,
        "interstitial_ad_on_click_web_page_link": interstitialAdOnClickWebPageLink,
        "app_open_ad_on_start": appOpenAdOnStart,
        "app_open_ad_on_resume": appOpenAdOnResume,
      };
}
