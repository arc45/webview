import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_horizon/controller/controller.dart';
import 'package:web_horizon/res/theme.dart';
import 'package:web_horizon/res/widget/network_image.dart';

class MoreAppsScreen extends StatelessWidget {
  const MoreAppsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moreAppsController = Get.find<MoreAppsController>();
    final adsController = Get.find<AdsController>();
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        adsController.interstitialAdShow();
      },
      child: Scaffold(
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
            "More apps",
            style: bold18White,
          ),
        ),
        body: moreAppsListContent(moreAppsController),
      ),
    );
  }

  moreAppsListContent(MoreAppsController moreAppsController) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
          horizontal: fixPadding * 2.0, vertical: fixPadding),
      itemCount: moreAppsController.moreAppsList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            moreAppsController.onAppTap(
                moreAppsController.moreAppsList[index].appLink.toString());
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: fixPadding),
            padding: const EdgeInsets.all(fixPadding * 1.5),
            decoration: BoxDecoration(
              color: Get.isDarkMode ? const Color(0xFF232A38) : whiteColor,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: orignalBlackColor.withValues(alpha: 0.2),
                  blurRadius: 6.0,
                )
              ],
            ),
            child: Row(
              children: [
                Container(
                  height: 50.0,
                  width: 50.0,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: whiteColor,
                  ),
                  child: CachedNetworkImageWidget(
                      image: moreAppsController.moreAppsList[index].image
                          .toString()),
                ),
                widthSpace,
                width5Space,
                Expanded(
                  child: Text(
                    moreAppsController.moreAppsList[index].name.toString(),
                    style: Get.theme.textTheme.bodyLarge,
                  ),
                ),
                widthSpace,
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 20.0,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  emptyListContent() {
    return Center(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(fixPadding * 2.0),
        shrinkWrap: true,
        children: [
          Image.asset(
            "assets/images/empty-list.png",
            height: 120.0,
          ),
          const Text(
            "Empty list!",
            style: bold20Grey,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
