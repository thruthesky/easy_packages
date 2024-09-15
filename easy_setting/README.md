# Easy settings

- `easy_setting` package provides an easy and nice UI/UX with the logic to manage the settings in Firestore.

- It can handle any kinds of settings including but not limited to app settings, user settings.

- Each setting is a Firestore document.

- The document id of the setting's document must be unique for the setting.


## TODO

- `sync` option.
- Security rules
- Option for using realtime database over firestore. For instance, there might be some value that is often changes and readable. The easyuser package supports firebsae and rtdb at the same time, mirror the settings data into realtime database and let it use rtdb.

## Security Rules

- For now, it does not provide any security rules. it's upto you how you define it.
  - Recommed: secure by id.
  - For instance,
    - if the document id begins with `app-` is read only.
    - if the document id begins with `<uid>-xxx` then, it is readable for everyone and writable for the user only.

## How to use

- To display and update a value, see the code below.

```dart
Setting(
  id: 'system',
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


