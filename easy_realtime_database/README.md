# Easy Realtime Database

This is a helper package for Firebase realtime database.



## Widgets

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


More comprehensive example:
```dart
Value(
  ref: FirebaseDatabase.instance.ref('tmp/a'),
  builder: (v, r) => TextButton(
    child: Text('Value: $v'),
    onPressed: () => r.set(
      'Time : ${DateTime.now()}',
    ),
  ),
),
Value.once(
  ref: FirebaseDatabase.instance.ref('tmp/a'),
  builder: (v, r) => TextButton(
    child: Text('Value: $v'),
    onPressed: () => r.set(
      'Time : ${DateTime.now()}',
    ),
  ),
),
```


## DatabaseLimitedListView

- See the example



## DatabaseLimitedQueryBuilder


- See the example


## ValueListView

- Use this widget to list the values of a node in Realtime database. This can handle most of the cases of listing the values of a node in Realtime database.
- If you don't call `fetchMore(index)`, it will only fetch the first page of data.
- If you want to get only the first page of list to show the latest or the oldest, you don't have to call `fetchMore`.


- In this example, it is using `PageView` to list the data. You can use `ListView`, `GridView`, `CarouselView`, or even `Column`, `Row`, or whatever.

- Use `reverseQuery` to show the oldest data first.

Example:
```dart
ValueListView(
  query: FirebaseDatabase.instance.ref('/tmp'),
  pageSize: 3,
  builder: (snapshot, fetchMore) {
    return PageView.builder(
      itemCount: snapshot.docs.length,
      itemBuilder: (context, index) {
        print('index: $index');
        fetchMore(index);
        return ListTile(
          contentPadding: const EdgeInsets.all(64),
          title: Text(snapshot.docs[index].key!),
        );
      },
    );
  },
  errorBuilder: (s) => Text('Error: $s'),
  loadingBuilder: () => const CircularProgressIndicator(),
  emptyBuilder: () => const Text('Empty'),
),
```

- The example below is using `reverseQuery` to show the oldest data first.

```dart
ValueListView(
  query: FirebaseDatabase.instance.ref('/tmp'),
  pageSize: 3,
  reverseQuery: true,
  builder: (snapshot, fetchMore) {
    return ListView.builder(
      itemCount: snapshot.docs.length,
      itemBuilder: (context, index) {
        print('index: $index');
        fetchMore(index);
        return ListTile(
          contentPadding: const EdgeInsets.all(64),
          title: Text(snapshot.docs[index].key!),
        );
      },
    );
  },
  errorBuilder: (s) => Text('Error: $s'),
  loadingBuilder: () => const CircularProgressIndicator(),
  emptyBuilder: () => const Text('Empty'),
),
```