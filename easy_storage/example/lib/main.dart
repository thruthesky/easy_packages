// import 'package:example/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:easy_storage/easy_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Example',
      home: HomeScreenScreen(),
    );
  }
}

class HomeScreenScreen extends StatefulWidget {
  static const String routeName = '/HomeScreen';
  const HomeScreenScreen({super.key});

  @override
  State<HomeScreenScreen> createState() => _HomeScreenScreenState();
}

class _HomeScreenScreenState extends State<HomeScreenScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy Storage Example'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '''How to use
            1. User must be sign in to upload into Storage. Anonymous login is okay.
            2. The App must have all the setup that required to use Camera and Gallery.
            3. Firebase Storage must be read and the security rules are properly setup.
            ''',
                ),
              ),
              StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.hasData == false || snapshot.data == null) {
                    return Column(
                      children: [
                        const Text(
                          'Sign in.',
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signInAnonymously();
                          },
                          child: const Text('Sign In Anonymously'),
                        ),
                      ],
                    );
                  }

                  User user = snapshot.data as User;
                  return Column(
                    children: [
                      Text('Anonymous User: uid: ${user.uid}'),
                      ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                        },
                        child: const Text('Sign Out'),
                      ),
                      const Upload(),
                      const SizedBox(
                        height: 24,
                      ),
                      UploadAt(uid: user.uid),
                      const SizedBox(
                        height: 24,
                      ),
                      const MultipleUpload(),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Upload extends StatefulWidget {
  const Upload({super.key});

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
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
