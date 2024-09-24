import 'package:easy_design_system/easy_design_system.dart';
import 'package:flutter/material.dart';

// Create an extension on Container to add a border to it.
extension ComicThemeContainer on Widget {
  Container comicBorder({
    EdgeInsets margin = EdgeInsets.zero,
    EdgeInsets padding = EdgeInsets.zero,
    double spacing = 2.4,
    double borderRadius = 24.0,
    double? innerBorderRadius,
    Color outlineColor = Colors.black,
    Color inlineColor = Colors.white,
    double? borderWidth,
  }) {
    innerBorderRadius ??= borderRadius - 2;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: inlineColor, // Background color of the container
        border: Border.all(
          color: outlineColor, // Outer border color
          width: borderWidth ?? comicBorderWidth, // Outer border width
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Container(
        padding: padding,
        margin: EdgeInsets.all(spacing),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(innerBorderRadius),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(innerBorderRadius),
          child: this,
        ),
      ),
    );
  }
}
