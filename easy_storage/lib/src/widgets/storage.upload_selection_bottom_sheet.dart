import 'package:easy_locale/easy_locale.dart';
import 'package:easy_storage/easy_storage.dart';
import 'package:flutter/material.dart';

class StorageUploadSelectionBottomSheet extends StatelessWidget {
  const StorageUploadSelectionBottomSheet({
    super.key,
    this.photoGallery = true,
    this.photoCamera = true,
    this.videoGallery = false,
    this.videoCamera = false,
    this.fromGallery = false,
    this.fromFile = false,
    this.padding,
    this.spacing,
  });

  final bool? photoGallery;
  final bool? photoCamera;
  final bool? videoGallery;
  final bool? videoCamera;
  final bool? fromGallery;
  final bool? fromFile;
  final EdgeInsetsGeometry? padding;
  final double? spacing;

  /// if padding and uploadBottmSheetPadding is not set return `EdgeInsets.zero`
  EdgeInsetsGeometry get getPadding => padding ?? StorageService.instance.uploadBottomSheetPadding ?? EdgeInsets.zero;

  /// if spacing and uploadBottomSheetSpacing is not set return `null`
  double? get getSpacing => spacing ?? StorageService.instance.uploadBottomSheetSpacing;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: getPadding,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 48),
                Expanded(
                  child: Center(
                    child: Text(
                      'Upload from'.t,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.cancel),
                ),
              ],
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
              if (getSpacing != null) SizedBox(height: getSpacing),
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
              if (getSpacing != null) SizedBox(height: getSpacing),
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
              if (getSpacing != null) SizedBox(height: getSpacing),
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
              if (getSpacing != null) SizedBox(height: getSpacing),
            ],
            if (fromGallery == true) ...[
              ListTile(
                leading: const Icon(Icons.file_present_rounded),
                title: Text('Take file from gallery'.t),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context, SourceType.mediaGallery);
                },
              ),
              if (getSpacing != null) SizedBox(height: getSpacing),
            ],
            if (fromFile == true) ...[
              ListTile(
                leading: const Icon(Icons.snippet_folder_rounded),
                title: Text('Choose file'.t),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context, SourceType.file);
                },
              ),
              if (getSpacing != null) SizedBox(height: getSpacing),
            ],
            SizedBox(height: getSpacing != null && getSpacing! >= 8 ? 8 : 16),
            TextButton(
              child: Text('Close'.t, style: TextStyle(color: Theme.of(context).primaryColor)),
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
