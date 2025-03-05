import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF12486B);
const Color whiteColor = Colors.white;
const Color orignalBlackColor = Colors.black;
const Color blackColor = Color(0xFF333333);
const Color greyColor = Colors.grey;
const Color greyD4Color = Color(0xFFD4D4D4);
const Color darkScreenColor = Color(0xFF021526);
const Color darkGeyColor = Color(0xFF2F3640);
// const Color htmlBgColor = Color(0xFFC6C8CE);

const double fixPadding = 10.0;

const SizedBox heightSpace = SizedBox(height: fixPadding);
const SizedBox height5Space = SizedBox(height: 5.0);
const SizedBox widthSpace = SizedBox(width: fixPadding);
const SizedBox width5Space = SizedBox(width: 5.0);

const TextStyle bold20White =
    TextStyle(color: whiteColor, fontSize: 20.0, fontWeight: FontWeight.w700);

const TextStyle bold18White =
    TextStyle(color: whiteColor, fontSize: 18.0, fontWeight: FontWeight.w700);

const TextStyle bold17White =
    TextStyle(color: whiteColor, fontSize: 17.0, fontWeight: FontWeight.w700);

const TextStyle bold16White =
    TextStyle(color: whiteColor, fontSize: 16.0, fontWeight: FontWeight.w700);

const TextStyle bold15White =
    TextStyle(color: whiteColor, fontSize: 15.0, fontWeight: FontWeight.w700);

const TextStyle bold17Primary =
    TextStyle(color: primaryColor, fontSize: 17.0, fontWeight: FontWeight.w700);

const TextStyle bold16Primary =
    TextStyle(color: primaryColor, fontSize: 16.0, fontWeight: FontWeight.w700);

const TextStyle bold18Black =
    TextStyle(color: blackColor, fontSize: 18.0, fontWeight: FontWeight.w700);

const TextStyle bold17Black =
    TextStyle(color: blackColor, fontSize: 17.0, fontWeight: FontWeight.w700);

const TextStyle bold16Black =
    TextStyle(color: blackColor, fontSize: 16.0, fontWeight: FontWeight.w700);

const TextStyle bold15OrignalBlack =
    TextStyle(color: blackColor, fontSize: 15.0, fontWeight: FontWeight.w700);

const TextStyle bold17Grey =
    TextStyle(color: greyColor, fontSize: 17.0, fontWeight: FontWeight.w700);

const TextStyle bold20Grey =
    TextStyle(color: greyColor, fontSize: 20.0, fontWeight: FontWeight.w700);

const TextStyle semibold16Primary =
    TextStyle(color: primaryColor, fontSize: 16.0, fontWeight: FontWeight.w600);

const TextStyle semibold16OrignalBlack = TextStyle(
    color: orignalBlackColor, fontSize: 16.0, fontWeight: FontWeight.w600);

const TextStyle semibold15OrignalBlack = TextStyle(
    color: orignalBlackColor, fontSize: 15.0, fontWeight: FontWeight.w600);

const TextStyle semibold20White =
    TextStyle(color: whiteColor, fontSize: 20.0, fontWeight: FontWeight.w600);

const TextStyle semibold18White =
    TextStyle(color: whiteColor, fontSize: 18.0, fontWeight: FontWeight.w600);

const TextStyle semibold16White =
    TextStyle(color: whiteColor, fontSize: 16.0, fontWeight: FontWeight.w600);

const TextStyle semibold15White =
    TextStyle(color: whiteColor, fontSize: 15.0, fontWeight: FontWeight.w600);

const TextStyle semibold14White =
    TextStyle(color: whiteColor, fontSize: 14.0, fontWeight: FontWeight.w600);

const TextStyle semibold18Grey =
    TextStyle(color: greyColor, fontSize: 18.0, fontWeight: FontWeight.w600);

const TextStyle semibold16Grey =
    TextStyle(color: greyColor, fontSize: 16.0, fontWeight: FontWeight.w600);

// Define a TextTheme for light mode
TextTheme lightTextTheme = const TextTheme(
  bodyLarge: semibold16OrignalBlack,
  bodyMedium: semibold15OrignalBlack,
  titleMedium: bold16Black,
  titleLarge: bold18Black,
);

// Define a TextTheme for dark mode
TextTheme darkTextTheme = const TextTheme(
  bodyLarge: semibold16White,
  bodyMedium: semibold15White,
  titleLarge: bold18White,
  titleMedium: bold16White,
);

class MyAppThemes {
  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      brightness: Brightness.light,
    ),
    textTheme: lightTextTheme,
    iconTheme: const IconThemeData(
      color: orignalBlackColor,
    ),
    drawerTheme: const DrawerThemeData(backgroundColor: whiteColor),
    primaryColor: primaryColor,
    useMaterial3: true,
    fontFamily: 'Mulish',
    scaffoldBackgroundColor: whiteColor,
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.transparent,
    ),
    dialogBackgroundColor: whiteColor,
    dialogTheme: DialogTheme(
      surfaceTintColor: Colors.transparent,
      backgroundColor: whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      surfaceTintColor: Colors.transparent,
      backgroundColor: whiteColor,
      shape: RoundedRectangleBorder(),
    ),
  );

  static final darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      brightness: Brightness.dark,
    ),
    textTheme: darkTextTheme,
    iconTheme: const IconThemeData(
      color: whiteColor,
    ),
    drawerTheme: const DrawerThemeData(backgroundColor: darkScreenColor),
    primaryColor: primaryColor,
    useMaterial3: true,
    fontFamily: 'Mulish',
    scaffoldBackgroundColor: darkScreenColor,
    appBarTheme: const AppBarTheme(
      surfaceTintColor: Colors.transparent,
    ),
    dialogBackgroundColor: darkGeyColor,
    dialogTheme: DialogTheme(
      surfaceTintColor: Colors.transparent,
      backgroundColor: darkGeyColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      surfaceTintColor: Colors.transparent,
      backgroundColor: darkScreenColor,
      shape: RoundedRectangleBorder(),
    ),
  );
}
