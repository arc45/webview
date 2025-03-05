import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:web_horizon/res/theme.dart';

import '../controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: primaryColor,
        body: Center(
          child: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(fixPadding * 2.0),
            children: [
              Center(
                child: SizedBox(
                  height: 150.0,
                  width: 150.0,
                  child: Image.asset(
                    "assets/images/app_logo.png",
                    color: whiteColor,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
