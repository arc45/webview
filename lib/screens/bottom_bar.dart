import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:iconify_flutter_plus/icons/carbon.dart';
import 'package:web_horizon/controller/controller.dart';
import 'package:web_horizon/model/app_settings.dart';
import 'package:web_horizon/res/widget/network_image.dart';
import 'package:web_horizon/screens/noConnection/no_connection.dart';
import 'package:web_horizon/screens/screens.dart';
import 'package:web_horizon/res/theme.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:web_horizon/utils/global.dart' as global;
import 'package:web_horizon/utils/utils.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  DateTime? backPressTime;

  final pages = const [
    HomeScreen(),
    SettingsScreen(),
  ];

  // Global get global => Global();
  AppSettingsData? get globalSettingsData => global.appSettings;
  AdNetwork? get adNetworkSettings => globalSettingsData?.adNetworks?[0];

  // static Global global = Global();

  // static AppSettingsData? globalSettingsData = global.appSettings;
  // static AdNetwork? adNetworkSettings = globalSettingsData!.adNetworks?[0];

  final bottombarController = Get.put(BottombarController());

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemStatusBarContrastEnforced: true),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (bottombarController.isOnline.value == true) {
            if (homeController.selectedTileIndex.value == null &&
                bottombarController.selectedIndex.value == 0) {
              if (await homeController.inAppWebViewController!.canGoBack()) {
                homeController.inAppWebViewController!.goBack();
              } else {
                bool backStatus = onPopscope();
                if (backStatus) {
                  exit(0);
                }
              }
            } else if (bottombarController.selectedIndex.value == 0 &&
                homeController
                        .drawerList[homeController.selectedTileIndex.value!]
                        .type ==
                    "web url" &&
                await homeController.inAppWebViewController!.canGoBack()) {
              homeController.inAppWebViewController!.goBack();
            } else {
              bool backStatus = onPopscope();
              if (backStatus) {
                exit(0);
              }
            }
          }
        },
        child: Obx(
          () {
            return bottombarController.isOnline.value == true
                ? Scaffold(
                    drawerEnableOpenDragGesture: false,
                    endDrawerEnableOpenDragGesture: false,
                    onDrawerChanged: (isOpened) {
                      if (isOpened) {
                        if (adNetworkSettings
                                ?.interstitialAdOnClickDrawerMenu ==
                            1) {
                          Get.find<AdsController>().interstitialAdShow();
                        }
                      }
                    },
                    drawer: drawer(homeController),
                    body: IndexedStack(
                      sizing: StackFit.expand,
                      index: bottombarController.selectedIndex.value,
                      children: pages,
                    ),
                    bottomNavigationBar:
                        bottomNavigationBar(bottombarController),
                  )
                : const NoConnectionScreen();
          },
        ),
      ),
    );
  }

  bottomNavigationBar(BottombarController bottombarController) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        bannerAd(),
        Container(
          decoration: BoxDecoration(
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                color: orignalBlackColor.withValues(alpha: 0.2),
                blurRadius: 6.0,
              )
            ],
          ),
          child: Theme(
            data: Get.theme.copyWith(splashColor: Colors.transparent),
            child: Obx(
              () => BottomNavigationBar(
                showSelectedLabels: true,
                showUnselectedLabels: true,
                backgroundColor: primaryColor,
                elevation: 0.0,
                currentIndex: bottombarController.selectedIndex.value,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white.withValues(alpha: 0.4),
                onTap: (index) {
                  bottombarController.changeIndex(index);
                },
                selectedLabelStyle: semibold14White,
                unselectedLabelStyle: semibold14White.copyWith(
                  color: whiteColor.withValues(alpha: 0.4),
                ),
                items: [
                  itemWidget(Carbon.home, "Home"),
                  itemWidget(Carbon.settings, "Settings"),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  drawer(HomeController homeController) {
    return Drawer(
      shape: const RoundedRectangleBorder(),
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: primaryColor),
            child: Center(
              child: SizedBox(
                height: 80.0,
                child: Image.asset(
                  "assets/images/app_logo.png",
                  color: whiteColor,
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () {
                return ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(
                    top: fixPadding,
                    bottom: fixPadding,
                    right: fixPadding * 2.0,
                  ),
                  children: [
                    homeListTile(homeController),
                    Column(
                      children: List.generate(
                        homeController.drawerList.length,
                        (index) {
                          return ListTile(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(40.0),
                              ),
                            ),
                            selected:
                                homeController.selectedTileIndex.value == index,
                            selectedTileColor: primaryColor,
                            onTap: () async {
                              homeController.changeListTileIndex(
                                index,
                                homeController.drawerList[index].darkUrl != null
                                    ? Get.isDarkMode
                                        ? homeController
                                            .drawerList[index].darkUrl
                                            .toString()
                                        : homeController.drawerList[index].url
                                            .toString()
                                    : homeController.drawerList[index].url
                                        .toString(),
                              );

                              Get.back();
                            },
                            leading: Container(
                              height: 30.0,
                              width: 30.0,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: orignalBlackColor.withValues(
                                        alpha: 0.1),
                                    blurRadius: 6.0,
                                  )
                                ],
                              ),
                              child: CachedNetworkImageWidget(
                                  image: homeController.drawerList[index].image
                                      .toString()),
                            ),
                            title: Text(
                              homeController.drawerList[index].name.toString(),
                              style: homeController.selectedTileIndex.value ==
                                      index
                                  ? bold17White
                                  : Get.isDarkMode
                                      ? bold17White
                                      : bold17Black,
                            ),
                          );
                        },
                      ),
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  homeListTile(HomeController homeController) {
    return ListTile(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(40.0),
        ),
      ),
      selected: homeController.homeSelected.value == 0,
      selectedTileColor: primaryColor,
      onTap: () async {
        if (homeController.homeSelected.value != 0) {
          homeController.onHomeWebSelected();
        }
        Get.back();
      },
      leading: Container(
        height: 30.0,
        width: 30.0,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: orignalBlackColor.withValues(alpha: 0.1),
              blurRadius: 6.0,
            )
          ],
        ),
        child: CachedNetworkImageWidget(
          image: globalSettingsData?.initialPageImage ?? '',
        ),
      ),
      title: Text(
        globalSettingsData?.initialPageName ?? '',
        style: homeController.homeSelected.value == 0
            ? bold17White
            : Get.isDarkMode
                ? bold17White
                : bold17Black,
      ),
    );
  }

  itemWidget(String icon, String label) {
    return BottomNavigationBarItem(
      icon: Iconify(
        icon,
        color: whiteColor.withValues(alpha: 0.4),
        size: 24.0,
      ),
      activeIcon: Iconify(
        icon,
        color: whiteColor,
        size: 24.0,
      ),
      label: label,
    );
  }

  bannerAd() {
    return GetBuilder<AdsController>(builder: (adsController) {
      if (adNetworkSettings?.adStatus == 1 &&
          adNetworkSettings?.bannerAdOnBottomNavigation == 1) {
        return adNetworkSettings?.primaryAdNetwork == "AdMob"
            ? adsController.bannerAd == null
                ? const SizedBox()
                : SizedBox(
                    width: Get.width,
                    // height: adsController.bannerAd?.size.height.toDouble(),
                    height: 50,
                    child: AdWidget(
                      ad: adsController.bannerAd!,
                    ),
                  )
            : SizedBox(
                width: Get.width,
                child: adsController.metaBannerAdShow(),
              );
      } else {
        return const SizedBox();
      }
    });
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
