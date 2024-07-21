import 'package:easy_storage/easy_storage.dart';
import 'package:flutter/material.dart';

/// General Upload Icon Button
///
/// This widget is displaying an IconButton and is used to upload an image.
class UploadIconButton extends StatelessWidget {
  const UploadIconButton({
    super.key,
    required this.onUpload,
    this.onUploadSourceSelected,
    this.photoCamera = true,
    this.photoGallery = true,
    this.videoCamera = true,
    this.videoGallery = true,
    this.gallery = true,
    this.file = true,
    this.progress,
    this.complete,
    this.icon = const Icon(Icons.add),
    this.iconSize,
    this.visualDensity,
    this.iconPadding,
    this.padding,
    this.spacing,
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

  final bool gallery;
  final bool file;

  final double? iconSize;
  final EdgeInsetsGeometry? iconPadding;
  final EdgeInsetsGeometry? padding;
  final double? spacing;

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
          gallery: gallery,
          file: file,
          progress: progress,
          complete: complete,
          spacing: spacing,
          padding: padding,
          onUploadSourceSelected: onUploadSourceSelected,
        );
        if (uploadedUrl != null) {
          onUpload.call(uploadedUrl);
        }
      },
    );
  }
}
