# Easy Post

A post management library for Firebase and Fltuter.

# Database structure

- To acheive the concept of `single source of truth (SSOT)`, we came up an idea of saving all the data in `posts` node.
  - If there is an attack of writing too much data in the `posts` node like saving too long data into title or content, then you can add a security rules to validate that the size of title and content to be lower than 1K or something.


- `posts` is a list of posts with only meta data. Especially excluding big content like `content` field.
  - The strucutre of `posts` is like below

```json
/posts
  /$postKey {
    "category": "qna-1630000000000",
    "order": -1630000000000,
    "uid": "uid",
    "title": "title",
    "content": "content",
    "urls": ["url1", "url2"],
    "youtubeUrl": "youtubeUrl",
    "createdAt": 1630000000000,
    "updatedAt": 1630000000000
  }
```


```dart
final ref = PostService.instance.postsRef
    .orderByChild('category')
    .startAt('$category-')
    .endAt('$category-9999999999999999999999');

final snapshot = await ref.get();
for (var v in snapshot.children) {
  log('v: ${v.key}, value: ${(v.value as Map)["title"]}');
}
```

# Known Issues

## flutter_inappwebview_ios issue - Method does not override any mehtod from its superclass

Override the patch like below.

```yaml
dependency_overrides:
  # TODO: Recheck once flutter_inappwebview version >6.0.0 is released
  flutter_inappwebview_ios:
    git:
      url: https://github.com/IncM/flutter_inappwebview
      path: flutter_inappwebview_ios
      ref: cbc214c7b2cf5fd7996ff2e9e25d203946b74bc3
```

Error messages

```txt
Swift Compiler Error (Xcode): Method does not override any method from its superclass
/Users/thruthesky/.pub-cache/hosted/pub.dev/flutter_inappwebview_ios-1.0.13/ios/Classes/InAppWebView/
InAppWebView.swift:1431:25


Swift Compiler Error (Xcode): Ambiguous use of 'evaluateJavaScript(_:completionHandler:)'
/Users/thruthesky/.pub-cache/hosted/pub.dev/flutter_inappwebview_ios-1.0.13/ios/Classes/InAppWebView/
InAppWebView.swift:1035:20


Swift Compiler Error (Xcode): Ambiguous use of 'evaluateJavaScript(_:completionHandler:)'
/Users/thruthesky/.pub-cache/hosted/pub.dev/flutter_inappwebview_ios-1.0.13/ios/Classes/InAppWebView/
InAppWebView.swift:1038:16


Swift Compiler Error (Xcode): Ambiguous use of 'evaluateJavaScript(_:completionHandler:)'
/Users/thruthesky/.pub-cache/hosted/pub.dev/flutter_inappwebview_ios-1.0.13/ios/Classes/InAppWebView/
InAppWebView.swift:1047:20


Swift Compiler Error (Xcode): Ambiguous use of 'evaluateJavaScript(_:completionHandler:)'
/Users/thruthesky/.pub-cache/hosted/pub.dev/flutter_inappwebview_ios-1.0.13/ios/Classes/InAppWebView/
InAppWebView.swift:1050:16


Swift Compiler Error (Xcode): Ambiguous use of 'evaluateJavaScript(_:completionHandler:)'
/Users/thruthesky/.pub-cache/hosted/pub.dev/flutter_inappwebview_ios-1.0.13/ios/Classes/InAppWebView/
InAppWebView.swift:1327:25


Swift Compiler Error (Xcode): Ambiguous use of 'evaluateJavaScript(_:completionHandler:)'
/Users/thruthesky/.pub-cache/hosted/pub.dev/flutter_inappwebview_ios-1.0.13/ios/Classes/InAppWebView/
InAppWebView.swift:1912:8


Swift Compiler Error (Xcode): Ambiguous use of 'evaluateJavaScript(_:completionHandler:)'
/Users/thruthesky/.pub-cache/hosted/pub.dev/flutter_inappwebview_ios-1.0.13/ios/Classes/InAppWebView/
InAppWebView.swift:2859:22


Swift Compiler Error (Xcode): Ambiguous use of 'evaluateJavaScript(_:completionHandler:)'
/Users/thruthesky/.pub-cache/hosted/pub.dev/flutter_inappwebview_ios-1.0.13/ios/Classes/InAppWebView/
InAppWebView.swift:2870:22


Swift Compiler Error (Xcode): Ambiguous use of 'evaluateJavaScript(_:completionHandler:)'
/Users/thruthesky/.pub-cache/hosted/pub.dev/flutter_inappwebview_ios-1.0.13/ios/Classes/InAppWebView/
InAppWebView.swift:2964:17


Encountered error while building for device.
```
