import 'package:easy_storage/easy_storage.dart';
import 'package:flutter/material.dart';

/// Upload Image Icon Button
///
/// This widget is displaying an IconButton and is used to upload an image.
class VideoUploadIconButton extends StatelessWidget {
  const VideoUploadIconButton({
    super.key,
    required this.onUpload,
    this.gallery = true,
    this.camera = true,
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
  final bool camera;

  final double? iconSize;
  final EdgeInsetsGeometry? iconPadding;
  final EdgeInsetsGeometry? padding;
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon ?? const Icon(Icons.attach_file),
      iconSize: iconSize,
      visualDensity: visualDensity,
      padding: padding,
      onPressed: () async {
        final uploadedUrl = await StorageService.instance.upload(
          context: context,
          videoGallery: gallery,
          videoCamera: camera,
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
