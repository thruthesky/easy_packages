import 'package:easy_storage/easy_storage.dart';
import 'package:flutter/material.dart';

/// General Upload Icon Button
///
/// This widget is displaying an IconButton and is used to upload an image.
class UploadIconButton extends StatelessWidget {
  const UploadIconButton({
    super.key,
    required this.onUpload,
    this.photoGallery = true,
    this.photoCamera = true,
    this.videoGallery = true,
    this.videoCamera = true,
    this.gallery = true,
    this.file = true,
    this.progress,
    this.complete,
    this.icon,
    this.iconSize,
    this.visualDensity,
    this.iconPadding,
    this.padding,
    this.spacing,
  });

  final void Function(String url) onUpload;
  final Widget? icon;
  final Function(double)? progress;
  final Function()? complete;
  final VisualDensity? visualDensity;

  final bool photoGallery;
  final bool photoCamera;

  final bool videoGallery;
  final bool videoCamera;

  final bool gallery;
  final bool file;

  final double? iconSize;
  final EdgeInsetsGeometry? iconPadding;
  final EdgeInsetsGeometry? padding;
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon ?? const Icon(Icons.add_box_rounded),
      iconSize: iconSize,
      visualDensity: visualDensity,
      padding: padding,
      onPressed: () async {
        final uploadedUrl = await StorageService.instance.upload(
          context: context,
          photoGallery: photoGallery,
          photoCamera: photoCamera,
          videoGallery: videoGallery,
          videoCamera: videoCamera,
          gallery: gallery,
          file: file,
          progress: progress,
          complete: complete,
          spacing: spacing,
          padding: padding,
        );
        if (uploadedUrl != null) {
          onUpload.call(uploadedUrl);
        }
      },
    );
  }
}
