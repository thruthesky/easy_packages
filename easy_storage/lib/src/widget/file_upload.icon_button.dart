import 'package:easy_storage/easy_storage.dart';
import 'package:flutter/material.dart';

/// Upload Image Icon Button
///
/// This widget is displaying an IconButton and is used to upload an image.
class FileUploadIconButton extends StatelessWidget {
  const FileUploadIconButton({
    super.key,
    required this.onUpload,
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
  final bool gallery;
  final bool file;

  final double? iconSize;
  final EdgeInsetsGeometry? iconPadding;
  final EdgeInsetsGeometry? padding;
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    return UploadIconButton(
      onUpload: onUpload,
      photoCamera: false,
      photoGallery: false,
      videoCamera: false,
      videoGallery: false,
      gallery: gallery,
      file: file,
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
