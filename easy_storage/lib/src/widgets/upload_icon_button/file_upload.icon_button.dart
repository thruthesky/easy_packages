import 'package:easy_storage/easy_storage.dart';
import 'package:flutter/material.dart';

/// File upload icon button
///
/// This widget uses the [UploadIconButton] to upload a file. It has a preset
/// options for uploading files.
class FileUploadIconButton extends StatelessWidget {
  const FileUploadIconButton({
    super.key,
    required this.onUpload,
    this.onUploadSourceSelected,
    this.gallery = true,
    this.file = true,
    this.progress,
    this.complete,
    this.icon = const Icon(Icons.attach_file),
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
      onUploadSourceSelected: onUploadSourceSelected,
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
