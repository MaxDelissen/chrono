import 'package:clock_app/theme/border.dart';
import 'package:clock_app/theme/bottom_sheet.dart';
import 'package:clock_app/theme/card.dart';
import 'package:clock_app/theme/color_scheme.dart';
import 'package:clock_app/theme/data/default_color_schemes.dart';
import 'package:clock_app/theme/dialog.dart';
import 'package:clock_app/theme/input.dart';
import 'package:clock_app/theme/radio.dart';
import 'package:clock_app/theme/slider.dart';
import 'package:clock_app/theme/snackbar.dart';
import 'package:clock_app/theme/switch.dart';
import 'package:clock_app/theme/text.dart';
import 'package:clock_app/theme/theme_extension.dart';
import 'package:clock_app/theme/time_picker.dart';
import 'package:clock_app/theme/toggle_buttons.dart';
import 'package:flutter/material.dart';

ColorSchemeData defaultColorScheme = defaultColorSchemes[0];

ThemeData defaultTheme = ThemeData(
  fontFamily: 'Rubik',
  textTheme: textTheme.apply(
    bodyColor: defaultColorScheme.onBackground,
    displayColor: defaultColorScheme.onBackground,
  ),
  cardTheme: cardTheme,
  colorScheme: getColorScheme(defaultColorScheme),
  timePickerTheme: timePickerTheme,
  dialogTheme: dialogTheme,
  switchTheme: switchTheme,
  snackBarTheme: getSnackBarTheme(defaultColorScheme, defaultBorderRadius),
  inputDecorationTheme: getInputTheme(defaultColorScheme, defaultBorderRadius),
  radioTheme: getRadioTheme(defaultColorScheme),
  sliderTheme: sliderTheme,
  bottomSheetTheme:
      getBottomSheetTheme(defaultColorScheme, defaultBorderRadius.topLeft),
  toggleButtonsTheme: toggleButtonsTheme,
  extensions: const <ThemeExtension<dynamic>>[ThemeStyle()],
);
