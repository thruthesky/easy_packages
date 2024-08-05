import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_storage/easy_storage.dart';
import 'package:flutter/material.dart';

/// ImageUploadCard
///
/// Displays a card style UI for uploading an image. It displays a circle
/// image, title, and subtitle.
///
/// [ref] is the firestore document reference.
///
/// [field] is the field name of the firestore document
///
/// If the [ref] and [field] are provided, the uploaded image will be saved to
/// the firestore.
///
/// [icon] is the icon to display when no image is uploaded.
///
/// [title] is the title to display.
///
/// [subtitle] is the subtitle to display.
///
/// [initialData] is the initial image url to display.
///
/// [onUpload] is a callback function that is called when the image is uploaded.
///
/// [imageBuilder] is a builder to build image widget. If the image widget is
/// not circle, the [progressBar] and [progressIndicatorBackdrop] should be
/// set to false for bettter UI.
class ImageUploadCard extends StatefulWidget {
  const ImageUploadCard({
    super.key,
    this.initialData,
    this.icon,
    this.title,
    this.subtitle,
    this.ref,
    this.field,
    this.onUpload,
    this.imageBuilder,
    this.progressBar = true,
    this.progressIndicatorBackdrop = true,
  });

  final String? initialData;
  final Widget? icon;
  final Widget? title;
  final Widget? subtitle;
  final Function(String? url)? onUpload;
  final Widget Function(Widget child)? imageBuilder;

  final DocumentReference? ref;
  final String? field;

  final bool progressBar;
  final bool progressIndicatorBackdrop;

  @override
  State<ImageUploadCard> createState() => _UploadImageState();
}

class _UploadImageState extends State<ImageUploadCard> {
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
    Widget child;
    if (url == null) {
      child = widget.icon ??
          Icon(
            Icons.photo,
            size: 80,
            color: Theme.of(context).primaryColor,
          );
    } else {
      child = CachedNetworkImage(
        imageUrl: url!,
        fit: BoxFit.cover,
      );
    }
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
          if (widget.onUpload != null) {
            widget.onUpload!(uploadedUrl);
          }
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
              if (widget.imageBuilder != null)
                widget.imageBuilder!(child)
              else
                ClipOval(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: child,
                  ),
                ),
              uploadedPercentageIndicator(),
              if (widget.progressBar)
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
        decoration: widget.progressIndicatorBackdrop
            ? BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              )
            : null,
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
