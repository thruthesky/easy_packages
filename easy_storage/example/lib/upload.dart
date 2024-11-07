// import 'package:example/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:easy_storage/easy_storage.dart';

class UploadButton extends StatefulWidget {
  const UploadButton({super.key});

  @override
  State<UploadButton> createState() => _UploadState();
}

class _UploadState extends State<UploadButton> {
  String? uploadUrl;
  double? progress = 0;
  bool get isNotUploading {
    return progress == null || progress == 0 || progress!.isNaN;
  }

  bool get isUploading => !isNotUploading;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: 200,
              child: uploadUrl != null
                  ? Image.network(
                      uploadUrl!,
                      width: 200,
                      fit: BoxFit.cover,
                      height: 200,
                    )
                  : isNotUploading
                      ? const Center(
                          child: Text('Upload image into Firebase Cloud Storage'),
                        )
                      : const SizedBox.shrink(),
            ),
            if (uploadUrl != null)
              Positioned(
                top: 0,
                right: 3,
                child: IconButton.filled(
                  onPressed: () async {
                    await StorageService.instance.delete(uploadUrl);
                    uploadUrl = null;
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.delete,
                  ),
                ),
              ),
            if (isUploading) ...{
              Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: progress,
                    ),
                  ))
            } else ...{
              const SizedBox.shrink(),
            }
          ],
        ),
        const SizedBox(
          height: 24,
        ),
        ElevatedButton(
          onPressed: () async {
            uploadUrl = await StorageService.instance.upload(
              progress: (v) => setState(() {
                progress = v;
              }),
              complete: () => setState(() {
                progress = null;
              }),
              context: context,
            );

            if (uploadUrl == null) {
              return;
            }
            setState(() {});
            if (kDebugMode) {
              print('Uploaded: $uploadUrl');
            }
          },
          child: const Text(
            'Upload',
          ),
        ),
      ],
    );
  }
}
