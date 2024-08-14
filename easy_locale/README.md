# Easy Locale

Simple, yet another easy internationalizaion package.

The features of this package are:

- No need to apply locale in the Flutter app
- Very simple to use


For reference, this `easy_locale` can be used together with other multilingual packages.


## Install


- This `easy_locale` package does not set the locale in a Flutter app.

- For an iOS app, you need to add the list of supported languages to `CFBundleLocalizations` in the iOS `Info.plist` to support the locales. Or the app may display only English even if the device set a different language in its setting.

- Below is an example of adding language settings to the `ios/Runner/Info.plist` file.

```xml
<key>CFBundleLocalizations</key>
<array>
	<string>en</string>
	<string>ch</string>
	<string>ja</string>
	<string>ko</string>
</array>
```

- There is nothing to configure in Android.



## Examples


- Refer the [example code](https://github.com/thruthesky/easy_frame/blob/main/example/lib/screens/locale/locale.screen.dart) to know more about it.


## Initialization


- It is recommended to initialize before calling `runApp` in the `main()` function. If this is not possible, you can do it in the `initState` of the first page screen widget of the app.


- By calling `init` as shown below, you can use the language settings of the phone (device). Depending on the situation, you may add the `await` keyword before `TranslationService.instance.init()`.


```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  TranslationService.instance.init();
  runApp(const MyApp());
}
```

- You can initialize in more detail as shown below.


```dart
TranslationService.instance.init(
    deviceLocale: true,
    defaultLocale: 'ko',
    fallbackLocale: 'en',
    useKeyAsDefaultText: true,
);
```

In the code above, setting `deviceLocale` to true. It means it will use the language applied to the current device settings. The default value is `true`.

If `deviceLocale` is set to false, the `defaultLanguage` will be used. In other words, if you do not want to use the phone's default language settings and want to specify a language of your choice, you can set `deviceLocale` to false and provide a value like "ko" to `defaultLanguage` to select your desired language as the default.

If a translated string cannot be found in the multilingual settings, it will look for a translated string in the language specified by `fallbackLocale` and use it if found. The default value is `en`.

If `useKeyAsDefaultText` is true, it means using the language code (key) as is when a translated string cannot be found. If this value is false, the language code (key) will be used with `.t` appended to the end and displayed on the screen.





## How to use


### Localization extension

There are two localization functions: `.t` and `.tr`.


### Places to set locale texts

By default, the translation texts are saved in `easy_locales/lib/src/locale.texts.dart`. This file should have the most common text translation only. This is called `default translation text file`.

If you are developing a package and you are using `easy_locale` for the internationalization of the package, you should not touch the default translation text file. Instead, you should create your own translation text in your package and apply it to `easy_locale`'s text object by calling `lo.set()`.
See the example below especially how it supports the translations from the app.

Example:
```dart
final localeTexts = <String, Map<String, String>>{
  'chat room create': {
    'en': 'Chat Room Create',
    'ko': '채팅방 생성',
  },
  'chat room update': {
    'en': 'Chat Room Update',
    'ko': '채팅방 수정',
  },
};

applyChatLocales() async {
  final locale = await currentLocale; // get current locale of the app
  if (locale == null) return;

  for (var entry in localeTexts.entries) {
    // If the app has set the text, then don't apply the text from the package.
    // By prioritize app's translation.
    if (lo.get(key: entry.key, locale: locale) != null) continue;

    // Set the translation
    lo.set(key: entry.key, locale: locale, value: entry.value[locale]);
  }
}
```


If you are developing an app, you should create a text translation file somewhere in the app project, and apply it to `easy_local`'s text object by calling `lo.set()`.


By using `TranslationService.instance.set()`, you can change existing translation strings to something else or add new ones if they do not already exist. Therefore, you can use the in-house multilingual feature to translate the strings used in the app.

```dart
TranslationService.instance.set(
  key: 'hello',
  locale: 'en',
  value: 'Hello',
);

expect('hello'.t == 'Hello', true);
```


See `lo.merge` to merge the translated text **synchrounously**.


#### Adding custom translations

- You can use `lo.set()` to add or update your own translations.

- Below is an example of adding custom translations.

```dart
import 'package:easy_locale/easy_locale.dart';

final localeTexts = <String, Map<String, String>>{
  'todo': {
    'en': 'Todo',
    'ko': '할일',
  },
  'game': {
    'en': 'Games',
    'ko': '게임',
  },
  'Must login first': {
    'en': 'Must login first',
    'ko': '로그인이 필요합니다',
  },
  'you have reached the upload limit': {
    'en': 'You have reached the upload limit',
    'ko': '업로드 제한에 도달했습니다',
  },
};

void addLocaleTexts() async {
  final locale = await currentLocale;
  if (locale == null) return;

  for (var entry in localeTexts.entries) {
    lo.set(key: entry.key, locale: locale, value: entry.value[locale]);
  }
}
```


By doing as below, you can save it to the language key called `name` as shown below. Pay special attention to handling singular/plural forms.

```dart
final localeTexts = {
    'name': {
        'en': 'Name',
        'ko': '이름',
    },
    'there are {n} apple': {
        'en': {
            'none': 'There is no apple',
            'one': 'There is only {n} apple',
            'many': 'There are {n} apples',
        },
        'ko': '사과가 {n}개 있어요',
    }
}
```


### Get local text

Use this to check if the text exists.


### Local Transation Texts

Translation strings are stored in the `localeTexts` variable in `./lib/translation/translation.text.dart`.



### Simple translation - t

`.t` is an extension method that simply displays text in multiple languages.

```dart
Translation.instance.setLocale('ko');
'name'.t // result: 이름
```

### Translation with Replacement and Forms - tr

Compared to `.t`, `.tr` allows for string substitution and can handle singular/plural forms.

The basic usage is:
`'apple'.tr(args: {'name': 'J', 'n': n}, form: n)`.

In the `args` parameter, specify the key/value pairs you want to substitute in the translation string in the form `args: { key: value, ... }`.

For the `form` parameter, It can have 3 different values; a value of null or 0 means no items, 1 means singular, and 2 or more means plural.

When storing translation strings, they should be saved in the following format.

```dart
final localeTexts = {
    'apple': {
        'en': {
            'zero': '{name} has no apple.',
            'one': '{name} has one apple.',
            'many': '{name} has {n} apples.',
        }
    }
};
```

Example:

```dart
TranslationService.instance.set(
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
expect('apple'.tr(args: {'name': 'J', 'n': n}, form: n), 'J has 3 apples.');
```




### lo

참고로 `LocalService.instance` 를 줄여서 `lo` 로 사용 할 수 있습니다.

```dart
class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    lo.init();
  }

  @override
  Widget build(BuildContext context) {
    lo.set(key: 'home title', locale: 'ko', value: '다국어 설정');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('home title'.t),
      ),
      // ...
    );
  }
}
```


# Merging texts

The `lo.set()` needs a locale to set(or replace) the text. And you may write the code to get it **asynchrounously**. And the translated text may not appear immediately. It means, there might be a flickering with the text code and the text.

To prevent this, you may use `lo.merge()` which does not require the locale, thus it will set(or replace) the text **synchrounously**. And there will be no flickering.

You can call the `lo.merge()` method like below just before you use it.

```dart
lo.merge({
  'test': {
    'en': 'Test',
    'ko': '테스트',
  },
});
```

## Setting texts where it is needed

- You may use `lo.merge` to add translation where it is used.
- The example below merges translation texts inside the build method. You may do so if you want.

```dart
class ReportMenu extends StatelessWidget {
  const ReportMenu({super.key});

  @override
  Widget build(BuildContext context) {
    lo.merge({
      'report': {
        'en': 'Report',
        'ko': '신고',
      },
      'my report list': {
        'en': 'My Report List',
        'ko': '내 신고 목록',
      },
    });
    return Settings(
      label: 'Report'.t,
      children: [
        ListTile(
          onTap: () {},
          title: Text('my report list'.t),
          leading: const Icon(Icons.report),
          trailing: const Icon(Icons.chevron_right_rounded),
        ),
      ],
    );
  }
}
```



- One good use case for writing the text translation (for i18n) in the build method is that a widget that has some text translation with `.t` or `.tr`, and that widget is used in a multiple screen.
  - For instance, you use the easy_comment package in task management and forum, and the two should display different words. The comment pakcage in task management may have text translation like below. The code below displays `Add review of the task` instead of `Add a comment`.
  
- A good use case for writing text translations (for i18n) in the build method is when a widget with text translations using `.t` or `.tr` is used across multiple screens.
  - For instance, if you use the easy_comment package in both task management screen and forum screen, each should display different words. In task management, the comment package might have a text translation like below. The code below displays `Add review of the task` instead of `Add a comment`.
```dart
class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    lo.merge({
      'input comment': {
        'en': 'Add review of the task',
        'ko': '작업에 대한 리뷰를 추가하세요',
      },
    });
    return CommentListTreeView(documentReference: task.ref);
  }
}
```

And in the forum screen, you may set the text translation with `lo.merge()` to display different texts.






# Unit test


- You can look at the test code in the `tests` folder to learn how to use it.



# Trouble shooting


- If the translation is not working, then check if the easy_locale package has been initialized.



