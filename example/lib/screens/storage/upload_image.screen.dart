import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_storage/easy_storage.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class UploadImageScreen extends StatefulWidget {
  static const String routeName = '/ImageUploadCard';
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  List<String> urls = List<String>.from([
    'https://firebasestorage.googleapis.com/v0/b/withcenter-test-5.appspot.com/o/users%2FZpq96ARrWbag4bttq4wOgJ577is2%2Fimage_picker_0D7D6009-3E8D-45EF-8FCA-297DABB66508-72557-00000228C41CA5C5.jpg?alt=media&token=871fdca5-c018-47fe-a35e-a96ee5d4ef32',
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
              const ImageUploadCard(
                icon: Icon(
                  Icons.person,
                  size: 100,
                ),
                title: Text('Icon'),
                subtitle: Text('Upload an Icon'),
              ),
              const SizedBox(height: 24),
              const Text("Upload Icon for user profile photo"),
              ImageUploadCard(
                initialData: my.photoUrl,
                ref: my.ref,
                field: 'photoUrl',
                icon: const Icon(
                  Icons.image,
                  size: 80,
                ),
                title: const Text('Profile Photo'),
                subtitle: const Text('Please upload profile photo'),
              ),
              const Text("Upload Icon Button"),
              UploadIconButton(
                icon: const Icon(
                  Icons.image,
                  size: 80,
                ),
                onUpload: (url) {
                  debugPrint('Uploaded: $url');
                },
              ),
              const SizedBox(height: 24),
              const Text("Upload Form"),
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
            ],
          ),
        ),
      ),
    );
  }
}
