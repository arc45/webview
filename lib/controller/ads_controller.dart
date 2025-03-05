import 'dart:developer';
import 'dart:io';
import 'package:easy_audience_network/easy_audience_network.dart' as audience_network;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as gma;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:web_horizon/model/app_settings.dart';
import 'package:web_horizon/utils/global.dart' as global;

class AdsController extends GetxController {
  @override
  void onInit() {
    initializedAd();
    appOpenAdShowOnResume();
    super.onInit();
  }

  static AppSettingsData globalSettingsData = global.appSettings!;

  static AdNetwork? adSettingsData = global.appSettings?.adNetworks?[0];

  var clickCount = (adSettingsData?.interstitialAdOnClickWebPageLink == 1 ? -1 : 0).obs;

  String? appOpenAdUnitId = Platform.isAndroid
      ? adSettingsData?.adMobAndroidAppOpenAdUnitId.toString()
      : adSettingsData?.adMobIosAppOpenAdUnitId.toString();

  final String? bannerAdUnitId = Platform.isAndroid
      ? adSettingsData?.adMobAndroidBannerAdUnitId.toString()
      : adSettingsData?.adMobIosBannerAdUnitId.toString();

  final String? interstitialAdUnitId = Platform.isAndroid
      ? adSettingsData?.adMobAndroidInterstitialAdUnitId.toString()
      : adSettingsData?.adMobIosInterstitialAdUnitId.toString();

  gma.AppOpenAd? myAppOpenAd;

  gma.BannerAd? bannerAd;

  gma.InterstitialAd? interstitialAd;
  audience_network.InterstitialAd? metaInterstitialAd;

  Rx<bool> bannerAdIsLoaded = false.obs;

  Future<void> metaAdsinit() async {
    debugPrint("<<<< Initialized Meta Ads >>>>");
    audience_network.EasyAudienceNetwork.init(
        // testMode: true,
        );
  }

  initializedAd() {
    if (adSettingsData?.adStatus == 1) {
      if (adSettingsData?.primaryAdNetwork == "AdMob") {
        adMobBannerAdLoad();
        adMobInterstitialAdLoad();
      } else {
        metaAdsinit().then(
          (value) {
            metaInterstitialAdLoad();
          },
        );
      }
    }
  }

  interstitialAdShow() {
    if (adSettingsData?.adStatus == 1 && (adSettingsData?.adCount ?? 0) > 0) {
      clickCount++;

      if ((clickCount % (adSettingsData?.adCount ?? 5)) == 0) {
        adSettingsData?.primaryAdNetwork != "AdMob"
            ? metaInterstitialAd?.show()
            : interstitialAd?.show();
        clickCount.value = 0;
      }

      if (clickCount.value == 0) {
        if (adSettingsData?.primaryAdNetwork == "AdMob") {
          adMobInterstitialAdLoad();
        } else {
          metaInterstitialAdLoad();
        }
      }
      debugPrint('>>>Click count<<< $clickCount');
    }
  }

  appOpenAdShowOnResume() {
    if (adSettingsData?.adStatus == 1 &&
        adSettingsData?.appOpenAdOnResume == 1 &&
        adSettingsData?.primaryAdNetwork == "AdMob") {
      AppLifecycleListener(
        onPause: () {
          appOpenAdLoad();
        },
        onStateChange: (value) {
          debugPrint("<<<Value ::  $value >>>");
        },
        onShow: () {
          if (myAppOpenAd != null) {
            myAppOpenAd!.show();

            myAppOpenAd?.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                myAppOpenAd = null;
                update();
                appOpenAdLoad();
              },
            );
          }
        },
      );
    }
  }

  appOpenAdLoad() async {
    if (myAppOpenAd == null) {
      await gma.AppOpenAd.load(
        adUnitId: appOpenAdUnitId ?? "", //Your ad Id from admob
        request: const gma.AdRequest(),
        adLoadCallback: gma.AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            myAppOpenAd = ad;
            debugPrint("<<<AppopenAd loaded : $ad>>>");
          },
          onAdFailedToLoad: (error) {
            debugPrint("<<<AppopenAd Failed to load : $error>>>");
          },
        ),
      );
    }
  }

  appOpenAdLoadAndShowOnStart() async {
    if (adSettingsData?.adStatus == 1 &&
        adSettingsData?.appOpenAdOnStart == 1 &&
        adSettingsData?.primaryAdNetwork == "AdMob") {
      if (myAppOpenAd == null) {
        await gma.AppOpenAd.load(
          adUnitId: appOpenAdUnitId ?? '', //Your ad Id from admob
          request: const gma.AdRequest(),
          adLoadCallback: gma.AppOpenAdLoadCallback(
            onAdLoaded: (ad) async {
              myAppOpenAd = ad;
              if (myAppOpenAd != null) {
                await myAppOpenAd!.show().then(
                  (value) {
                    myAppOpenAd?.fullScreenContentCallback = FullScreenContentCallback(
                      onAdDismissedFullScreenContent: (ad) {
                        myAppOpenAd = null;
                        update();
                        appOpenAdLoad();
                      },
                    );
                  },
                );
              }
              debugPrint("AppopenAd loaded : $ad");
            },
            onAdFailedToLoad: (error) {
              debugPrint("AppopenAd Failed to load : $error");
            },
          ),
        );
        return Future.value();
      }
    }
  }

  void adMobBannerAdLoad() async {
    if (bannerAd == null) {
      bannerAdIsLoaded.value = true;

      final gma.AnchoredAdaptiveBannerAdSize? adSize =
          await gma.AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(Get.width.truncate());
      final adBanner = gma.BannerAd(
        size: adSize!,
        adUnitId: bannerAdUnitId ?? '',
        request: const gma.AdRequest(),
        listener: gma.BannerAdListener(
          onAdLoaded: (gma.Ad ad) {
            debugPrint('$ad BannerAd loaded:');
            bannerAd = ad as gma.BannerAd;
            bannerAdIsLoaded.value = false;
            update();
          },
          onAdFailedToLoad: (ad, error) {
            bannerAdIsLoaded.value = false;
            debugPrint("Ad Failed to load ::: $error");
          },
        ),
      );
      adBanner.load();
      update();
    }
  }

  void adMobInterstitialAdLoad() {
    gma.InterstitialAd.load(
      adUnitId: interstitialAdUnitId ?? '',
      request: const gma.AdRequest(),
      adLoadCallback: gma.InterstitialAdLoadCallback(
        // Called when an ad is successfully received.
        onAdLoaded: (gma.InterstitialAd ad) {
          log('<<<<$ad loaded.>>>');
          // Keep a reference to the ad so you can show it later.
          interstitialAd = ad;
          update();
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (gma.LoadAdError error) {
          interstitialAd?.dispose();
          log('<<<<InterstitialAd failed to load: $error>>>');
        },
      ),
    );
  }

  void metaInterstitialAdLoad() {
    metaInterstitialAd = audience_network.InterstitialAd(
        adSettingsData?.audianceNetworkInterstitialPlacementName ?? '');
    metaInterstitialAd?.listener = audience_network.InterstitialAdListener(
      onLoaded: () {
        debugPrint('<<<Interstitial Loaded>>>');
      },
      onDismissed: () {
        debugPrint('<<<Interstitial dismissed>>>');
      },
      onError: (code, message) {
        debugPrint("<<<onError :: $message>>>");
      },
    );
    metaInterstitialAd?.load();
  }

  metaBannerAdShow() {
    return audience_network.BannerAd(
      placementId: adSettingsData?.audianceNetworkBannerPlacementName ?? '',
      bannerSize: audience_network.BannerSize(width: Get.width.toInt(), height: 50),
      listener: audience_network.BannerAdListener(
        onError: (code, message) => debugPrint('<<< Ad error ::: $message $code >>>'),
        onLoaded: () => debugPrint('<<< Ad loaded >>>'),
        onClicked: () => debugPrint('<<< Ad clicked >>>'),
        onLoggingImpression: () => debugPrint('<<< Ad logging impression >>>'),
      ),
    );
  }
}
