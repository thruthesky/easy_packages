# Easy app settings

- `easy_app_setting` package provides an easy and nice UI/UX with the logic to manage the settings in realtime database.

- It is a simple container that can provide an extra data that can be used by all users.

- It can have any kinds of settings.

## TODO

- `sync` option.
- Separate user settings and app settings.
- Option for using realtime database over firestore. For instance, there might be some value that is often changes and readable. The easyuser package supports firebsae and rtdb at the same time, mirror the settings data into realtime database and let it use rtdb.

## Security Rules

- Install the [database security rules](../docs/database_security_rules.json) file.

## Database Structure

- `/app-settings`: is the node of each app's settings.

  - `/app-settings/<uid>`: is the app's settings node.
    - `/app-settings/<uid>/<key>`: is the key of the setting.
    - `/app-settings/<uid>/<key>: value`: is the value of the setting.

- The data is public, the users can only read the data. The admin is the only one who can write.



## How to use

- To display and update a value, see the code below.
- You can use `field` to get the value from the app settings. It can have a path like `puzzle/defaultBoardImageUrls` or `puzzle/defaultBoardImageUrls/0`.

```dart
AppSettings(
  field: 'puzzle/defaultBoardImageUrls',
  builder: (sm, r) {
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

### Save app setting

- Use `AppSettingService.instance.update` to update the user settings. It will create if it does not exist.

```dart
AppSettingService.instance.update(
  key: 'fruit',
  value: 'Apple',
);
```

### Get app setting

- Use `AppSettingService.instance.get` to get the user settings.

```dart
final fruit = await AppSettingService.instance.get('fruit');
```
