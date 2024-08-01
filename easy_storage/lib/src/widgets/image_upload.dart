import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_storage/easy_storage.dart';
import 'package:flutter/material.dart';

/// ImageUpload
///
/// Displays an icon on the top, title, and subtitle as the upload UI widget.
///
/// [ref] is the firestore document reference.
///
/// [field] is the field name of the firestore document
///
/// If the [ref] and [field] are provided, the uploaded image will be saved to
/// the firestore.
///
class ImageUpload extends StatefulWidget {
  const ImageUpload({
    super.key,
    this.initialData,
    this.icon,
    this.title,
    this.subtitle,
    this.ref,
    this.field,
  });

  final String? initialData;
  final Widget? icon;
  final Widget? title;
  final Widget? subtitle;

  final DocumentReference? ref;
  final String? field;

  @override
  State<ImageUpload> createState() => _UploadImageState();
}

class _UploadImageState extends State<ImageUpload> {
  String? url;
  double? progress;

  bool get isNotUploading {
    return progress == null || progress == 0 || progress!.isNaN;
  }

  bool get isUploading => !isNotUploading;

  @override
  void initState() {
    super.initState();
    url = widget.initialData;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        String? uploadedUrl;
        if (widget.ref == null || widget.field == null) {
          uploadedUrl = await StorageService.instance.upload(
            context: context,
            progress: (p) => setState(() => progress = p),
            complete: () => setState(() => progress = null),
          );
        } else {
          uploadedUrl = await StorageService.instance.uploadAt(
            context: context,
            ref: widget.ref!,
            field: widget.field!,
            progress: (p) => setState(() => progress = p),
            complete: () => setState(() => progress = null),
          );
        }

        if (uploadedUrl != null) {
          url = uploadedUrl;
          setState(() {});
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              url == null
                  ? CircleAvatar(
                      radius: 64,
                      child: widget.icon ??
                          Icon(
                            Icons.photo,
                            size: 64,
                            color: Theme.of(context).primaryColor,
                          ),
                    )
                  : CircleAvatar(
                      radius: 64,
                      backgroundImage: CachedNetworkImageProvider(url!),
                    ),
              uploadedPercentageIndicator(),
              uploadProgressIndicator(color: Colors.blue),
              const Positioned(
                right: 0,
                bottom: 0,
                child: Icon(
                  Icons.camera_alt,
                  size: 32,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (widget.title != null) widget.title!,
          if (widget.subtitle != null) widget.subtitle!,
        ],
      ),
    );
  }

  Widget uploadedPercentageIndicator() {
    if (isNotUploading) return const SizedBox.shrink();

    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '${((progress ?? 0) * 100).toInt()}%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  uploadProgressIndicator({Color? color}) {
    if (isNotUploading) return const SizedBox.shrink();

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: Center(
        child: SizedBox.expand(
          child: CircularProgressIndicator(
            strokeWidth: 4,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? Theme.of(context).primaryColor,
            ),
            value: progress,
          ),
        ),
      ),
    );
  }
}
