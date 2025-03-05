import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_horizon/res/theme.dart';
import 'package:web_horizon/utils/utils.dart';

class NoConnectionScreen extends StatefulWidget {
  const NoConnectionScreen({super.key});

  @override
  State<NoConnectionScreen> createState() => _NoConnectionScreenState();
}

class _NoConnectionScreenState extends State<NoConnectionScreen> {
  DateTime? backPressTime;

  @override
  void initState() {
    super.initState();
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        bool backStatus = onPopscope();
        if (backStatus) {
          exit(0);
        }
      },
      child: Scaffold(
        body: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(fixPadding * 2.0),
            physics: const BouncingScrollPhysics(),
            children: [
              Center(
                child: Image.asset(
                  "assets/images/no-internet-connection.png",
                  height: 150.0,
                  fit: BoxFit.cover,
                ),
              ),
              const Text(
                'No internet connection found.Check your connection or try again',
                style: bold17Grey,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  onPopscope() {
    DateTime now = DateTime.now();
    if (backPressTime == null ||
        now.difference(backPressTime!) >= const Duration(seconds: 2)) {
      backPressTime = now;
      Utils.snackBar(
          context: Get.context!, messageText: "Press back once again to exit");
      return false;
    } else {
      return true;
    }
  }
}
