import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeDatas {
  // get lightTheme => _lightTheme;
  // get darkTheme => _darkTheme;
  // var _colorScheme =FlexScheme.vesuviusBurn;

  ThemeData lightTheme([FlexScheme? scheme]) => FlexThemeData.light(
        scheme: scheme ?? FlexScheme.vesuviusBurn,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 9,
        keyColors: const FlexKeyColors(),
        subThemesData: const FlexSubThemesData(),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        // To use the playground font, add GoogleFonts package and uncomment
        fontFamily: GoogleFonts.notoSans().fontFamily,
      );
  ThemeData darkTheme([FlexScheme? scheme]) => FlexThemeData.dark(
        scheme: scheme ?? FlexScheme.vesuviusBurn,

        appBarElevation: 0,
        // appBarOpacity: 0.0,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 15,
        keyColors: const FlexKeyColors(),
        subThemesData: const FlexSubThemesData(),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        // To use the Playground font, add GoogleFonts package and uncomment
        fontFamily: GoogleFonts.notoSans().fontFamily,
      );
}
