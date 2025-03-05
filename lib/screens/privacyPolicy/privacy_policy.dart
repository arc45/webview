import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_horizon/controller/ads_controller.dart';
import 'package:web_horizon/model/app_settings.dart';
import 'package:web_horizon/res/widget/html_view.dart';
import 'package:web_horizon/res/theme.dart';
import 'package:web_horizon/utils/global.dart' as global;

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  // static Global global = Global();

  // static AppSettingsData? globalSettingsData = global.appSettings;

  // Global get global => Global();
  AppSettingsData? get globalSettingsData => global.appSettings;

  @override
  Widget build(BuildContext context) {
    final adsController = Get.find<AdsController>();
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        adsController.interstitialAdShow();
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: primaryColor,
          centerTitle: false,
          elevation: 0.0,
          titleSpacing: 0.0,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: whiteColor,
            ),
          ),
          title: const Text(
            "Privacy policy",
            style: bold18White,
          ),
        ),
        body: globalSettingsData?.privacyPolicy == null
            ? emptyPrivacyPolicy()
            : HtmlView(
                html: globalSettingsData?.privacyPolicy ?? '',
              ),
      ),
    );
  }

  emptyPrivacyPolicy() {
    return Center(
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(fixPadding * 2.0),
        children: [
          Center(
            child: Image.asset(
              "assets/images/privacy_policy.png",
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          height5Space,
          const Text(
            "Nothing to see here.",
            style: semibold16OrignalBlack,
            textAlign: TextAlign.center,
          ),
          heightSpace,
          heightSpace,
          heightSpace,
        ],
      ),
    );
  }
}
