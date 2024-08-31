# Easy connectivity

An easy package to use the Internet connectivity check.



## Call a function when internet is connected

- The `ready` callback will be call when the internet is connected. This may be called multiple times whenever the internet is on.

- The `ready` callback will be called when the app starts.

```dart
ConnectivityService.instance.init(ready: () {
    doSomethingHere();
});
```


## ConnectionReady widget

