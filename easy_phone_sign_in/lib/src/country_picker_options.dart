import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

/// Country picker options
///
/// Shows a bottom sheet containing a list of countries to select one.
/// These options are the same parameters as the
/// [CountryPicker.showCountryPicker].
///
/// [countryListTheme] is used to controll the bottom sheet's height and
/// other properties.
///
/// See the [CountryPicker.showCountryPicker] for more information.
class CountryPickerOptions {
  final ValueChanged<Country>? onSelect;
  final VoidCallback? onClosed;
  final List<String>? favorite;
  final List<String>? exclude;
  final List<String>? countryFilter;
  final bool showPhoneCode;
  final CustomFlagBuilder? customFlagBuilder;
  final CountryListThemeData? countryListTheme;
  final bool searchAutofocus;
  final bool showWorldWide;
  final bool showSearch;
  final bool useSafeArea;
  final bool useRootNavigator;
  final bool moveAlongWithKeyboard;

  const CountryPickerOptions({
    this.onSelect,
    this.onClosed,
    this.favorite,
    this.exclude,
    this.countryFilter,
    this.showPhoneCode = true,
    this.customFlagBuilder,
    this.countryListTheme,
    this.searchAutofocus = false,
    this.showWorldWide = false,
    this.showSearch = true,
    this.useSafeArea = false,
    this.useRootNavigator = false,
    this.moveAlongWithKeyboard = false,
  });
}
