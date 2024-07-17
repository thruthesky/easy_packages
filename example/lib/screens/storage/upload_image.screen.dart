import 'package:easy_storage/easy_storage.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class UploadImageScreen extends StatefulWidget {
  static const String routeName = '/UploadImage';
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UploadImage'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("My UID: ${my.uid}"),
            const Text("Upload Icon"),
            const UploadImage(
              icon: Icon(
                Icons.person,
                size: 100,
              ),
              title: Text('Icon'),
              subtitle: Text('Upload an Icon'),
            ),
            const SizedBox(height: 24),
            const Text("Upload Icon for user profile photo"),
            UploadImage(
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
          ],
        ),
      ),
    );
  }
}