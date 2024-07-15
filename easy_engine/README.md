# Easy Extensions

This package is the counter part of the [easy-engine](https://github.com/thruthesky/easy-engine) of the firebase cloud functions project





# ClaimAdmin

The `EngineService.instance.claimAdmin` function allows the logged-in user to set himself as an admin. If an admin already exists, it will give an error(Exception) with the code `already-exist` and the message `Admin already exists`.

Essentially, it marks the `admin` field of the logged-in user as `true` if no other user has this field set to `true`.


- `region` is the region of your cloud functions. It is recommended to have the same region as your firestore.


```dart
ElevatedButton(
  onPressed: () async {
    try {
      await engine.claimAdmin(region: region);
      onSuccess();
    } on FirebaseFunctionsException catch (e) {
      onFailure('${e.code}/${e.message}');
    } catch (e) {
      onFailure(e.toString());
    }
  },
  child: const Text('Claim Admin'),
)
```


## ClaimAdminButton

- Use the `ClaimAdminButton` widget for simplicity, or copy its code to customize it yourself.

```dart
ClaimAdminButton(region: 'asia-northeast3'),
```

