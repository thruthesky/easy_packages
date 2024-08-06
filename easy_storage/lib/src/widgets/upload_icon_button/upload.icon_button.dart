import 'package:easy_storage/easy_storage.dart';
import 'package:flutter/material.dart';

/// General Upload Icon Button
///
/// This widget is displaying an IconButton and is used to upload an image,
/// video, or file.
///
/// You can change the following `photoCamera,photoGallery,videoCamera,videoGallery,fromGallery,fromFile` upload source property
/// with bool value true/false if you want to limit the upload source.
///
/// Or Simply use the following named constructor to:
///
/// Upload specific types of files you can use the name constructor:
/// [UploadIconButton.image], [UploadIconButton.video],  [UploadIconButton.file].
///
/// The [onUpload] function is called when the upload is complete.
class UploadIconButton extends StatelessWidget {
  const UploadIconButton({
    super.key,
    required this.onUpload,
    this.onUploadSourceSelected,
    this.photoCamera = true,
    this.photoGallery = true,
    this.videoCamera = true,
    this.videoGallery = true,
    this.fromGallery = true,
    this.fromFile = true,
    this.progress,
    this.complete,
    this.icon = const Icon(Icons.add),
    this.iconSize,
    this.visualDensity,
    this.iconPadding,
    this.uploadBottomSheetPadding,
    this.uploadBottomSheetSpacing,
  });

  final void Function(String url) onUpload;
  final void Function(SourceType?)? onUploadSourceSelected;

  final Widget icon;
  final Function(double)? progress;
  final Function()? complete;
  final VisualDensity? visualDensity;

  final bool photoCamera;
  final bool photoGallery;

  final bool videoCamera;
  final bool videoGallery;

  final bool fromGallery;
  final bool fromFile;

  final double? iconSize;
  final EdgeInsetsGeometry? iconPadding;
  final EdgeInsetsGeometry? uploadBottomSheetPadding;
  final double? uploadBottomSheetSpacing;

  /// Upload Icon Button for Image from Galery and Camera
  const UploadIconButton.image({
    required this.onUpload,
    super.key,
    this.onUploadSourceSelected,
    this.photoCamera = true,
    this.photoGallery = true,
    this.progress,
    this.complete,
    this.icon = const Icon(Icons.camera_alt),
    this.iconSize,
    this.visualDensity,
    this.iconPadding,
    this.uploadBottomSheetPadding,
    this.uploadBottomSheetSpacing,
  })  : videoCamera = false,
        videoGallery = false,
        fromGallery = false,
        fromFile = false;

  /// Upload Icon Button for Video from Galery and Camera
  const UploadIconButton.video({
    required this.onUpload,
    super.key,
    this.onUploadSourceSelected,
    this.videoCamera = true,
    this.videoGallery = true,
    this.progress,
    this.complete,
    this.icon = const Icon(Icons.videocam),
    this.iconSize,
    this.visualDensity,
    this.iconPadding,
    this.uploadBottomSheetPadding,
    this.uploadBottomSheetSpacing,
  })  : photoCamera = false,
        photoGallery = false,
        fromGallery = false,
        fromFile = false;

  /// Upload Icon Button for files from Gallery and file storage
  const UploadIconButton.file({
    required this.onUpload,
    super.key,
    this.onUploadSourceSelected,
    this.fromGallery = true,
    this.fromFile = true,
    this.progress,
    this.complete,
    this.icon = const Icon(Icons.attach_file),
    this.iconSize,
    this.visualDensity,
    this.iconPadding,
    this.uploadBottomSheetPadding,
    this.uploadBottomSheetSpacing,
  })  : photoCamera = false,
        photoGallery = false,
        videoCamera = false,
        videoGallery = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon,
      iconSize: iconSize,
      visualDensity: visualDensity,
      padding: iconPadding,
      onPressed: () async {
        final uploadedUrl = await StorageService.instance.upload(
          context: context,
          photoGallery: photoGallery,
          photoCamera: photoCamera,
          videoGallery: videoGallery,
          videoCamera: videoCamera,
          fromGallery: fromGallery,
          fromFile: fromFile,
          progress: progress,
          complete: complete,
          spacing: uploadBottomSheetSpacing,
          padding: uploadBottomSheetPadding,
          onUploadSourceSelected: onUploadSourceSelected,
        );
        if (uploadedUrl != null) {
          onUpload.call(uploadedUrl);
        }
      },
    );
  }
}
