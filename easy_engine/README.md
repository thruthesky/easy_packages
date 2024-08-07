# Easy Extensions

The `easy_engine` package is the counter part of the [easy-engine](https://github.com/thruthesky/easy-engine) built as the firebase cloud functions to support various essential features that cannot be done from font-end applications like enabling and disabling user account, sending push notifications, and more.


# Why the cloud functions?

- Refer [Why cloud functions?](https://github.com/thruthesky/easy-engine?tab=readme-ov-file#why-cloud-functions) at the `easy-engine` cloud function project.



# ClaimAdmin

- This function is optional. You can set a user as an admin without this function. You can simply open the `Firebase console -> Firestore -> look for user document -> set admin field to true` to make a user as an admin.

- The `EngineService.instance.claimAdmin` function allows the logged-in user to set himself as an admin. If an admin already exists, it will give an error(Exception) with the code `already-exist` and the message `Admin already exists`.

- Essentially, it marks the `admin` field of the logged-in user as `true` if no other user has this field set to `true`.

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



# Delete Account

- This fucntion provides a better user experience to users and easy to develop the `recent-login` logic to developers.

- This function is optional. You can develop the `recent-login` procedure in your app without installing this function.

- As stated in [the official document of Apple developer's page](https://developer.apple.com/support/offering-account-deletion-in-your-app/), it is mandatory to provide a way of deleting their own account to users.

- The code below only provides the account deletion only. It is up to the app how to delete all the user related data and sign out.
  - If the cloud function is called again when the user account is deleted, it will throw an error of `internal`.

```dart
ElevatedButton(
  onPressed: () async {
    try {
      final re = await engine.deleteAccount();
      print(re);
    } on FirebaseFunctionsException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Error: ${e.code}/${e.message}'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'), // e.code: internal, e.message: INTERNAL
        ),
      );
    }
  },
  child: const Text('Delete Account'),
),
```


# Push notifications

- This package does not handle the push notifications, see the `easy_messaging` for sending messages using easy engine.

