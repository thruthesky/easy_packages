# Easy user settings

- `easy_user_setting` package provides an easy and nice UI/UX with the logic to manage the settings in realtime database.

- It is a simple container for the user's extra data. The user data is used in many places and it's public. If is' too large, it will cost more. And it cannot save private data like password, email, etc.

- It can have any kinds of settings.


## TODO

- `sync` option.
- Separate user settings and app settings.
- Option for using realtime database over firestore. For instance, there might be some value that is often changes and readable. The easyuser package supports firebsae and rtdb at the same time, mirror the settings data into realtime database and let it use rtdb.

## Security Rules


- Install the [database security rules](../docs/database_security_rules.json) file.


## Database Structure


- `/user-settings`: is the node of each user's settings.
  - `/user-settings/<uid>`: is the user's settings node.
    - `/user-settings/<uid>/<key>`: is the key of the setting.
    - `/user-settings/<uid>/<key>: value`: is the value of the setting.

- The data is private and only the user can read and write.


## How to use

- To display and update a value, see the code below.

```dart
UserSettingModel(
  builder: (sm) {
    return ListTile(
      title: Text('System count: ${sm.value<int>('count') ?? 0}'),
      onTap: () {
        // Update any form of data.
        sm.update({'count': (sm.value<int>('count') ?? 0) + 1});
      },
    );
  },
),
```

- For incrementing or decremeting an integer value, you can use below
```dart
sm.increment('count');
```


- For user settings, you can use the user's firebase auth uid like below.

```dart
Setting(
  id: FirebaseAuth.instance.currentUser!.uid,
  builder: (sm) {
    return ListTile(
      title: Text('I like: ${sm.value<String>('fruit') ?? '...'}'),
      subtitle: Row(
        children: [
          TextButton(
            child: const Text('Apple'),
            onPressed: () {
              sm.update({'fruit': 'Apple'});
            },
          ),
          TextButton(
            child: const Text('Banna'),
            onPressed: () {
              sm.update({'fruit': 'Banana'});
            },
          ),
        ],
      ),
    );
  },
),
```


