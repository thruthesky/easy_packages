import 'package:flutter/material.dart';

extension EasyHelperMediaQueryExtension on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;

  double get screenHeight => MediaQuery.of(this).size.height;

  /// Get the device orientation.
  Orientation get orientation => MediaQuery.of(this).orientation;

  /// Extra small screen means if the width is smaller than 375
  /// It is used to check if the user is using a small device like iPhone SE.
  bool get isExtraSmallScreen => screenWidth <= 375;

  /// Small screen means if the width is smaller than 460
  ///
  /// It is used to check if the user is using a big screen of mobile phone
  /// like iPhone 12 Pro Max or Samsung Galaxy S21 Ultra.
  ///
  /// The iPhone 11 Pro Max has a width of 414 points.
  /// The Simulator of iPhone 15 Pro Max has a width of 430 points.
  ///
  bool get isSmallScreen => screenWidth > 375 && screenWidth <= 460;

  /// Medium screen is biggter than the phone and smaller than the tablet.
  ///
  /// The width of the tablet is 768 points.
  bool get isMediumScreen => screenWidth > 460 && screenWidth <= 800;

  /// Big screen is bigger than the tablet and smaller than the desktop.
  bool get isBigScreen => screenWidth > 800 && screenWidth <= 1200;

  /// Extra big screen is bigger than the desktop.
  bool get isExtraBigScreen => screenWidth > 1200;

  /// If the width of the device is less than or equal to 460, it is a phone screen.
  bool get isPhoneScreen => isExtraSmallScreen || isSmallScreen;

  /// Check if the device is in portrait mode.
  bool get isPortrait => orientation == Orientation.portrait;

  /// Check if the device is in landscape mode.
  bool get isLandscape => orientation == Orientation.landscape;

  /// Return true if the device is a phone. Not a tablet, iPad, or desktop, etc.
  /// Return true if the narrowest side of the device is less than or equal to 460 points.
  bool get isPhone => screenWidth <= 460 || screenHeight <= 460;
}
