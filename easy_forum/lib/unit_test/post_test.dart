import 'package:easy_forum/easy_forum.dart';

Future<Post?>? createPost() async {
  return await Post.create(title: 'hellp', content: 'hellp');
}
