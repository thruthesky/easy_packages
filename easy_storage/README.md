# Easy Stroage

This package provides easy to upload files and other media into Firebase Storage.



## Installation


- The app must config and initialize with Firebase before using this package.
- The user must be signed in to upload into Storage. Anonymous login is okay.
- The app must have all the setup that are required to use Camera and Gallery. For iOS, the app needs the entitlements of Camera and Gallery.
- The Firebase Storage must be ready and the security rules are porperly setup.

### Security rules

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

### iOS

Add these entitlements for allowing the app to use Camera and Gallery.

```
<key>NSPhotoLibraryUsageDescription</key>
<string>This app requires access to the photo library to share the photo on profile, chat, forum.</string>
<key>NSCameraUsageDescription</key>
<string>This app requires access to the camera to share the photo on profile, chat, forum.</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>In order to perform voice-based tasks, this app requires permission to recognize recorded audio.</string>
<key>NSMicrophoneUsageDescription</key>
<string>In order to perform voice-based tasks, this app requires permission to access the microphone.</string>
```



## How to use


```dart
StorageService.instance.upload(
    camera: true,
    gallery: true,
);
```

```dart
StorageService.instance.uploadAt(
    documentReference: my.ref,
    camera: true,
    gallery: false,
);
```

