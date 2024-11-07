// import 'package:example/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:easy_storage/easy_storage.dart';

/// UploadAt Eample
class UploadAt extends StatefulWidget {
  const UploadAt({super.key, required this.uid});
  final String uid;

  @override
  State<UploadAt> createState() => _UploadAtState();
}

class _UploadAtState extends State<UploadAt> {
  String? uploadAtUrl;
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
              child: uploadAtUrl != null
                  ? Stack(
                      children: [
                        Image.network(
                          uploadAtUrl!,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 0,
                          right: 3,
                          child: IconButton.filled(
                            onPressed: () async {
                              await StorageService.instance.delete(
                                uploadAtUrl,
                                // ref: FirebaseFirestore.instance
                                //     .collection('storage')
                                //     .doc(widget.uid),
                                // field: 'url',
                                ref: FirebaseDatabase.instance.ref('storage').child(widget.uid).child('url'),
                              );
                              uploadAtUrl = null;
                              setState(() {});
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ),
                      ],
                    )
                  : isNotUploading
                      ? const Center(
                          child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.0,
                          ),
                          child: Text(
                            'Upload image into Firebase Cloud Storage and save the path to Cloud Firestore',
                            textAlign: TextAlign.center,
                          ),
                        ))
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
            uploadAtUrl = await StorageService.instance.uploadAt(
              progress: (p) => setState(() => progress = p),
              complete: () => setState(() => progress = null),
              // ref: FirebaseFirestore.instance.collection('storage').doc(widget.uid),
              // field: 'url',
              ref: FirebaseDatabase.instance.ref('storage').child(widget.uid).child('url'),
              context: context,
            );
            if (uploadAtUrl == null) {
              return;
            }
            setState(() {});
            if (kDebugMode) {
              print('Uploaded: $uploadAtUrl');
            }
          },
          child: const Text(
            'UploadAt',
          ),
        ),
      ],
    );
  }
}
