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
    this.padding,
  });

  final void Function(String url) onUpload;
  final Widget? icon;
  final Function(double)? progress;
  final Function()? complete;
  final VisualDensity? visualDensity;
  final bool camera;
  final bool gallery;

  final double? iconSize;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon ?? const Icon(Icons.camera_alt),
      iconSize: iconSize,
      visualDensity: visualDensity,
      padding: padding,
      onPressed: () async {
        final uploadedUrl = await StorageService.instance.upload(
          context: context,
          camera: camera,
          gallery: gallery,
          progress: progress,
          complete: complete,
        );
        if (uploadedUrl != null) {
          onUpload.call(uploadedUrl);
        }
      },
    );
  }
}
