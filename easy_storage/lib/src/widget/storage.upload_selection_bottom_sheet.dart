import 'package:easy_locale/easy_locale.dart';
import 'package:easy_storage/src/enum/storage.dart';
import 'package:flutter/material.dart';

class StorageUploadSelectionBottomSheet extends StatelessWidget {
  const StorageUploadSelectionBottomSheet({
    super.key,
    this.photoGallery = true,
    this.photoCamera = true,
    this.videoGallery = false,
    this.videoCamera = false,
    this.gallery = false,
    this.file = false,
    this.padding,
    this.spacing,
  });

  final bool? photoGallery;
  final bool? photoCamera;
  final bool? videoGallery;
  final bool? videoCamera;
  final bool? gallery;
  final bool? file;
  final EdgeInsetsGeometry? padding;
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            const SizedBox(height: 8),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: padding != null ? 0 : 16),
              child: SizedBox(
                height: 48,
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        'Upload from'.t,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.cancel),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (photoGallery == true) ...[
              ListTile(
                leading: const Icon(Icons.photo),
                title: Text('Select photo from gallery'.t),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context, SourceType.photoGallery);
                },
              ),
              if (spacing != null) SizedBox(height: spacing),
            ],
            if (photoCamera == true) ...[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text('Take photo from camera'.t),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context, SourceType.photoCamera);
                },
              ),
              if (spacing != null) SizedBox(height: spacing),
            ],
            if (videoGallery == true) ...[
              ListTile(
                leading: const Icon(Icons.videocam),
                title: Text('Select video from gallery'.t),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context, SourceType.videoGallery);
                },
              ),
              if (spacing != null) SizedBox(height: spacing),
            ],
            if (videoCamera == true) ...[
              ListTile(
                leading: const Icon(Icons.video_call),
                title: Text('Take video from camera'.t),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context, SourceType.videoCamera);
                },
              ),
              if (spacing != null) SizedBox(height: spacing),
            ],
            if (gallery == true) ...[
              ListTile(
                leading: const Icon(Icons.file_present_rounded),
                title: Text('Take file from gallery'.t),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context, SourceType.gallery);
                },
              ),
              if (spacing != null) SizedBox(height: spacing),
            ],
            if (file == true) ...[
              ListTile(
                leading: const Icon(Icons.snippet_folder_rounded),
                title: Text('Choose file'.t),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context, SourceType.file);
                },
              ),
              if (spacing != null) SizedBox(height: spacing),
            ],
            SizedBox(height: spacing != null && spacing! >= 8 ? 8 : 16),
            TextButton(
              child: Text('Close'.t,
                  style: TextStyle(color: Theme.of(context).primaryColor)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
