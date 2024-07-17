import 'package:easy_storage/easy_storage.dart';
import 'package:flutter/material.dart';

/// Upload Image Icon Button
///
/// This widget is displaying an IconButton and is used to upload an image.
class ImageUploadIconButton extends StatelessWidget {
  const ImageUploadIconButton({
    super.key,
    required this.onUpload,
    this.camera = true,
    this.gallery = true,
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
  final bool camera;
  final bool gallery;

  final double? iconSize;
  final EdgeInsetsGeometry? iconPadding;
  final EdgeInsetsGeometry? padding;
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    return UploadIconButton(
      onUpload: onUpload,
      photoCamera: camera,
      photoGallery: gallery,
      videoCamera: false,
      videoGallery: false,
      gallery: false,
      file: false,
      progress: progress,
      complete: complete,
      icon: icon,
      iconSize: iconSize,
      visualDensity: visualDensity,
      iconPadding: iconPadding,
      padding: padding,
      spacing: spacing,
    );
  }
}
