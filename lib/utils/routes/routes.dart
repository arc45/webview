import 'package:get/get.dart';
import 'package:web_horizon/screens/screens.dart';
import 'package:web_horizon/utils/routes/routes_name.dart';

class Routes {
  static List<GetPage<dynamic>>? generateRoutes() {
    return [
      MyRoutes(
        routeName: RoutesName.splash,
        routePage: () => const SplashScreen(),
      ),
      MyRoutes(
        routeName: RoutesName.bottombar,
        routePage: () => const BottomBar(),
      ),
      MyRoutes(
        routeName: RoutesName.privacyPolicy,
        routePage: () => const PrivacyPolicyScreen(),
      ),
      MyRoutes(
        routeName: RoutesName.about,
        routePage: () => const AboutUsScreen(),
      ),
      MyRoutes(
        routeName: RoutesName.moreApps,
        routePage: () => const MoreAppsScreen(),
      ),
    ];
  }
}

class MyRoutes<T> extends GetPage<T> {
  final String routeName;
  final GetPageBuilder routePage;
  final Duration? routeTransitionDuration;
  final Transition? routeTransition;
  final bool fullScreenDialog;

  MyRoutes({
    required this.routeName,
    required this.routePage,
    this.routeTransitionDuration,
    this.routeTransition = Transition.rightToLeft,
    this.fullScreenDialog = false,
  }) : super(
          name: routeName,
          page: routePage,
          transition: routeTransition,
          transitionDuration:
              routeTransitionDuration ?? const Duration(milliseconds: 200),
          fullscreenDialog: fullScreenDialog,
        );
}
