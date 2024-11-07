import 'package:easy_storage/easy_storage.dart';
import 'package:flutter/material.dart';

/// Image upload icon button
///
/// This widget uses the [UploadIconButton] to upload a file. It has a preset
/// options for uploading images.
@Deprecated('Use UploadIconButton.image() instead')
class ImageUploadIconButton extends StatelessWidget {
  const ImageUploadIconButton({
    super.key,
    required this.onUpload,
    this.onUploadSourceSelected,
    this.camera = true,
    this.gallery = true,
    this.progress,
    this.complete,
    this.icon = const Icon(Icons.camera_alt),
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
  final bool camera;
  final bool gallery;

  final double? iconSize;
  final EdgeInsetsGeometry? iconPadding;
  final EdgeInsetsGeometry? uploadBottomSheetPadding;
  final double? uploadBottomSheetSpacing;

  @override
  Widget build(BuildContext context) {
    return UploadIconButton(
      onUpload: onUpload,
      onUploadSourceSelected: onUploadSourceSelected,
      photoCamera: camera,
      photoGallery: gallery,
      videoCamera: false,
      videoGallery: false,
      fromGallery: false,
      fromFile: false,
      progress: progress,
      complete: complete,
      onBeginUpload: null,
      icon: icon,
      iconSize: iconSize,
      visualDensity: visualDensity,
      iconPadding: iconPadding,
      uploadBottomSheetPadding: uploadBottomSheetPadding,
      uploadBottomSheetSpacing: uploadBottomSheetSpacing,
    );
  }
}
