# Firestore Helper

A helper package to make the firestore easy.


## Document

Update the widget when docuemnt changes.


```dart
Document(
  collectionName: 'settings',
  id: id,
  builder: (model) {
    return builder(model);
  },
);
```

## DocumentModel

The data model of the doucment.

```dart
Setting(
  id: 'system',
  builder: (DocumentModel doc) {
    return ListTile(
      title: Text('System count: ${doc.value<int>('count') ?? 0}'),
      onTap: () {
        doc.increment('count');
      },
    );
  },
),
```


## FirestoreLimitedListView

Purpose:
To display the limited numbrer of document as a listview.

## FirestoreLimitedQueryBuilder

Purpose:
To get the limited number of document by query



