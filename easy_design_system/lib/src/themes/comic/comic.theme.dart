import 'package:easy_design_system/easy_design_system.dart';
import 'package:flutter/material.dart';

/// ComicThemeData
///
/// [ComicThemeData] is a class that holds the color scheme for the Comic theme.
class ComicThemeData {
  ComicThemeData();

  /// of
  ///
  /// [of] is a method that returns a [ThemeData] object with the color scheme
  static ThemeData of(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ThemeData(
      appBarTheme: AppBarTheme(
        //   iconTheme: theme.iconTheme.copyWith(
        //     color: theme.colorScheme.onSurface,
        //   ),
        //   actionsIconTheme: theme.iconTheme.copyWith(
        //     color: theme.colorScheme.onSurface,
        //   ),
        //   titleTextStyle: theme.textTheme.headlineMedium?.copyWith(
        //     color: theme.colorScheme.onSurface,
        //   ),
        shape: Border(
          bottom: BorderSide(
            width: comicBorderWidth,
            color: theme.colorScheme.outline,
          ),
        ),
      ),

      // actionIconTheme: ActionIconThemeData(
      //   backButtonIconBuilder: (context) =>
      //       IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
      // ),

      // NOTE: Did not set the badge color because it
      // should be up to the developer
      // by default it is set to colorScheme.error
      // badgeTheme: theme.badgeTheme.copyWith(
      //   backgroundColor: theme.colorScheme.primary,
      // ),

      // NOTE: Unable to add borders for comic theme in bottom app bar.
      bottomAppBarTheme: theme.bottomAppBarTheme,

      bottomNavigationBarTheme: theme.bottomNavigationBarTheme.copyWith(
        elevation: 0,
      ),

      bottomSheetTheme: BottomSheetThemeData(
        // backgroundColor: theme.colorScheme.surface,
        shape: Border(
          top: BorderSide(
            width: comicBorderWidth,
          ),
          left: BorderSide(
            width: comicBorderWidth,
          ),
          right: BorderSide(
            width: comicBorderWidth,
          ),
        ),
      ),
      cardTheme: theme.cardTheme.copyWith(
        // color: theme.colorScheme.error,
        elevation: 0,
        shape: comicRoundedRectangleBorder(context),
      ),

      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        fillColor: WidgetStateProperty.all(
          comicContainerBackgroundColor(context),
        ),
        checkColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return theme.colorScheme.outlineVariant;
            }

            return theme.colorScheme.onSurface;
          },
        ),
      ),

      /// [Chip] @thruthesky - 2024-05-22
      ///
      chipTheme: theme.chipTheme.copyWith(
        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        shape: comicRoundedRectangleBorder(context),
        backgroundColor: comicContainerBackgroundColor(context),
        selectedColor: comicContainerBackgroundColor(context),
      ),
      colorScheme: theme.colorScheme,

      dialogTheme: DialogTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(comicBorderRadius),
          side: BorderSide(
            // removed the border color so the default value from [BorderSide] will be used
            // color: theme.colorScheme.outline,
            width: comicBorderWidth,
          ),
        ),
      ),
      dividerTheme: theme.dividerTheme.copyWith(
        color: theme.colorScheme.outline,
        thickness: comicBorderWidth,
      ),
      drawerTheme: theme.drawerTheme.copyWith(
        elevation: 0,
        shadowColor: Colors.transparent,
        endShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(comicBorderRadius),
              bottomLeft: Radius.circular(comicBorderRadius),
            ),
            side: BorderSide(
              width: comicBorderWidth,
              color: theme.colorScheme.outline,
            )),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(comicBorderRadius),
                bottomRight: Radius.circular(comicBorderRadius)),
            side: BorderSide(
              width: comicBorderWidth,
              color: theme.colorScheme.outline,
            )),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(0),
          shape: WidgetStateProperty.all(
            comicRoundedRectangleBorder(context),
          ),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 0,
        shape: comicRoundedRectangleBorder(context),
        highlightElevation: 0,
      ),
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.15),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.15),
          borderSide: BorderSide(
            color: theme.colorScheme.outline,
            width: comicBorderWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.15),
          borderSide: BorderSide(
            color: theme.colorScheme.outline,
            width: comicBorderWidth,
          ),
        ),
      ),

      listTileTheme: theme.listTileTheme.copyWith(
        // Note: By default, the tileColor uses Colors.transparent so we should
        // not give tile color on comic theme because it might conflict with other
        // widget that uses background color. We should let the developers
        // override the tileColor instead
        // tileColor: theme.colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: comicRoundedRectangleBorder(context),
      ),
      menuBarTheme: MenuBarThemeData(
        style: (theme.dropdownMenuTheme.menuStyle ?? const MenuStyle()).copyWith(
          backgroundColor: WidgetStateProperty.all(
            comicContainerBackgroundColor(context),
          ),
          shadowColor: WidgetStateProperty.all(
            Colors.transparent,
          ),
          shape: WidgetStateProperty.all(
            comicRoundedRectangleBorder(context, 16),
          ),
        ),
      ),

      // uses the menuTheme
      // dropdownMenuTheme: const DropdownMenuThemeData(),
      menuTheme: MenuThemeData(
        style: (theme.dropdownMenuTheme.menuStyle ?? const MenuStyle()).copyWith(
          backgroundColor: WidgetStateProperty.all(
            comicContainerBackgroundColor(context),
          ),
          shadowColor: WidgetStateProperty.all(
            Colors.transparent,
          ),
          shape: WidgetStateProperty.all(
            comicRoundedRectangleBorder(context, 16),
          ),
        ),
      ),

      navigationBarTheme: theme.navigationBarTheme.copyWith(
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).colorScheme.onSurface,
            );
          }
          return TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).colorScheme.onSurface,
          );
        }),
        indicatorShape: comicRoundedRectangleBorder(context),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      navigationDrawerTheme: theme.navigationDrawerTheme.copyWith(
        elevation: 0,
        shadowColor: Colors.transparent,
        // indicatorColor: Colors.transparent,
        indicatorShape: comicRoundedRectangleBorder(context),
      ),
      navigationRailTheme: theme.navigationRailTheme.copyWith(
        indicatorColor: Colors.transparent,
        indicatorShape: comicRoundedRectangleBorder(context),
      ),
      popupMenuTheme: PopupMenuThemeData(
        elevation: 0,
        shape: comicRoundedRectangleBorder(context, 16),
        color: comicContainerBackgroundColor(context),
      ),

      radioTheme: const RadioThemeData(),

      // ),
      snackBarTheme: SnackBarThemeData(
        elevation: 0,
        backgroundColor: comicContainerBackgroundColor(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(comicBorderRadius),
          side: BorderSide(
            width: comicBorderWidth,
            color: theme.colorScheme.outline,
          ),
        ),
        actionTextColor: theme.colorScheme.primary,
        contentTextStyle: TextStyle(
          color: theme.colorScheme.onSurface,
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          // selectedBackgroundColor: theme.colorScheme.secondary.withAlpha(80),
          // selectedForegroundColor: theme.colorScheme.onSurface,
          // foregroundColor: theme.colorScheme.onSurface,
          side: BorderSide(
            width: comicBorderWidth,
            color: theme.colorScheme.outline,
          ),
          elevation: 0,
        ),
      ),
      switchTheme: SwitchThemeData(
        trackOutlineWidth: WidgetStateProperty.all(
          comicBorderWidth,
        ),
        thumbColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return theme.colorScheme.outlineVariant;
            }
            return theme.colorScheme.outline;
          },
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return theme.colorScheme.outlineVariant;
            }

            return theme.colorScheme.onSurface;
          },
        ),
        trackColor: WidgetStateProperty.all(
          comicContainerBackgroundColor(context),
        ),
      ),
      toggleButtonsTheme: ToggleButtonsThemeData(
        selectedBorderColor: theme.colorScheme.outline,
        borderWidth: comicBorderWidth,
        fillColor: comicContainerBackgroundColor(context),
        borderRadius: BorderRadius.circular(7),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(0),
          // NOTE: Shape is not working here.
          side: WidgetStatePropertyAll(
            BorderSide(
              // Please review this might be a wrong way to do it.
              // because in flutter way, to set the color scheme, we can usually set
              // it thru copyWith, then set the color scheme.
              // Here, it is accessing the outline color from the theme variable.
              // When developer used this like ComicTheme.of(context).copyWith( colorScheme: theme.colorScheme )
              // theme.colorScheme.
              color: theme.colorScheme.outline,
              width: comicBorderWidth,
            ),
          ),
        ),
      ),
      // progressIndicatorTheme: const ProgressIndicatorThemeData(
      // linearTrackColor: theme.colorScheme.outlineVariant.withAlpha(40),
      // color: theme.colorScheme.secondary,

      tabBarTheme: theme.tabBarTheme.copyWith(
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: comicBorderWidth * 3,
              color: theme.colorScheme.outline,
            ),
          ),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        // Note: By default, the dividerColor uses outlineVariant
        // dividerColor: theme.colorScheme.onSurface,
        dividerHeight: comicBorderWidth * 0.8,
      ),
    );
  }
}

/// ComicTheme
///
/// [ComicTheme] is a class that returns a [Theme] widget with the [ComicThemeData] object
class ComicTheme extends StatelessWidget {
  const ComicTheme({super.key, required this.child});

  final Widget child;

  /// Supporting method to get the [ThemeData] object
  ///
  /// @example
  /// ```dart
  /// final theme = ComicTheme.of(context);
  ///
  /// Theme(
  ///   data: theme,
  /// )
  /// ```
  static ThemeData of(BuildContext context) {
    return ComicThemeData.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ComicThemeData.of(context),
      child: child,
    );
  }
}
