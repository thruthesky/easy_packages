# Easy Url Preview

This package helps to get and display the url preview.


## Features

- Get the preview data of the url.
- Display the preview data in a widget.
- Save the preview data to local storage and reuse it.

## Known issues

- When this package is used in web, the preview data may not be loaded due to the CORS policy. It is recommended to use this package in mobile apps.

## UrlPreview widget

- `text`: The text that contains the url.
- `maxLinesOfDescription`: The maximum number of lines to display the description. Default is 2.


### How to use

```dart
SizedBox(
  width: MediaQuery.sizeOf(context).width * .6,
  child: UrlPreview(
        text: "This is the text: https://www.flutterflow.io/flutterflow-developer-groups."
    ),
),
```


## How to get preview data

- Create an instance of `UrlPreviewModel`.
- Load the preview data by calling `load` method with the text that contains the url.
- Check if it has the preview data by calling `hasData`.
- Save the preview data to database for later use. Once the preview data is saved, the app can display the preview data without loading it again.


Example:
Note, this code may not work as it is. You need to implement the `database` class to save the preview data.
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


## How to dispay the preview

You can pass `text` to `UrlPreview` widget to display the preview data. The `text` should contain the url.

Or once, you have the preview data, you can pass the data to `UrlPreview` widget to display the preview data without loading it.

```dart
 UrlPreview(
    previewUrl: message.previewUrl!,
    title: message.previewTitle,
    description:
        message.previewDescription,
    imageUrl: message.previewImageUrl,
),
```

