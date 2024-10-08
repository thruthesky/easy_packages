import 'package:easy_locale/easy_locale.dart';

/// Locale Service
///
/// This service provides translation text.
class LocaleService {
  static LocaleService? _instance;
  static LocaleService get instance => _instance ??= LocaleService._();
  LocaleService._();

  String? locale;
  String defaultLocale = 'en';
  String fallbackLocale = 'en';
  bool useKeyAsDefaultText = false;

  bool initialized = false;

  /// initialize the translation service.
  ///
  /// [deviceLocale] If true, set the device locale as the default locale.
  ///
  /// [defaultLocale] The default locale. If the [locale] is not set, the it
  /// will use this [defaultLocale]. So, if you don't want to use the device
  /// locale, call init function with [deviceLocale] false and set your own
  /// local to this [defaultLocale].
  ///
  /// [fallbackLocale] The fallback locale. If the text is not found in the locale, use this locale.
  ///
  /// [useKeyAsDefaultText] If true, use the key as the default text. If it's
  /// false, ".t" will be added to the key. For example, if the code is
  /// ```dart
  /// 'hello'.t
  /// ```
  /// and if the key 'hello' is not found, the key will return 'hello' as text
  /// if [useKeyAsDefaultText] is true. If it's false, it will return
  /// 'hello.t' as text.
  ///
  init({
    bool deviceLocale = true,
    String defaultLocale = 'en',
    String fallbackLocale = 'en',
    bool useKeyAsDefaultText = false,
  }) async {
    initialized = true;

    this.defaultLocale = defaultLocale;
    this.fallbackLocale = fallbackLocale;
    this.useKeyAsDefaultText = useKeyAsDefaultText;
    if (deviceLocale) {
      await LocaleService.instance.setDeviceLocale();
    } else {
      /// If the device locale is not set, use the default locale. (added by @thruthesky Jul 15, 2024)
      locale = defaultLocale;
    }

    initConvertExistingTextKeysToLowerCase();

    // dog('current locale; $locale, default locale: $defaultLocale, fallback locale: $fallbackLocale');
  }

  initConvertExistingTextKeysToLowerCase() {
    /// Make the translation text key into lower case
    Map<String, Map<String, dynamic>> copy = {};
    localeTexts.forEach((key, value) {
      final lowerKey = key.toLowerCase();

      copy[lowerKey] = value;
    });
    localeTexts.clear();
    localeTexts.addAll(copy);
  }

  /// Set the current locale as the device locale
  ///
  /// Use this function to set the device locale as the app's locale.
  ///
  /// When it is called, the language of the package will be set to the
  /// device's language.
  ///
  /// You may not use this function if you want to set the locale manually
  /// with the [defaultLocale].
  Future setDeviceLocale() async {
    locale = await currentLocale;
  }

  setLocale(String locale) {
    this.locale = locale;
  }

  /// Get the current locale
  ///
  /// If the locale is not set, return 'en' as locale.
  String getLocale() {
    return locale ?? defaultLocale;
  }

  /// Translate with replacement
  tr(
    String key, {
    Map<String, dynamic>? args,
    int? form,
  }) {
    /// For case insensitive
    key = key.toLowerCase();

    /// Get the translation text map from the key.
    final textMap = localeTexts[key] ?? {};

    String useKey = (useKeyAsDefaultText ? key : '$key.t');

    /// Get the text data from the locale. If the locale is not set, return 'en' as locale.
    /// If the text data is not found, return the key.
    final textData = textMap[locale] ?? textMap[fallbackLocale] ?? useKey;

    // log(textMap.toString());
    // log('textData: $textData');
    String text;

    if (textData is String) {
      text = textData;
    } else if (textData is Map) {
      /// If the text data is a map, get the singular/plural text from the form.
      String selected;
      if (form == null || form == 0) {
        selected = 'zero';
      } else if (form == 1) {
        selected = 'one';
      } else {
        selected = 'many';
      }
      text = textData[selected] ?? useKey;
    } else {
      text = useKey;
    }

    if (args == null) {
      return text;
    }

    args.forEach((key, value) {
      text = text.replaceAll('{$key}', value.toString());
    });

    return text;
  }

  /// Set translation text
  ///
  /// It will set(or replace) the text of the key of the locale.
  ///
  /// Note that, it will only set the text of the key of the **locale**. It
  /// will not set the text of the key of the other locales.
  ///
  /// To merge the translation text, use [merge] function.
  set({
    required String key,
    required String locale,
    required dynamic value,
  }) {
    /// For case insensitive
    key = key.toLowerCase();

    if (localeTexts[key] == null) {
      localeTexts[key] = {};
    }

    /// Case insensitive
    localeTexts[key]![locale] = value;
  }

  /// Get the translation text
  ///
  /// You can use this to check if the translation text is already set.
  String? get({
    required String key,
    required String locale,
  }) {
    /// For case insensitive
    key = key.toLowerCase();

    final textMap = localeTexts[key] ?? {};
    return textMap[locale] ?? textMap[fallbackLocale];
  }

  /// Merge the translation text
  ///
  /// It overrides the existing translation text.
  merge(Map<String, Map<String, dynamic>> texts) {
    texts.forEach((key, value) {
      key = key.toLowerCase();
      if (localeTexts[key] == null) {
        localeTexts[key] = {};
      }
      localeTexts[key]!.addAll(value);
    });
  }
}
