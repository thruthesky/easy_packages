# Easy Url Preview

This package helps to get and display the url preview.


## How to get preview data


```dart
// Define an instance of UrlPreviewModel
final model = UrlPreviewModel();

// Load the site preview
await model.load("This is the text and url: https://google.com.");

// Check if it has the preview data and save it to database.
if (model.hasData) {
    await database.save(
        previewUrl: model.firstLink,
        previewTitle: model.title,
        previewDescription: model.description,
        previewImageUrl: model.image,
    );
}
```


## How to dispay the preview UI

Simply use `UrlPreview` Wdiget to display the preview data. Or, you can copy the code of `UrlPreview` and customize your own UI.


```dart
 UrlPreview(
    previewUrl: message.previewUrl!,
    title: message.previewTitle,
    description:
        message.previewDescription,
    imageUrl: message.previewImageUrl,
),
```

