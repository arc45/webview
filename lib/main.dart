import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:web_horizon/screens/screens.dart';
import 'package:web_horizon/services/get_storage_service.dart';
import 'package:web_horizon/services/notification_service.dart';
import 'package:web_horizon/res/theme.dart';
import 'package:web_horizon/utils/global.dart' as global;
import 'package:web_horizon/utils/routes/routes.dart';
import 'controller/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await GSService().init();
  await initializeFirebase();

  NotificationService().initializedNotification();

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }

  runApp(const MyApp());
}

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: Platform.isAndroid
        ? const FirebaseOptions(
            apiKey: 'AIzaSyB3RFzyEVfDzxBMw3MgQpyOuyPendVluy0',
            appId: '1:771594409433:android:da2f8112d811e4cb9cf5c8',
            messagingSenderId: '771594409433',
            projectId: 'webhorizon-49d00',
          )
        : null,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: global.appName,
        themeMode: themeController.theme,
        theme: MyAppThemes.lightTheme,
        darkTheme: MyAppThemes.darkTheme,
        home: const SplashScreen(),
        getPages: Routes.generateRoutes(),
        unknownRoute: GetPage(
          name: '/UnkonwnRoute',
          page: () => const UnknownRouteScreen(),
        ),
      ),
    );
  }
}
