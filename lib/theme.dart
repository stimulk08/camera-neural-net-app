import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    splashColor: Colors.white,
    fontFamily: 'SFProText',
    colorScheme: const ColorScheme.light(
      primary: Color(0xff2D92FD),
      inversePrimary: Color.fromARGB(77, 45, 146, 253),
      primaryContainer: Color(0xffFAFAFA),
      onPrimaryContainer: Color.fromARGB(153, 52, 52, 52),
      background: Color(0xffECF2F8),
      onBackground: Colors.white,
      secondary: Color.fromARGB(153, 52, 52, 52),
      tertiary: Color.fromARGB(52, 52, 52, 52),
      onSurface: Color(0xff343434),
      onSurfaceVariant: Color.fromARGB(102, 52, 52, 52),
      secondaryContainer: Colors.white,
      onSecondaryContainer: Color(0xffD9D9D9),
    ),
    sliderTheme: const SliderThemeData(
      showValueIndicator: ShowValueIndicator.onlyForContinuous,
    ));

ThemeData darkTheme = ThemeData(
    splashColor: const Color(0xff2C2E30),
    fontFamily: 'SFProText',
    colorScheme: const ColorScheme.dark(
      primary: Color(0xff2D92FD),
      inversePrimary: Color.fromARGB(77, 45, 146, 253),
      primaryContainer: Color(0xff323232),
      onPrimaryContainer: Color.fromARGB(153, 255, 255, 255),
      background: Color(0xff151616),
      onBackground: Color(0xff2C2E30),
      secondary: Color.fromARGB(102, 255, 255, 255),
      tertiary: Color.fromARGB(52, 255, 255, 255),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color.fromARGB(102, 255, 255, 255),
      secondaryContainer: Color(0xff343434),
      onSecondaryContainer: Color(0xff444545),
    ),
    sliderTheme: const SliderThemeData(
      showValueIndicator: ShowValueIndicator.onlyForContinuous,
    ));