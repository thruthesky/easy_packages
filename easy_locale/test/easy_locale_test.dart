import 'package:easy_locale/easy_locale.dart';
import 'package:test/test.dart';

void main() {
  group('Translation', () {
    test('locale', () {
      LocaleService.instance.setLocale('ko');
      final locale = LocaleService.instance.getLocale();
      expect(locale, 'ko');
    });

    test('Add new text', () {
      LocaleService.instance.set(
        key: 'hello',
        locale: 'en',
        value: 'Hello',
      );

      expect('hello'.t == 'Hello', true);
    });

    test('Form', () {
      LocaleService.instance.set(
        key: 'apple',
        locale: 'en',
        value: {
          'zero': '{name} has no apple.',
          'one': '{name} has one apple.',
          'many': '{name} has {n} apples.',
        },
      );

      int n = 0;
      expect('apple'.tr(args: {'name': 'J'}, form: n), 'J has no apple.');
      n = 1;
      expect('apple'.tr(args: {'name': 'J'}, form: n), 'J has one apple.');
      n = 3;
      expect(
          'apple'.tr(args: {'name': 'J', 'n': n}, form: n), 'J has 3 apples.');
    });

    test("Choose Defualt language en when the locale is missing", () {
      LocaleService.instance.set(
        key: 'hello',
        locale: 'en',
        value: 'Hello',
      );

      LocaleService.instance.setLocale('ko');

      expect('hello'.t == 'Hello', true);
    });
    test("Choose Korean locale", () {
      LocaleService.instance.set(
        key: 'hello',
        locale: 'en',
        value: 'Hello',
      );
      LocaleService.instance.set(
        key: 'hello',
        locale: 'ko',
        value: '안녕하세요.',
      );

      LocaleService.instance.setLocale('ko');

      expect('hello'.t == '안녕하세요.', true);
    });
  });
}
