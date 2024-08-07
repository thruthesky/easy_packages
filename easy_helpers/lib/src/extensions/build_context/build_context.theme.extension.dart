import 'package:flutter/material.dart';

extension EasyHelperThemeExtension on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  Color get primary => colorScheme.primary;
  Color get outline => colorScheme.outline;
  Color get onPrimary => colorScheme.onPrimary;
  Color get secondary => colorScheme.secondary;
  Color get onSecondary => colorScheme.onSecondary;
  Color get transparent => Colors.transparent;
  Color get primaryContainer => colorScheme.primaryContainer;
  Color get onPrimaryContainer => colorScheme.onPrimaryContainer;
  Color get secondaryContainer => colorScheme.secondaryContainer;
  Color get tertiaryContainer => colorScheme.tertiaryContainer;
  Color get background => colorScheme.surface;
  Color get onBackground => colorScheme.onSurface;
  Color get error => colorScheme.error;
  Color get onError => colorScheme.onError;

  Color get surface => colorScheme.surface;
  Color get onSurface => colorScheme.onSurface;

  TextTheme get textTheme => Theme.of(this).textTheme;

  TextStyle get titleSmall => textTheme.titleSmall!;
  TextStyle get titleMedium => textTheme.titleMedium!;
  TextStyle get titleLarge => textTheme.titleLarge!;
  TextStyle get bodyLarge => textTheme.bodyLarge!;
  TextStyle get bodyMedium => textTheme.bodyMedium!;
  TextStyle get bodySmall => textTheme.bodySmall!;
  TextStyle get labelMedium => textTheme.labelMedium!;
  TextStyle get labelLarge => textTheme.labelLarge!;
  TextStyle get labelSmall => textTheme.labelSmall!;
}
