import 'package:easy_storage/easy_storage.dart';
import 'package:flutter/material.dart';

/// UploadForm
///
/// This widget is used to upload many images in the form.
///
/// It will display the upload progress and the uploaded images. Users can
/// delete the uploaded images.
///
/// Use this widget to
class UploadForm extends StatefulWidget {
  const UploadForm({
    super.key,
    required this.button,
    required this.onUpload,
    required this.onDelete,
    required this.urls,
  });

  final Widget button;
  final void Function(String url) onUpload;
  final void Function(String url) onDelete;
  final List<String> urls;

  @override
  State<UploadForm> createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  double? uploadProgress;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (uploadProgress != null && !uploadProgress!.isNaN)
          LinearProgressIndicator(
            value: uploadProgress,
          ),
        const SizedBox(height: 24),
        DisplayEditableUploads(
            urls: widget.urls,
            onDelete: (url) {
              widget.urls.remove(url);
              setState(() {});
              widget.onDelete(url);
            }),
        Row(
          children: [
            UploadIconButton(
              icon: const Icon(Icons.camera_alt),
              onUpload: (url) {
                widget.urls.add(url);
                setState(() {});
                widget.onUpload(url);
              },
              progress: (v) => setState(
                () => uploadProgress = v,
              ),
              complete: () => setState(
                () => uploadProgress = null,
              ),
              onBeginUpload: null,
            ),
            const Spacer(),
            widget.button,
          ],
        ),
      ],
    );
  }
}
