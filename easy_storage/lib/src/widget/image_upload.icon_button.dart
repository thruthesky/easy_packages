import 'package:easy_storage/easy_storage.dart';
import 'package:flutter/material.dart';

/// Upload Image Icon Button
///
/// This widget is displaying an IconButton and is used to upload an image.
class ImageUploadIconButton extends StatelessWidget {
  const ImageUploadIconButton({
    super.key,
    required this.onUpload,
    this.icon,
  });

  final void Function(String url) onUpload;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon ?? const Icon(Icons.camera_alt),
      onPressed: () async {
        String? uploadedUrl = await StorageService.instance.upload(
          context: context,
        );
        if (uploadedUrl != null) {
          onUpload.call(uploadedUrl);
        }
      },
    );
  }
}
