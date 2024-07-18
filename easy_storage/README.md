# Easy Stroage

This package provides easy to upload photos and files into the Firebase Storage.

- Uploads are typically done through the `StorageService.instance.upload` function. When you call this function, a popup window appears, allowing you to choose whether to upload from the gallery or from the camera. Once you make a selection, the upload proceeds.

- Uploaded files are stored in the Storage at the `/users/<uid>` path.

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
        // This is the upload
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

## ImageUpload

- The `ImageUpload` widget simplifies the image uploading process.
- The difference between `ImageUpload` and `ImageUploadIconButton` is that, you can customize any shape(UI) with `ImageUpload` widget while `ImageUploadIconButton` shows an IconButon to upload an image where you can customize icon only.

```dart
ImageUpload(
  icon: Icon(
    Icons.person,
    size: 100,
  ),
  title: Text('Icon'),
  subtitle: Text('Upload an Icon'),
),
```

- Upload image and save the url in the Firestore document.

```dart
ImageUpload(
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



# Thumbnails


- This package support 3 thumbnails
  - Small as 200x200
  - Medium as 600x600
  - Large as 1200x1200


- How to use thumbail
  - `url.thumbnail` as small
  - `url.thumbnailMedium` as medium
  - `url.thumbnailLarge` as large image.
  - 