import 'package:easy_design_system/easy_design_system.dart';
import 'package:flutter/material.dart';

/// TextButton for Comic Theme
///
/// Purpose: All TextButton must be simple without border even if it's comic
/// theme.
/// If you want the TextButton to have border and look like a Comic design,
/// then you can use [ComicTextButtonThemeData] to a TextButton to apply the
/// border and Comic design.
/// In short, TextButton of comic theme does not have border. And to have
/// border, use [ComicTextButtonThemeData].
class ComicTextButtonThemeData {
  // ComicTextButtonThemeData();

  static ThemeData of(BuildContext context) {
    final theme = Theme.of(context);
    return ThemeData(
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(theme.colorScheme.onSurface),
          backgroundColor: WidgetStateProperty.all(theme.colorScheme.surface),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(
                width: comicBorderWidth,
                color: theme.colorScheme.secondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
