import 'package:easy_storage/easy_storage.dart';
import 'package:flutter/material.dart';

/// Video upload icon button
///
/// This widget uses the [UploadIconButton] to upload a file. It has a preset
/// options for uploading video.
@Deprecated('Use UploadIconButton.video() instead')
class VideoUploadIconButton extends StatelessWidget {
  const VideoUploadIconButton({
    super.key,
    required this.onUpload,
    this.onUploadSourceSelected,
    this.camera = true,
    this.gallery = true,
    this.progress,
    this.complete,
    this.icon = const Icon(Icons.videocam),
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
    return UploadIconButton.video(
      onUpload: onUpload,
      onUploadSourceSelected: onUploadSourceSelected,
      videoCamera: camera,
      videoGallery: gallery,
      progress: progress,
      complete: complete,
      icon: icon,
      iconSize: iconSize,
      visualDensity: visualDensity,
      iconPadding: iconPadding,
      uploadBottomSheetPadding: uploadBottomSheetPadding,
      uploadBottomSheetSpacing: uploadBottomSheetSpacing,
    );
  }
}
