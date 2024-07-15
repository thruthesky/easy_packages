# Easy Helpers


Helper classes, functions, and extensions for FireFlutter

## BuildContext
There might be a  case that you need to have access on the current context but  the widget does not have direct access to `BuildContext` or the current context was dispose or unmounted from the widget tree but you still need the current context. you can use `HelperService.instance.globalContext` this allows you to have access to the current `BuildContext`

```dart
Helperfinal GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey();
BuildContext get globalContext => globalNavigatorKey.currentContext!;

HelperService.instance.init(
    globalContext: () => globalContext,
)
```

## Packages
- intl
