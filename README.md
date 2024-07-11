# Easy Framework


## Overview


- **Easy Frame**: This is a Flutter framework that offers a wide range of UI/UX components, logic modules, and more. It's designed to help you build apps quickly and efficiently, suitable for various types of projects.

- The framework is made up of several small, independent packages. Each package has its own specific functions but is designed to work well with others. You can use these packages individually or together in your app.

- This project aims to provide common features needed in apps as separate packages. These are available on pub.dev, making it easy for anyone to enhance their app's functionality.

Key Features:
- **Independence**: Each package is independent. You can use only what you need. For example, if your app needs a chat feature, you can just add the `easychat` package.
- **Variety**: Offers a range of packages for different needs, such as chat, member management, forums, friend management, and social features, and much more. You're also free to add any other package you find necessary.



## Install

### Install a package into your app

If you want to install easy local package, you can add like below.

```yaml
dependencies:
  easy_locale: latest
```


You can add any easy pakcages like this.


### Install as a easy frame developer

- You can fork and clone the `https://github.com/thruthesky/easy_frame` repository inside your flutter app folder.

- Then, add the dependencies like below.

```yaml
dependencies:
  easy_helpers:
  easy_locale:
  easy_storage:
  easyuser:

dependency_overrides:
  easy_helpers:
    path: ./easy_frame/easy_helpers
  easy_locale:
    path: ./easy_frame/easy_locale
  easy_storage:
    path: ./easy_frame/easy_storage
  easyuser:
    path: ./easy_frame/easyuser
```



## Packages


### Storage

This package helps your app upload photos and videos to Firebase Storage.

Please refer to the [Storage Package - easy_storage](https://pub.dev/packages/easy_storage).



### User


This package helps manage users in your app. If your app has different database structure, you can customize it to work with other `easy frame` packages by using the `easyuser` package.


Please refer to the [User Package - easyuser](https://pub.dev/packages/easyuser).



### Friend

This feature allows you to make friends and chat with each other.

Please refer to the [Friend Package - easy_friend](https://pub.dev/packages/easy_friend).


### Chat

- A package that includes all the features of a chat room

Please refer to the [Chat Package - easychat](https://pub.dev/packages/easychat).


### Forum


### Task


The task management system is a system for managing tasks that need to be done in various situations, such as company work, school assignments, and more. It can be thought of as a simple app with `TODO` functionality, or more broadly, as a work management system.


Please refer to the [Task Management System Package - easy_task](https://pub.dev/packages/easy_task).



### Locale

- easy_locale - A multilingual translation package. There are many translation packages on pub.dev, but we use the simpler easy_locale package. There's no need for you to use this package in your app, but you can if you want.



## Other packages

'
'
Although not directly related to FireFlutter, these packages are used internally by FireFlutter.

- easy_helpers - Contains various shared functions and extensions needed by FireFlutter. There's no need to use this package in your app, but you can if you want.

- date_picker_v2 for date picker. It has a very simple UI/UX. I made it because I don't like the Android and iOS UI.
- social_design_system - A beautiful UI/UX theme library.
- phone_sign_in - For phone sign in. It's good for review and testing.

- memory_cache - Used to cache various temporary values in memory.
- rxdart: ^0.27.7
- cached_network_image: ^3.3.1 Note that cached_network_image: ^3.3.1 and rxdart: ^0.27.7 versions must match. Otherwise, a dependency error occurs.