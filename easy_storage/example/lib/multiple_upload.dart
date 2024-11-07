// import 'package:example/firebase_options.dart';
import 'package:example/upload.dart';
import 'package:example/upload_at.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:easy_storage/easy_storage.dart';

// uploading multiple image and deleting image example
class MultipleUpload extends StatefulWidget {
  const MultipleUpload({super.key});

  @override
  State<MultipleUpload> createState() => _MultipleUploadState();
}

class _MultipleUploadState extends State<MultipleUpload> {
  List<String?>? uploadMultipleUrls = [];
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
              child: uploadMultipleUrls!.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...uploadMultipleUrls!.map(
                            (url) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Stack(
                                children: [
                                  Image.network(
                                    url!,
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 3,
                                    child: IconButton.filled(
                                        onPressed: () {
                                          StorageService.instance.delete(url);
                                          uploadMultipleUrls!.remove(url);
                                          setState(() {});
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : isNotUploading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.0,
                            ),
                            child: Text(
                              'Upload  Multiple image into Firebase Cloud Storage',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
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
            uploadMultipleUrls = await StorageService.instance.uploadMultiple(
              progress: (p) => setState(() => progress = p),
              complete: () => setState(() => progress = null),
            );
            if (uploadMultipleUrls!.isEmpty) {
              return;
            }
            setState(() {});
          },
          child: const Text(
            'Upload Multiple Image',
          ),
        ),
      ],
    );
  }
}
