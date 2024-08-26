# Easy settings

- `easy_setting` package provides an easy and nice UI/UX and the logic to manage user's settings in Firestore.
- It can handle any kinds of settings.


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
