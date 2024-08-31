# Easy Packages

- This project is composed of several packages, each designed for specific functionalities.

- [Easy Packages](#easy-packages)
- [Overview](#overview)
- [Key Features](#key-features)
- [Install](#install)
  - [Install a package into your app](#install-a-package-into-your-app)
  - [Install as a easy packages developer](#install-as-a-easy-packages-developer)
- [Packages](#packages)
  - [Storage](#storage)
  - [easyuser package](#easyuser-package)
  - [Chat](#chat)
  - [Forum](#forum)
  - [Task](#task)
  - [Locale](#locale)
  - [Like and Dislike](#like-and-dislike)
  - [Category](#category)
  - [Block](#block)
  - [Report](#report)
  - [Engine](#engine)
- [Other packages](#other-packages)
- [Coding Style Guide](#coding-style-guide)
  - [Mermaid](#mermaid)
  - [Model](#model)
  - [Widget of Model](#widget-of-model)
  - [Service](#service)
  - [Database](#database)
  - [Fields](#fields)
  - [Exception](#exception)
- [Widget](#widget)
  - [intialValue and cache](#intialvalue-and-cache)
  - [List Widgets](#list-widgets)
- [Tests](#tests)
  - [Unit test](#unit-test)
  - [Widget test](#widget-test)
  - [Integration test](#integration-test)
- [Localization, i18N](#localization-i18n)
- [Customization](#customization)
  - [Customizing Action Buttons](#customizing-action-buttons)

# Overview

- **Easy Packages**: A Flutter framework with many UI/UX components and logic modules. It helps you create apps fast for different projects.

- This framework includes various small packages, each designed for a specific purpose. You can use any package individually or combine them to enhance your app. The goal is to provide key app functionalities as standalone, user-friendly packages available on pub.dev, making app development more efficient and modular.

# Key Features

- **Independence**: Each package is independent. You can use only what you need. For example, if your app needs a chat feature, you can just add the `easychat` package.
- **Variety**: Offers a range of packages for different needs, such as chat, member management, forums, friend management, and social features, and much more. You're also free to add any other package you find necessary.



# Install

## Install a package into your app

If you want to install easy local package, you can add like below.

```yaml
dependencies:
  easy_locale: latest
```


You can add any easy pakcages like this.


## Install as a easy packages developer

- You can fork and clone the `https://github.com/thruthesky/easy_packages` repository inside your flutter app folder.

- Then, add the dependencies like below.
  - Since the packages are installed by dependencies, to use the cloned version of easy_packages, you will need to override them.

```yaml
dependencies:
  easy_helpers:
  easy_locale:
  easy_storage:
  easyuser:

dependency_overrides:
  easy_helpers:
    path: ./easy_packages/easy_helpers
  easy_locale:
    path: ./easy_packages/easy_locale
  easy_storage:
    path: ./easy_packages/easy_storage
  easyuser:
    path: ./easy_packages/easyuser
```




# Packages


## Storage

This package helps your app upload photos and videos to Firebase Storage.

Please refer to the [Storage Package - easy_storage](https://pub.dev/packages/easy_storage).



## easyuser package


This package helps manage users in your app. If your app has different database structure, you can customize your database structure to work with other `easyuser`.

Please refer to the [User Package - easyuser](https://pub.dev/packages/easyuser).



## Chat

- A package that includes all the features of a chat room

Please refer to the [Chat Package - easychat](https://pub.dev/packages/easychat).


## Forum

- Refer `easy_post` and `easy_comment` to add a forum function to your app.





## Task


The task management system is a system for managing tasks that need to be done in various situations, such as company work, school assignments, and more. It can be thought of as a simple app with `TODO` functionality, or more broadly, as a work management system.


Please refer to the [Task Management System Package - easy_task](https://pub.dev/packages/easy_task).



## Locale

- easy_locale - A multilingual translation package. There are many translation packages on pub.dev, but we use the simpler easy_locale package. There's no need for you to use this package in your app, but you can if you want.


## Like and Dislike

The `like` and `dislike` functionality can be applied to various entities in the app, such as user profiles, uploaded photos, posts, and comments.

A simple way to handle this is by saving a list of user IDs who liked or disliked an item. However, if the document becomes too large, it can slow down the app and increase costs for network usage on Firebase. Additionally, Firestore documents have a 1MB size limit, which can cause issues if too many users like or dislike an item.

The `easy_like` package provides an easy and efficient way to manage the `like` and `dislike` functionality.


## Category



## Block


## Report





## Engine

- `easy_engine` package is the counter part of the [easy-engin](https://github.com/thruthesky/easy-engine) backend.

- You only need to install this package and the firebase easy-engine in your project. This way, you can manage your Firebase more efficiently without needing other `easy packages` seriese.


# Other packages

Although not directly related to FireFlutter, these packages are used internally by FireFlutter.

- easy_helpers - Contains various shared functions and extensions needed by FireFlutter. There's no need to use this package in your app, but you can if you want.

- date_picker_v2 for date picker. It has a very simple UI/UX. I made it because I don't like the Android and iOS UI.
- social_design_system - A beautiful UI/UX theme library.
- phone_sign_in - For phone sign in. It's good for review and testing.

- memory_cache - Used to cache various temporary values in memory.
- rxdart: ^0.27.7
- cached_network_image: ^3.3.1 Note that cached_network_image: ^3.3.1 and rxdart: ^0.27.7 versions must match. Otherwise, a dependency error occurs.




# Coding Style Guide

This is the style guide of the development easy packages.

- The code must be readable and short. If the code is complicated, then that code will be deleted. If the code is long, then that code will be deleted, also.



## Mermaid

- Starting must be `START(xxxx)`
- End must be `END(())`
- End with options should be `BUTTONS>Many options]`. For instance, after create a post, the app will show post deatil screen where the user can choose many options. And the process is finished when the post is created, then use this.
- Process must be `WORK[xxxx]`
- Create, Save, Update, Delete, or anything that need Database work must be `SAVE[(CREATE|UPDATE|DELETE)]`
- Subroutines, or the next screen, dialog should be displayed with `NEXT_SCREEN[[List screen xxx]]`.





## Model

Waht the Model class does
- serialization/deserialization
- basic crud of the model data
- helper functions of the entity itself. Not other entities of the same model.
- encapsulating the refs.


The name of the model classes should be the noun of what it is being called like

- `User`
- `Category`
- `Post`
- `Comment`
- etc.


## Widget of Model

What the widget of model does
- display a UI based on the model data
- realtime update

The name of the widget of a model should end with `Doc` of the name of the model like

- `UserDoc`
- `CategoryDoc`
- `PostDoc`
- `Comment`
- `LikeDoc`
- etc.

The document must have a `sync` parameter to re-build the widget when the database changes.





## Service

Service class does
- something that are related with the model(entity) or the service can handle for the whole function(feacher).
- showing screens
- search & listing data
- initialization, listening, etc.


## Database

- Give default value for the field to help filtering. For instance,
  - if the user didn't choose his gender, then save it as empty string into the database so, it can be used for filtering to know who didn't choose for their gender. If the field does not exists, it's not easy to filter.
  - if the post is not deleted, then save fales to `deleted` field. With this, you can easily filter posts that are not deleted. Without the default value, you cannot filter.

  - Avoid using range comparisons. For example, if the `parent` field holds the parent document ID and is an empty string if there's no parent, you might need to use a range search like `isGreaterThan('parent', '')` to check if a document is a child. Instead, save a boolean `child` field to indicate if a document is a child. And save `null` to `parent` in this case.


- Add `Count` at the end of the field name that records no of counts. Like `commentCount`, `likeCount`, etc.




## Fields

- To prevent the typo error and improve reusabilities, define field class like below

```dart
class UserField {
  UserField._();
  static const String statePhotoUrl = 'statePhotoUrl';
}
```

- And use like below

```dart
UserField.statePhotoUrl
```

## Exception

- A package in `easy_packages` should throw exceptions if
  - the exception cannot be handled by the package itself.
    - For example, if the user is not signed in and the package cannot provide a solution for signing in, then throw a `sign-in-required` exception.
  - the package want to throw the exception better.
    - For instance, the package re-throw the exception with better error handling like throwing `UserException` instead of `Exception`.

- The package shoud throw exception if
  - the exception can be handled internally, the package may(or may not) capture and handle it. For instance, if the user tries to sign in but fails because the email is not in use, the package can catch the exception and register the user. This is an example of handling an exception internally.

- The principle is that if it's okay for the exception not to be handled inside the package itself, then don't handle it.

- To handle better exception, you can write the exception class of each packages.

- This is an example of UserException from `easyuser` package.

Example:
```dart
class UserException implements Exception {
  final String code;
  final String message;

  UserException(this.code, this.message);

  @override
  String toString() {
    return 'UserException: ($code) $message';
  }
}
```

- `code` is the code of exception
- `message` is the reason(or description/explanation) of the exception.


- To handle the error message, you can do the following.

```dart
(() async {
  try {
    throw UserException('sign-in-required', 'Please sign in first');
  } on UserException catch (e) {
    print('* UserException: ${e.code}, ${e.message}');
  } catch (e) {
    print('* Exception: $e');
  }
})();
```






# Widget

하우스는 파이어베이스와 연관된 로직 뿐만아니라 UI 도 제공을 한다. UI 는 주로 위젯을 통해서 화면에 표시하는 디자인적인 요소를 말하며 크게 두 가지 종류가 있다.

첫째는 기능 위젯인데 각 기능과 밀접하게 연결되어져 있어 커스텀 디자인이 좀 어려울 수 있다. 그래서 각 기능 위젯을 작성할 때 커스텀 디자인이 어려울 수 있다는 점을 고려해 최대한 Theme 디자인을 고려해서 작업을 하는 것이다. 즉, 가장 기본적인 플러터 UI 를 써서 디자인 작업을 하여, 앱의 Theme 으로 디자인 변경을 할 수 있도록 해 주는 것이다. 물론 최종적인 목적은 다지인을 100% 커스터마이징 할 수 있도록 제공하는 것이다. 이러한 기능 위젯은 `lib/[각 기능 폴더]/widgets` 폴더에 저장된다. 


둘째는 디자인 위젯으로 하우스 기능을 사용하지만, 독립적으로 동작하여 얼마든지 쉽게 디자인을 변경 할 수 있는 것으로 주로 `widgets` 폴더에 저장된다.











## intialValue and cache

초기값과 캐시 속성은 많은 위젯에서 공통적으로 사용이 된다.

데이터베이스에서 데이터를 가져와 화면에 표시하는 위젯들에 사용되며, 주로 화면에 빠르게 표시를 하기 위해서 사용한다. 예를 들면 사용자 정보를 화면에 표시할 때, 사용자의 문서 레코드를 데이터베이스로 부터 읽어야 하는데, 한번 읽은 데이터는 메모리에 캐시를 하고 재 사용하는 것이다. 또한 initialData 를 통해서 화면 깜밖 거림을 최소화 할 수 있다.

`initialData` 는 초기 값을 미리 주어서 화면에 표시하는 것이다. 옵션이다.
`uid`, `postId` 또는 기타 문서 ID 를 주어서 캐시 된 것이 있으면 캐시 값을 사용하고, 아니면 데이터베이스에서 해당 문서를 가져와 캐시를 할 수 있도록 하는 것이다.
`cache` 값는 기본적으로 true 이며, 메모리 캐시를 한다. 만약 이 값이 false 로 지정되면, 데이터베이스의 값을 가져와 사용한다. 옵션이다.
`sync` 는 데이터베이스이 값이 변경되면 실시간으로 변경되도록 하는 것이다. 옵션이다.
`builder` 는 해당 위젯의 데이터를 화면에 직접 디자인하고자 할 때 사용한다. 옵션이다.
`errorBuilder` 는 퍼미션 에러 등의 에러가 발생할 경우 화면에 표시할 때 사용하는 위젯으로 옵션이 직접 디자인을 하고자 할 때 사용한다.
`loadingBuilder` 는 데이터를 데이터베이스로 부터 로딩 중에 표시하는 것으로 옵션이며 직접 디자인을 변경하고자 할 때 사용한다.


For instance, `UserDoc` is the one that works in this way.




## List Widgets




Use `FirestoreQueryBuilder` or `FirebaseDatabaseQueryBuilder`. Use query builder all the time.


각 모델에는 모델의 문서를 목록을 할 수 있는 ListView 와 GridView 가 있다.
예를 들면, `UserListView`, `CategoryListView`, `PostGridView` 등이 있는데, 모두 공통적으로 사용법이 비슷한 것이다.
`order` 에는 소팅 필드를 적어 줄 수 있다.
`max` 에는 최대 표시 할 개수를 적어 줄 수 있다. 최근 사용자 10명, 최근 게시글 5개 등으로 목록을 표현하고자 할 때 사용할 수 있다.


내부적으로  `FirestoreQueryBuilder` 를 사용한다.




## Display no of new invitation


```dart
ChatInvitationCount(
  builder: (count) => count == 0
      ? const Text('No invitation')
      : Padding(
          padding: const EdgeInsets.all(16),
          child: ListTile(
            leading: Stack(
              clipBehavior: Clip.none,
              children: [
                const FaIcon(
                  FontAwesomeIcons.envelope,
                ),
                Positioned(
                  top: -5,
                  right: -6,
                  child: Badge(
                    label: Text(
                      '$count',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: context.outline,
                  ),
                ),
              ],
            ),
            title: Text(
              'invitation count title'.tr(
                args: {'count': count},
                form: count,
              ),
              style: TextStyle(
                color: context.outline,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 18,
            ),
          ),
        ),
),
```


# Tests

All package developers should do tests.

## Unit test

You can follow the unit test as described in Flutter document.

The purpose of unit test is to test on the units.

The recommendation on the unit testing is to provide a test service like `LikeTestService.instance.runTests()`.

See `easy_like` for the details.





## Widget test


Do the widget test as Flutter does.


## Integration test

You would probably create an example app to build and test the package. And It's upto you to do integration-test on the example app.







# Localization, i18N

- All easy packages must use `easy_locale` for localization.
- `easy_locale` provides some default(basic) texts from `easy_locale/lib/src/locale.texts.dart`.
- When you, as an easy package developer, add text translation for your package, you have to options to put the translation
  - 1. Add it to `easy_locale/lib/src/locale.text.dart` if you think the translation text is one of the basic ones.
  - 2. Add it to the `init` method of the package service if you think the translation is only applicable to the package.




# Customization

- You can customize the screen by providing the `showXxxxScreen` callback on the service.
  - This callback function can be everywhere but should be provided by the service class.

Example:
```dart
UserService.instance.init(
  showPublicProfileScreen: (user) => CustomizedPublicProfileScreen(context: context, user: user);
);
```


- Note that, the callback **must pass** the BuildContext.



## Customizing Action Buttons

There are times that you would like to edit the action buttons on the default screens.

For instance, you want to edit the action buttons on user public profile screen.

The easy packages have a rule for this work.

- You can customize the action buttons by adding button in front and back of existing buttons.
  - The name of the builder must begin with `prefixActionBuilderOn` or `suffixActionBuilderOn`.
    - eg: `prefixActionBuilderOnXxxScreen`, `suffixActionBuilderOnXxxScreen`

- You can customze the whole action buttons by replacing the complete action buttons of a screen.
  - The name of the builder must begin with `actionBuilderOn`.
  - ex: `actionBuilderOnXxxScreen`.


