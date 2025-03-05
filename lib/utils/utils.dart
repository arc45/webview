import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../res/theme.dart';

class Utils {
  static snackBar(
      {required BuildContext context, required String messageText}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          messageText,
          style: Get.isDarkMode ? bold15OrignalBlack : bold15White,
        ),
        backgroundColor: Get.isDarkMode ? whiteColor : blackColor,
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static Future<void> uriLaunch(Uri url) async {
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    } catch (e) {
      debugPrint("Could not launch :: $e");
    }
  }
}
