import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';
import 'package:easy_storage/easy_storage.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';

/// UserAvatarUpdate
///
/// Displays the user's avatar.
///
///
///
/// [delete] is the callback function that is being called when the user taps the delete button.
///
///
/// [onUploadSuccess] is the callback function that is being called when the user's avatar is uploaded.
///
///
class UserUpdateAvatar extends StatefulWidget {
  const UserUpdateAvatar({
    super.key,
    this.size = 140,
    this.radius = 60,
    this.delete = false,
    this.onUploadSuccess,
    this.uploadStrokeWidth = 6,
    this.shadowBlurRadius = 16.0,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 0,
    this.progressBuilder,
  });

  final double size;
  final double radius;
  final bool delete;
  final double uploadStrokeWidth;
  final double shadowBlurRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final void Function()? onUploadSuccess;
  final Widget Function(double? progress)? progressBuilder;

  @override
  State<UserUpdateAvatar> createState() => _UserUpdateAvatarState();
}

class _UserUpdateAvatarState extends State<UserUpdateAvatar> {
  double? progress;

  bool get isNotUploading {
    return progress == null || progress == 0 || progress!.isNaN;
  }

  bool get isUploading => !isNotUploading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final url = await StorageService.instance.upload(
          context: context,
          progress: (p) => setState(() => progress = p),
          complete: () => setState(() => progress = null),
        );
        if (url == null) return;
        my.update(photoUrl: url);
      },
      child: Stack(
        children: [
          MyDoc(
            builder: (user) => UserAvatar(
              photoUrl: user!.photoUrl,
              initials: user.displayName.or(user.name.or(user.uid)),
              size: widget.size,
              radius: widget.radius,
            ),
          ),
          uploadProgressIndicator(color: Colors.white),
          if (isUploading)
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Center(
                child: Text(
                  ((progress ?? 0) * 100).toInt().toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          if (isNotUploading)
            Positioned(
              right: 0,
              bottom: 0,
              child: Icon(
                Icons.camera_alt,
                color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                size: 32,
              ),
            ),
          if (widget.delete && isNotUploading)
            Positioned(
              top: 0,
              left: 0,
              child: MyDoc(
                builder: (my) {
                  if (my == null || my.photoUrl == null) return const SizedBox.shrink();
                  return IconButton(
                    onPressed: () async {
                      /// Delete exisiting photo. Continue to delete evenif the photo does not exist.
                      final re = await confirm(
                          context: context,
                          title: Text('Delete Avatar?'.t),
                          message: Text('Are you sure you wanted to delete this avatar?'.t));
                      if (re == false) return;
                      StorageService.instance.delete(my.photoUrl);
                      // TODO review: is saving as "", okay?
                      // REVIEW: How to delete properly
                      // my.update(photoUrl: FieldValue.delete());
                      my.update(photoUrl: '');
                    },
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      Icons.remove_circle,
                      color: Colors.grey.shade600,
                      size: 30,
                    ),
                  );
                },
              ),
            ),
        ],
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
        child: widget.progressBuilder?.call(progress) ??
            SizedBox(
              width: widget.radius,
              height: widget.radius,
              child: CircularProgressIndicator(
                strokeWidth: widget.uploadStrokeWidth,
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
