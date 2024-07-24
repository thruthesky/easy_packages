import 'package:easy_locale/easy_locale.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easy_storage/easy_storage.dart';
import 'package:flutter/material.dart';

class PostEditScreen extends StatefulWidget {
  static const String routeName = '/PostEdit';
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

  List<String> urls = [];

  @override
  void initState() {
    super.initState();

    prepareData();
    if (widget.category != null) {
      category = widget.category!;
    }
  }

  /// prepare data if the event is update a post to display in the screen if its create
  /// display
  prepareData() {
    if (isCreate) return;
    if (widget.post == null) return;
    titleController.text = widget.post!.title;
    contentController.text = widget.post!.content;
    youtubeController.text = widget.post!.youtubeUrl;
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
          child: Column(
            children: [
              DropdownButton<String?>(
                  isDense: false,
                  padding: const EdgeInsets.only(
                      left: 12, top: 4, right: 4, bottom: 4),
                  isExpanded: true, // 화살표 아이콘을 오른쪽에 밀어 붙이기
                  menuMaxHeight: 300, // 높이 조절
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text('Select Category'.t),
                    ),
                    ...PostService.instance.categories.entries.map((e) {
                      return DropdownMenuItem(
                        value: e.key,
                        child: Text(e.value),
                      );
                    }),
                  ],
                  value: category,
                  onChanged: (value) {
                    setState(() {
                      category = value;
                    });
                  }),
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
              DisplayEditableUploads(
                  urls: urls,
                  onDelete: (url) {
                    urls.remove(url);
                    setState(() {});
                  }),
              Row(
                children: [
                  UploadIconButton(onUpload: (url) {
                    urls.add(url);
                    setState(() {});
                  }),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
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
                    child: Text(isCreate ? 'post Create'.t : 'Update'.t),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
