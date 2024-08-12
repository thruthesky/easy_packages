# Easy Realtime Database

This is a helper package for Firebase realtime database.



## How to use

### Value and toggle

You can use with the combination of `Value` widget and `toggle` function to toggle a value of a node(path) in Realtime database.

```dart
Value(
  ref: FirebaseDatabase.instance.ref('/test/value'),
  builder: (v, r) => IconButton(
    icon: Text('Value Test: $v'),
    onPressed: () => toggle(r, 'yo'),
  ),
),
```

