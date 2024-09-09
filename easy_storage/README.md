# Easy Stroage

This package provides easy to upload photos and files into the Firebase Storage.

- Uploads are typically done through the `StorageService.instance.upload` function. When you call this function, a popup window appears, allowing you to choose whether to upload from the gallery or from the camera. Once you make a selection, the upload proceeds.

- Uploaded files are stored in the Storage at the `/users/<uid>` path.

- [Easy Stroage](#easy-stroage)
- [Installation](#installation)
  - [Security rules](#security-rules)
  - [iOS](#ios)
- [TODO](#todo)
- [Upload](#upload)
  - [UploadAt](#uploadat)
  - [Upload mutiple images](#upload-mutiple-images)
  - [Upload in a button](#upload-in-a-button)
- [Delete](#delete)
- [Error handling](#error-handling)
- [Widgets](#widgets)
  - [ImageUploadCard](#imageuploadcard)
  - [UploadForm](#uploadform)
- [Thumbnails](#thumbnails)
  - [Custom UI/UX](#custom-uiux)
    - [Customizing the upload bottom sheet UI](#customizing-the-upload-bottom-sheet-ui)



# Installation

- The app must config and initialize with Firebase before using this package.
- The user must be signed in to upload into Storage. Anonymous login is okay.
- The app must have all the setup that are required to use Camera and Gallery. For iOS, the app needs the entitlements of Camera and Gallery.
- The Firebase Storage must be ready and the security rules are porperly setup.

## Security rules

```sh
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if false;
    }
    match /users/{userId}/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth.uid == userId;
    }
  }
}
```

## iOS

Add these entitlements for allowing the app to use Camera and Gallery.

```
<key>NSPhotoLibraryUsageDescription</key>
<string>This app requires access to the photo library to share the photo on profile, chat, forum.</string>
<key>NSCameraUsageDescription</key>
<string>This app requires access to the camera to share the photo on profile, chat, forum.</string>
```

# TODO

- Give an option to `init` that if the thumbnails are being used.
- When the original image is deleted, delete the thumbnails.
- When the image resizing (thumbnailing) is done, update the document
  - To do this, there must be a code to know if the upload belongs to post, comment, chat, or user photo, etc and there must be a document id also.
    - **Can it be saved in the path of file name??**
  - This way, it is much easier to use the thumbnail since we know that the document(chat, post, comemnt, user, etc) has thumbnail or now.

# Upload

Below is an example of uploading. When you click the button, it calls the `StorageService.instance.upload` function to perform the upload. You just need to call the upload function when necessary. Especially, you can appropriately adjust the size of `maxWidth`, and `maxHeight`.

To customize upload source. By default `photoCamera`, and `photoGallery` is set to true. To show other upload source you can set them to true. Other available upload source, `videoCamera`, `videoGallery`, `gallery`, `file`.

- Upload image to firebase cloud storage.

```dart
StorageService.instance.upload(
    photoCamera = true,
    photoGallery = true,
    progress: (p) => setState(()  => progress = p),
    complete: () => setState(() => progress = null),
);
```

## UploadAt

Upload a file (or an image) and save the url at the field of the document in Firestore. It can be any field of any document as long as it has permission.

You may do this working without `uploadAt` like below.

```dart
// Upload new image
final url = await StorageService.instance.upload(
    context: context,
);
if (url == null) return;

// Get the previous image
final oldUrl = UserService.instance.user?.photoUrl;

// Save new image
await user.update(
    photoUrl: url,
);

// Delete previous image
await StorageService.instance.delete(oldUrl);
```

With `uploadAt`, you can do blelow,

```dart
await StorageService.instance.uploadAt(
    context: context,
    ref: my.ref,
    field: 'photoUrl',
);
```

## Upload mutiple images

- Uploading muliple image in Firebase Cloud Storage.

```dart
StorageService.intance.uploadMultiple(
    progress: (p) => setState(()  => progress = p),
    complete: () => setState(() => progress = null),
);
```

## Upload in a button

```dart
IconButton(
    icon: widget.cameraIcon ?? const Icon(Icons.camera_alt),
    onPressed: () async {
        This is the upload
        final url = await StorageService.instance.upload(
            context: context,
            camera: true,
            gallery: true,
            maxWidth: 800,
            maxHeight: 800,
        );
        if (url == null) return;
        print("Your uploaded file url is $url");
    },
),
```

# Delete

- Deleteing image from Firebase cloud storage

````dart

```dart
final url = await StorageService.instance.upload( ... );

// Delete existing image
await StorageService.instance.delete(url);
````

````

- Deleting image from Firebase cloud storage and url path save in Firebase cloud firestore.

```dart
StorageService.intance.delete(url, ref: myDocumentRef, field: 'url');
````

# Error handling

By default, `easy_storage` package handles errors that appears when users upload files. If the user denies the permission, the app won't be able to select media (such as photos), and an exception occurs internally in the app. This kind error is handled if `enableFilePickerExceptionHandler` is set to true.

```dart
StorageService.instance.init(
  enableFilePickerExceptionHandler: true,
)
```

If you want to handle the error yourself, set this false and you should handle this kinds of error in the `RunZonedGuarded`.

# Widgets

## ImageUploadCard

- The `ImageUploadCard` widget simplifies the image uploading process.
- The difference between `ImageUploadCard` and `ImageUploadIconButton` is that, you can customize any shape(UI) with `ImageUploadCard` widget while `ImageUploadIconButton` shows an IconButon to upload an image where you can customize icon only.

```dart
ImageUploadCard(
  icon: Icon(
    Icons.person,
    size: 100,
  ),
  title: Text('Icon'),
  subtitle: Text('Upload an Icon'),
),
```

- To display an upload UI with custom design, you can do the following.

```dart
ImageUploadCard(
  icon: Icon(
    Icons.photo,
    size: 80,
  ),
  imageBuilder: (child) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(48),
      child: Container(
        color: Theme.of(context).primaryColor.withOpacity(0.2),
        width: 120,
        height: 120,
        child: child,
      ),
    );
  },
  progressBar: false,
  progressIndicatorBackdrop: false,
),
```

- Upload image and save the url in the Firestore document.

```dart
ImageUploadCard(
  initialData: my.photoUrl,
  ref: my.ref,
  field: 'photoUrl',
  icon: const Icon(
    Icons.image,
    size: 80,
  ),
  title: const Text('Profile Photo'),
  subtitle: const Text('Please upload profile photo'),
),
```

- Default upload icon.

```dart
UploadIconButton(
  onUpload: (u) => setState(() => url = u),
  progress: (p) => setState(() => progress = p),
  complete: () => setState(() => progress = null),
)
```

- File upload icon.

```dart
FileUploadIconButton(
  onUpload: (u) => setState(() => url = u),
  progress: (p) => setState(() => progress = p),
  complete: () => setState(() => progress = null),
)
```

- Video upload icon.

```dart
VideoUploadIconButton(
  onUpload: (u) => setState(() => url = u),
  progress: (p) => setState(() => progress = p),
  complete: () => setState(() => progress = null),
)
```

- Image upload icon.

```dart
ImageUploadIconButton(
  onUpload: (u) => setState(() => url = u),
  progress: (p) => setState(() => progress = p),
  complete: () => setState(() => progress = null),
)
```

## UploadForm

- `UploadForm` is a handy widget that provides an opinionated UI. It includes an upload button, showing the progress bar while uploading, and displaying the uploaded photos with delete button. It also provide `onUpload` and `onDelete` callback funtion.

- One thing to note is that, the `urls` parameter will be updated as call-by-reference. So, when the button is pressed, it will get the updated value. So, the parameter of urls must be a List of String that can be modified.

```dart
List<String> urls = List<String>.from([
  'https://firebasestorage.googleapis.com/v0/b/withcenter-test-5.appspot.com/o/users%2FZpq96ARrWbag4bttq4wOgJ577is2%2Fimage_picker_0D7D6009-3E8D-45EF-8FCA-297DABB66508-72557-00000228C41CA5C5.jpg?alt=media&token=871fdca5-c018-47fe-a35e-a96ee5d4ef32',
]);
UploadForm(
  urls: urls,
  onUpload: (url) {
    debugPrint('Uploaded: $url');
  },
  onDelete: (url) {
    debugPrint('Deleted: $url');
  },
  button: ElevatedButton(
    onPressed: () {
      debugPrint('Upload Form');
      dog(urls);
    },
    child: const Text('Submit'),
  ),
),
```

# Thumbnails

To add thumbnail support in `easy_storage`, follow these steps:

1. Install the [Image Resize Extension](https://extensions.dev/extensions/firebase/storage-resize-images) three times(instances) with the following configurations;

2. Install three instances of the image resize extension.

- Each size of the instance must be 200x200 (small), 600x600 (medium), 1200x1200 (large)
- And with the same settings below
  - Deletion of original file: false (No)
  - Make resize images public: true (Yes)
  - Convert images to prefered type: webp
  - Assign new access token: false (No)

Keep in mind that the easy packages(like easy user, easy post, etc) should not use thumbnails directly. Thumbnails are for app developers to enhance their apps, not for the packages themselves.

App eevelopers can also adjust image quality, and set maximum width and height to reduce the size of images they upload with the `StorageService.instance.upload()` method.

Note: The `Image Resize` extension keeps the original aspect ratio of images. So, thumbnails might be square or rectangular, depending on the original image.

To access thumbnail links:

- Use `url.thumbnail` for a small size.
- Use `url.thumbnailMedium` for a medium size.
- Use `url.thumbnailLarge` for a large size.

You can also use `ThumbnailImage` widget to display image.

## Custom UI/UX

### Customizing the upload bottom sheet UI

- To give padding on upload source bottomsheet spaces between the bottom sheet items, you can set the `uploadBottomSheetPadding` and `uploadBottomSheetSpacing` during the initialization like below.

```dart
StorageService.instance.init(
  uploadBottomSheetPadding: const EdgeInsets.all(16),
  uploadBottomSheetSpacing: 16,
);
```

- To give padding on upload source bottomsheet and space between the bottomsheet items, on `specific upload widgets` you can set the `uploadBottomSheetPadding` and `uploadBottomSheetSpacing` inline with the widget.

```dart
UploadIconButton.image(
  uploadBottomSheetPadding: const EdgeInsets.all(32),
  uploadBottomSheetSpacing: 32,
  onUpload: (url) {
    debugPrint('Uploaded: $url');
  },
)
```




# Developer's Tip


## How to select files without uploading to Storage

- `easy_storage` is primarily designed to upload files into the Firebase Storage.
  - But you can use it for selecting files without uploading to Storage. Or you can select and display on the screen and ask confirmation from the user and uploading it.

Example: the code below picks files and save the path to imagePath variable. You can then use FileImage provider or something similar to display the picked object on the screen.

```dart
final source = await StorageService.instance.chooseUploadSource(
  context: context,
  photoCamera: true,
  photoGallery: true,
  spacing: 8,
  padding: const EdgeInsets.all(8),
);

if (mounted) {
  imagePath = await StorageService.instance.getFilePathFromPicker(
    context: context,
    source: source,
    maxHeight: 1024,
    maxWidth: 1024,
  );

  if (imagePath != null) {
    setState(() {});
  }
}
```


## How to upload files without selecting

- If you have a file(or photo, video, what so ever), you can upload it to the Firebase Storage.
- `uploadFile` will handle the upload.





