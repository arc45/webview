import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:web_horizon/model/app_settings.dart';
import 'package:web_horizon/res/theme.dart';
import 'package:web_horizon/res/widget/html_view.dart';
import 'package:web_horizon/utils/global.dart' as global;
import '../../controller/controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  TextEditingController urlController = TextEditingController();

  bool isLoadWeb = false;

  AdNetwork? get adNetworkSettings => global.appSettings?.adNetworks?[0];
  bool get appBarVisibility => global.appSettings?.appBarVisibility == 1;
  @override
  void dispose() {
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController());
    final adsController = Get.find<AdsController>();

    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: !appBarVisibility
            ? null
            : AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: primaryColor,
                centerTitle: true,
                elevation: 0.0,
                titleSpacing: 20.0,
                title: Obx(() {
                  return Text(
                    homeController.appBarTitle.value,
                    style: bold20White,
                  );
                }),
                leading: IconButton(
                  onPressed: () async {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(
                    Icons.menu,
                    color: whiteColor,
                  ),
                ),
              ),
        body: SafeArea(
          child: Obx(() {
            if (homeController.selectedTileIndex.value == null) {
              return webView(homeController, adsController);
            } else {
              return homeController.drawerList[homeController.selectedTileIndex.value!].type ==
                      "html tag"
                  ? Container(
                      color: whiteColor,
                      alignment: Alignment.topCenter,
                      child: HtmlView(
                        html: homeController
                            .drawerList[homeController.selectedTileIndex.value!].htmlDetails
                            .toString(),
                      ),
                    )
                  : webView(homeController, adsController);
            }
          }),
        ),
      ),
    );
  }

  Widget webView(HomeController homeController, AdsController adsController) {
    return Column(
      children: [
        loadingIndicator(homeController),
        inAppwebViewWidget(homeController, adsController),
      ],
    );
  }

  inAppwebViewWidget(HomeController homeController, AdsController adsController) {
    return Expanded(
      child: Obx(() {
        return InAppWebView(
          key: Key(homeController.weburi.value),
          onWebViewCreated: homeController.onWebViewCreated,
          preventGestureDelay: true,
          onProgressChanged: (InAppWebViewController inAppWebViewController, int progress) {
            homeController.setProgress(progress);
            if (progress == 100) {
              homeController.pullToRefreshController?.endRefreshing();
            }
          },
          initialSettings: InAppWebViewSettings(
            // useOnNavigationResponse: true,
            disableDefaultErrorPage: true,
            javaScriptEnabled: true,
            // useShouldOverrideUrlLoading: true,
            javaScriptCanOpenWindowsAutomatically: true,
            useHybridComposition: true,
            allowsInlineMediaPlayback: true,
            clearCache: true,
            mediaPlaybackRequiresUserGesture: false,
            underPageBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
            supportZoom: false,
            isInspectable: true,
          ),
          pullToRefreshController: homeController.pullToRefreshController,
          onReceivedError: (controller, request, error) {
            homeController.pullToRefreshController?.endRefreshing();
            debugPrint('''
                  Page resource error:::
                  description::: ${error.description}
              ''');
          },
          onUpdateVisitedHistory: (controller, url, androidIsReload) {
            if (adNetworkSettings?.interstitialAdOnClickWebPageLink == 1) {
              if (url != null) {
                if (url.toString() != urlController.text) {
                  if (homeController.clickVariable.value == false) {
                    debugPrint(" >>>>>>>>>>>>>>>>>>${url.toString()}<<<<<<<<<<<<<<<<<<<");
                    debugPrint(" >>>>>>>>>>>>>>>>>>count<<<<<<<<<<<<<<<<<<<");
                    adsController.interstitialAdShow();
                  } else {
                    homeController.clickVariableChange(false);
                  }
                }
                urlController.text = url.toString();
              }
            }
          },
          // shouldOverrideUrlLoading: homeController.shouldOverrideUrlLoadingFunction,
          // shouldOverrideUrlLoading: (controller, action) async {
          //   return NavigationActionPolicy.ALLOW;
          // },
          onGeolocationPermissionsShowPrompt: homeController.geoLocationServiceForWebView,
          initialUrlRequest: URLRequest(
            url: WebUri.uri(
              Uri.parse(homeController.weburi.value),
            ),
          ),
        );
      }),
    );
  }

  onUpdateVisitedHistory(HomeController homeController, AdsController adsController, WebUri? url) {
    if (adNetworkSettings?.interstitialAdOnClickWebPageLink == 1) {
      if (url != null) {
        if (url.toString() != urlController.text) {
          if (homeController.clickVariable.value == false) {
            debugPrint(" >>>>>>>>>>>>>>>>>>${url.toString()}<<<<<<<<<<<<<<<<<<<");
            debugPrint(" >>>>>>>>>>>>>>>>>>count<<<<<<<<<<<<<<<<<<<");
            adsController.interstitialAdShow();
          } else {
            homeController.clickVariableChange(false);
          }
        }
        urlController.text = url.toString();
      }
    }
  }

  loadingIndicator(HomeController controller) {
    return controller.loadingValue.value >= 100
        ? const SizedBox()
        : const LinearProgressIndicator(
            color: primaryColor,
            backgroundColor: whiteColor,
          );
  }
}
