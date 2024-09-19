import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easy_storage/easy_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class StorageService {
  static StorageService? _instance;
  static StorageService get instance => _instance ??= StorageService._();

  /// TODO: test if it properly throws an exception when the user is not signed in.
  String get myUid {
    if (FirebaseAuth.instance.currentUser == null) {
      throw Exception('StorageService::myUid -> User is not signed in');
    }
    return FirebaseAuth.instance.currentUser!.uid;
  }

  EdgeInsetsGeometry? uploadBottomSheetPadding;
  double? uploadBottomSheetSpacing;

  ///
  StorageService._();

  // StorageCustomize customize = StorageCustomize();

  /// [enableFilePickerExceptionHandler] is a flag to enable the exception
  /// handler. If it is true, it will show an error toast message when the user
  /// denies the permission to access the camera or the gallery. By default,
  /// it is true. If you want to handle the exception by yourself, set it to
  /// false.
  bool enableFilePickerExceptionHandler = true;

  init({
    // StorageCustomize? customize,
    bool? enableFilePickerExceptionHandler,
    EdgeInsetsGeometry? uploadBottomSheetPadding,
    double? uploadBottomSheetSpacing,
  }) {
    // if (customize != null) {
    //   this.customize = customize;
    // }
    if (enableFilePickerExceptionHandler != null) {
      this.enableFilePickerExceptionHandler = enableFilePickerExceptionHandler;
    }

    this.uploadBottomSheetPadding = uploadBottomSheetPadding;
    this.uploadBottomSheetSpacing = uploadBottomSheetSpacing;
  }

  /// Upload a file (or an image) to Firebase Storage.
  ///
  /// This method must be the only method that upload a file/photo into Storage
  /// or, the listing photos from `/storage` will not work properly.
  ///
  /// 범용 업로드 함수이며, 모든 곳에서 사용하면 된다.
  ///
  /// [path] is the file path on mobile phone(local storage) to upload.
  ///
  ///
  /// It returns the download url of the uploaded file.
  ///
  /// [progress] is a callback function that is called whenever the upload progress is changed.
  ///
  /// [complete] is a callback function that is called when the upload is completed.
  ///
  /// [compressQuality] is the quality of the compress for the image before uploading.
  /// 중요, compresssion 을 하면 이미지 가로/세로가 자동 보정 된다. 따라서 업로드를 하는 경우, 꼭 사용해야 하는 옵션이다.
  /// 참고로 compression 은 기본 이미지 용량의 내용에 따라 달라 진다.
  /// 이 값이 22 이면, 10M 짜리 파일이 140Kb 로 작아진다.
  /// 이 값이 70 이면, 30M 짜리 파일이 1M 로 작아진다.
  /// 이 값이 80 이면, 10M 짜리 파일이 700Kb 로 작아진다. 80 이면 충분하다. 기본 값이다.
  /// 이 값이 0 이면, compress 를 하지 않는다. 즉, 원본 사진을 그대로 올린다.
  ///
  /// [saveAs] is the path for the uploaded file to be saved in Firebase Storage.
  /// If it is null, it will be uploaded to the default path.
  ///
  /// This method does not handle any exception. You may handle it outisde if you want.
  ///
  ///
  Future<String?> uploadFile({
    Function(double)? progress,
    Function? complete,
    // Updated the default into zero
    // because videos and files will have problem
    // if we compress them using FlutterImageCompress.
    String? path,
    String? saveAs,
    String? type,
  }) async {
    if (path == null) return null;
    File file = File(path);
    if (!file.existsSync()) {
      log('File does not exist: $path');
      throw Exception('File does not exist: $path');
    }

    final storageRef = FirebaseStorage.instance.ref();
    final fileRef = storageRef.child(saveAs ?? "users/$myUid/${file.path.split('/').last}");
    // Review: Here only Image can be compressed. File and Video cannot be compressed.
    // It may cause error if you try to compress file or video.
    // So, we should check the file type before compressing.
    // Or... add custom compressing function for file and video, and/or image.
    // if (compressQuality > 0) {
    // final xfile = await FlutterImageCompress.compressAndGetFile(
    //   file.absolute.path,
    //   '${file.absolute.path}.compressed.jpg',
    //   quality: 100 - compressQuality,
    // );
    // file = File(xfile!.path);
    // }
    final uploadTask = fileRef.putFile(file);
    if (progress != null) {
      uploadTask.snapshotEvents.listen((event) {
        double rate = event.bytesTransferred / event.totalBytes;
        progress(rate < 0.2 ? 0.2 : rate);
      });
    }

    /// wait until upload-complete
    await uploadTask.whenComplete(() => complete?.call());
    final url = await fileRef.getDownloadURL();
    // print(fileRef.fullPath);

    return url;
  }

  /// Delete the uploaded file from Firebase Storage by the url.
  ///
  /// If the url is null or empty, it does nothing.
  ///
  /// If the [ref] and the [field] are passed, it will delete the field of the
  /// document when the url is deleted.
  ///
  /// When the file does not exist in Firebsae Stroage,
  /// - If the [ref] is null, it will simply returns without firing exception.
  /// - If the [ref] is set, it will delete the field in the document.
  ///
  /// You can use this method especially when the file of the url in Storage is
  /// deleted already (or not exist). It will not throw an exception and you
  /// can continue the logic.
  Future<void> delete(
    String? url, {
    DatabaseReference? ref,
    String? field,
  }) async {
    if (url == null || url == '') return;
    final storageRef = FirebaseStorage.instance.refFromURL(url);
    try {
      await storageRef.delete();
    } on FirebaseException catch (e) {
      /// Oops! The file does not exist in the Firebase Storage.
      if (e.code == 'object-not-found') {
        if (ref == null) {
          /// Return as if the file is deleted.
          return;
        }
      } else {
        log('Error deleting file on catch(FirebaseException): $url');
        log(e.toString());
        rethrow;
      }
    } catch (e) {
      log('Error deleting file on catch(e): $url');
      log(e.toString());
    }

    if (ref != null && field != null) {
      await ref.update({field: FieldValue.delete()});
    }
  }

  /// 이미지 업로드 소스(갤러리 또는 카메라) 선택창을 보여주고, 선택된 소스를 반환한다.
  ///
  /// [photoCamera] default true, 는 카메라를 선택할 수 있게 할지 여부이다.
  /// [photoGallery] default true, 는 갤러리를 선택할 수 있게 할지 여부이다.
  ///
  /// [videoCamera] default false, indicate whether to allow the video camera to be selected
  /// [videoGallery] default false, indicate whethere to allow the video gallery to be selected
  ///
  ///
  /// [fromGallery] default false, indicate whether to allow to select file from gallery
  /// [fromFile] default false, indicate whether to allow to select file from storage
  ///
  /// [spacing] default none, spacing between the selection,
  /// [padding] default EdgeInsets.zero, padding of the bottomsheet
  ///
  /// 사용자에게 사진/파일 업로드를 요청한다.
  ///
  /// 커스텀 디자인은 [customize] 에서 할 수 있다.
  Future<SourceType?> chooseUploadSource({
    required BuildContext context,
    bool? photoGallery,
    bool? photoCamera,
    bool? videoGallery,
    bool? videoCamera,
    bool? fromGallery,
    bool? fromFile,
    double? spacing,
    EdgeInsetsGeometry? padding,
  }) async {
    return await showModalBottomSheet(
      context: context,
      builder: (_) => StorageUploadSelectionBottomSheet(
        photoGallery: photoGallery,
        photoCamera: photoCamera,
        videoGallery: videoGallery,
        videoCamera: videoCamera,
        fromGallery: fromGallery,
        fromFile: fromFile,
        spacing: spacing,
        padding: padding,
      ),
    );
  }

  /// Update photos in the Firebase Storage.
  ///
  /// 사용자에게 사진/파일 업로드를 요청한다.
  ///
  /// 1. It displays the upload source selection dialog (camera or gallery).
  /// 2. It picks the file
  /// 3. It compresses the file
  /// 4. It uploads and calls back the function for the progress indicator.
  /// 5. It returns the download url of the uploaded file.
  ///
  /// If the user cancels the upload, it returns null.
  ///
  /// Ask user to upload a photo or a file
  ///
  /// Call this method when the user presses the button to upload a photo or a file.
  ///
  /// This method does not handle any exception. You may handle it outisde if you want.
  ///
  /// [saveAs] is the path on the Firebase storage to save the uploaded file.
  /// If it's empty, it willl save the file under "/users/$uid/". You can use
  /// this option to save the file under a different path.
  ///
  /// [photoCamera] is a flag to allow the user to choose the camera as the image source.
  ///
  /// [photoGallery] is a flag to allow the user to choose the gallery as the image source.
  ///
  /// [videoCamera] is a flag to allow the user to choose the camera as the video source.
  ///
  /// [videoGallery] is a flag to allow the user to choose the gallery as the video source.
  ///
  ///
  /// [fromGallery] is a flag to allow the user to choose the gallery as the file source.
  ///
  /// [fromFile] is a flag to allow the user to choose the storage as the file source.
  ///
  /// [maxHeight] is the maximum height of the image to upload.
  ///
  /// [maxWidth] is the maximum width of the image to upload.
  ///
  /// If specified, the images will be at most [maxWidth] wide and
  /// [maxHeight] tall. Otherwise the images will be returned at it's
  /// original width and height.
  ///
  /// The image compression quality is no longer supported. For using image
  /// thumbnail, refer to README.md
  ///
  /// It returns the download url of the uploaded file.
  Future<String?> upload({
    required BuildContext context,
    Function(double)? progress,
    Function()? complete,
    Function(SourceType?)? onUploadSourceSelected,
    String? saveAs,
    bool? photoCamera = true,
    bool? photoGallery = true,
    bool? videoCamera = false,
    bool? videoGallery = false,
    bool? fromGallery = false,
    bool? fromFile = false,
    double? spacing,
    EdgeInsetsGeometry? padding,
    double maxHeight = 1024,
    double maxWidth = 1024,
    int imageQuality = 95,
  }) async {
    final source = await chooseUploadSource(
      context: context,
      photoCamera: photoCamera,
      photoGallery: photoGallery,
      videoCamera: videoCamera,
      videoGallery: videoGallery,
      fromGallery: fromGallery,
      fromFile: fromFile,
      spacing: spacing,
      padding: padding,
    );
    onUploadSourceSelected?.call(source);
    if (context.mounted) {
      return await uploadFrom(
        context: context,
        source: source,
        progress: progress,
        complete: complete,
        saveAs: saveAs,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
        imageQuality: imageQuality,
      );
    }
    return null;
  }

  /// Upload a file (or an image) and save the url at the field of the document reference in Firestore.
  ///
  /// It can be any field of any document as long as it has permission.
  ///
  /// Logic
  /// 1. Upload
  /// 2. Save url at the path
  /// 3. Delete the previously existing upload (if there is an exsiting url in the field)
  ///
  /// [ref] is the document reference to save the url.
  ///
  /// example:
  /// ```dart
  /// await StorageService.instance.uploadAt(
  ///   context: context,
  ///   ref: my.ref,
  ///   filed: 'photoUrl',
  /// );
  /// ```
  Future<String?> uploadAt({
    required BuildContext context,
    required DocumentReference ref,
    required String field,
    Function(double)? progress,
    Function()? complete,
    String? saveAs,
    bool photoCamera = true,
    bool photoGallery = true,
    double maxHeight = 1024,
    double maxWidth = 1024,
    int imageQuality = 95,
    double? spacing,
    EdgeInsetsGeometry? padding,
  }) async {
    String? oldUrl;
    String? url;

    if (context.mounted == false) return null;

    /// Get the previous document and the url
    final snapshot = await ref.get();
    if (snapshot.exists) {
      final Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.data() as Map);
      oldUrl = data[field];
    }

    if (context.mounted) {
      url = await upload(
        context: context,
        progress: progress,
        complete: complete,
        saveAs: saveAs,
        photoCamera: photoCamera,
        photoGallery: photoGallery,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
        imageQuality: imageQuality,
        spacing: spacing,
        padding: padding,
      );
    }

    /// If the upload is canceled, return null
    if (url == null) return null;

    /// Upload success, update the field
    if (!snapshot.exists) {
      ref.set({field: url});
    } else {
      ref.update({field: url});
    }

    /// Delete old url
    ///
    if (oldUrl != null) {
      await delete(oldUrl);
    }
    return url;
  }

  /// Call this if method of uploading (like, from camera) is already known.
  ///
  /// [source] can be SourceType.photoGallery, SourceType.photoCamera,
  /// SourceType.videoGallery, SourceType.videoCamera, SourceType.file
  /// may return null if [source] is invalid.
  Future<String?> uploadFrom({
    required BuildContext context,
    required SourceType? source,
    Function(double)? progress,
    Function? complete,
    String? saveAs,
    String? type,
    double maxHeight = 1024,
    double maxWidth = 1024,
    int imageQuality = 95,
  }) async {
    if (source == null) return null;
    String? path = await getFilePathFromPicker(
      context: context,
      source: source,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
    );
    if (path == null) return null;
    return await uploadFile(
      path: path,
      saveAs: saveAs,
      progress: progress,
      complete: complete,
      type: type,
    );
  }

  Future<String?> getFilePathFromPicker({
    required BuildContext context,
    required SourceType? source,
    double maxHeight = 1024,
    double maxWidth = 1024,
    int imageQuality = 95,
  }) async {
    if (source == null) return null;

    try {
      if (source == SourceType.photoCamera) {
        final XFile? image = await ImagePicker().pickImage(
          source: ImageSource.camera,
          maxHeight: maxHeight,
          maxWidth: maxWidth,
          imageQuality: imageQuality,
        );
        return image?.path;
      } else if (source == SourceType.photoGallery) {
        final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
        return image?.path;
      } else if (source == SourceType.videoCamera) {
        final XFile? video = await ImagePicker().pickVideo(source: ImageSource.camera);
        return video?.path;
      } else if (source == SourceType.videoGallery) {
        final XFile? video = await ImagePicker().pickVideo(source: ImageSource.gallery);
        return video?.path;
      } else if (source == SourceType.mediaGallery) {
        final XFile? image = await ImagePicker().pickMedia();
        return image?.path;
      } else if (source == SourceType.file) {
        final FilePickerResult? result = await FilePicker.platform.pickFiles();
        return result?.files.first.path;
      }
      return null;
    } on PlatformException catch (error) {
      if (enableFilePickerExceptionHandler == false) rethrow;

      if (error.code == 'photo_access_denied') {
        errorToast(
          context: context,
          title: Text('Gallery Access Denied'.t),
          message: Text('Access permission to the gallery has been denied'.t),
        );
      } else if (error.code == 'camera_access_denied') {
        errorToast(
          context: context,
          title: Text('Camera Access Denied'.t),
          message: Text('Access permission to the Camera has been denied'.t),
        );
      } else {
        /// rethrow the unhandled error from PlatformException if there's any
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<List<String?>?> uploadMultiple({
    Function(double)? progress,
    Function? complete,
    String? type,
    double maxHeight = 1024,
    double maxWidth = 1024,
  }) async {
    final pickedFiles = await ImagePicker().pickMultiImage(
      imageQuality: 100,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
    );
    List<XFile> xFilePicks = pickedFiles;

    if (xFilePicks.isEmpty) return null;
    List<Future<String?>> uploads = [];
    for (XFile xFilePick in xFilePicks) {
      uploads.add(uploadFile(
        path: xFilePick.path,
        progress: progress,
        complete: complete,
        type: type,
      ));
    }
    return Future.wait(uploads);
  }

  /// 여러 이미지를 화면에 보여준다.
  ///
  // showUploads(BuildContext context, List<String> urls, {int index = 0}) {
  //   // if (customize.showUploads != null) {
  //   //   return customize.showUploads!(context, urls, index: index);
  //   // }
  //   showGeneralDialog(
  //     context: context,
  //     pageBuilder: (context, _, __) =>
  //         DefaultImageCarouselScaffold(urls: urls, index: index),
  //   );
  // }

  // Future<List<String>> getAllImagesUrl(String uid) async {
  //   List<String> imageUrls = [];

  //   Reference storageRef =
  //       FirebaseStorage.instance.ref().child('users').child(uid);
  //   ListResult result = await storageRef.listAll();

  //   for (Reference ref in result.items) {
  //     String downloadUrl = await ref.getDownloadURL();
  //     imageUrls.add(downloadUrl);
  //   }

  //   return imageUrls;
  // }
}
