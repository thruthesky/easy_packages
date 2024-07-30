import 'package:easy_locale/easy_locale.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easy_storage/easy_storage.dart';
import 'package:flutter/material.dart';

/// `PostEditScreen` Screen for creating or updating the post
/// if the post is provided the screen is for updating where the post information
/// is display and can be edited
///
/// if the post is not provided the screen is for creating where you can create new post
///
class PostEditScreen extends StatefulWidget {
  /// `routeName` so it can be use it other router ex: go_router packages
  static const String routeName = '/PostEdit';

  /// `category` is category of the post ex: 'youtube', 'feed, 'forum'
  ///
  /// `post` is the post information, if the post is provided the screen is
  /// updating the post and if not provided the screen for creating a post
  const PostEditScreen({
    super.key,
    required this.category,
    this.enableYoutubeUrl = false,
    this.post,
  });

  final String? category;
  final bool enableYoutubeUrl;
  final Post? post;

  @override
  State<PostEditScreen> createState() => _PostEditScreenState();
}

class _PostEditScreenState extends State<PostEditScreen> {
  String? category;
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final youtubeController = TextEditingController();

  bool get isCreate => widget.post == null;
  bool get isUpdate => !isCreate;

  bool inProgress = false;
  double? uploadingPhotoProgress;

  List<String> urls = [];

  @override
  void initState() {
    super.initState();

    prepareData();
    if (widget.category != null) {
      category = widget.category!;
    }
  }

  /// prepare data if the event is updating the post
  prepareData() {
    if (isCreate) return;
    if (widget.post == null) return;
    titleController.text = widget.post!.title;
    contentController.text = widget.post!.content;
    youtubeController.text = widget.post!.youtubeUrl;
    urls = widget.post!.urls;
    setState(() {});
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isCreate ? 'Create'.t : 'Update'.t),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'input title'.t,
                    labelText: 'Title'.t,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(
                    hintText: 'Input Content'.t,
                    labelText: 'Content'.t,
                  ),
                  minLines: 5,
                  maxLines: 8,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: youtubeController,
                  decoration: InputDecoration(
                    hintText: 'Youtube'.t,
                    labelText: 'Youtube'.t,
                  ),
                ),
                const SizedBox(height: 24),
                if (uploadingPhotoProgress != null &&
                    !uploadingPhotoProgress!.isNaN)
                  LinearProgressIndicator(
                    value: uploadingPhotoProgress,
                  ),
                const SizedBox(height: 24),
                DisplayEditableUploads(
                    urls: urls,
                    onDelete: (url) {
                      urls.remove(url);
                      setState(() {});
                    }),
                Row(
                  children: [
                    UploadIconButton(
                      onUpload: (url) {
                        urls.add(url);
                        setState(() {});
                      },
                      progress: (v) => setState(
                        () => uploadingPhotoProgress = v,
                      ),
                      complete: () => setState(
                        () => uploadingPhotoProgress = null,
                      ),
                    ),
                    const Spacer(),
                    inProgress
                        ? const Center(
                            child: CircularProgressIndicator.adaptive(),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              setState(() => inProgress = true);
                              if (isCreate) {
                                final ref = await Post.create(
                                  category: category ?? '',
                                  title: titleController.text,
                                  content: contentController.text,
                                  youtubeUrl: youtubeController.text,
                                  urls: urls,
                                );
                                if (context.mounted) {
                                  Navigator.of(context).pop(ref);
                                }
                              } else if (isUpdate) {
                                await widget.post!.update(
                                  title: titleController.text,
                                  content: contentController.text,
                                  youtubeUrl: youtubeController.text,
                                  urls: urls,
                                );

                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              }
                            },
                            child:
                                Text(isCreate ? 'post Create'.t : 'Update'.t),
                          ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
