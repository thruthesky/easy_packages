import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_storage/easy_storage.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';
import 'package:social_design_system/social_design_system.dart';

class UploadImageScreen extends StatefulWidget {
  static const String routeName = '/ImageUploadCard';
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  List<String> urls = List<String>.from([
    'https://firebasestorage.googleapis.com/v0/b/withcenter-test-3.appspot.com/o/users%2FRdKOm7K30ggcaH5YzG8AomfRMTe2%2F1000000058.png?alt=media&token=bfd987f0-9757-4e35-8cbc-9c31b6e3ea3f',
  ]);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ImageUploadCard'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("My UID: ${my.uid}"),
              const Text("Upload Icon"),
              const SizedBox(height: 24),
              const ImageUploadCard(
                icon: Icon(
                  Icons.photo,
                  size: 80,
                ),
                // imageBuilder: (child) {
                //   return ClipRRect(
                //     borderRadius: BorderRadius.circular(48),
                //     child: Container(
                //       color: Theme.of(context).primaryColor.withOpacity(0.2),
                //       width: 120,
                //       height: 120,
                //       child: child,
                //     ),
                //   );
                // },
                // progressBar: false,
                // progressIndicatorBackdrop: false,
                // title: Text('ImageUploadCard'),
                // subtitle: Text('Upload an Icon'),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),
              const Text("Upload Icon for user profile photo"),
              ImageUploadCard(
                initialData: my.photoUrl,
                ref: my.ref.child(User.field.photoUrl),
                icon: const Icon(
                  Icons.image,
                  size: 80,
                ),
                title: const Text('ImageUploadCard'),
                subtitle: const Text('Please upload profile photo'),
              ),
              const Divider(),
              const Text("Upload Icon Button"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Upload(
                    child: const Icon(
                      Icons.image,
                      size: 80,
                    ),
                    onUpload: (url) {
                      debugPrint('Uploaded: $url');
                    },
                  ),
                  Upload.image(
                    onUpload: (url) {
                      debugPrint('Uploaded: $url');
                    },
                  ),
                  Upload.video(
                    onUpload: (url) {
                      debugPrint('Uploaded: $url');
                    },
                  ),
                  Upload.file(
                    onUpload: (url) {
                      debugPrint('Uploaded: $url');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),
              const Text("Upload Form"),
              const SizedBox(height: 24),
              UploadForm(
                urls: urls,
                onUpload: (url) {
                  debugPrint('Uploaded: $url');
                },
                onDelete: (url) {
                  debugPrint('Deleted: $url');
                },
                button: ElevatedButton(
                  onPressed: () {
                    debugPrint('Upload Form');
                    dog(urls);
                  },
                  child: const Text('Submit'),
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const Text("Upload Buttons in Comic Theme"),
              Text("uploadBottomSheetPadding: ${StorageService.instance.uploadBottomSheetPadding}"),
              Text("uploadBottomSheetSpacing: ${StorageService.instance.uploadBottomSheetSpacing}"),
              const SizedBox(height: 24),
              ComicTheme(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const ImageUploadCard(
                      icon: Icon(
                        Icons.photo,
                        size: 52,
                      ),
                    ),
                    Upload(
                      child: const Icon(
                        Icons.image,
                        size: 52,
                      ),
                      onUpload: (url) {
                        debugPrint('Uploaded: $url');
                      },
                    ),
                    Upload.image(
                      onUpload: (url) {
                        debugPrint('Uploaded: $url');
                      },
                    ),
                    Upload.video(
                      onUpload: (url) {
                        debugPrint('Uploaded: $url');
                      },
                    ),
                    Upload.file(
                      onUpload: (url) {
                        debugPrint('Uploaded: $url');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
