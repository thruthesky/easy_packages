import 'package:easy_forum/easy_forum.dart';
import 'package:easy_forum/unit_test/post_test.helper.dart';

void createPost() async {
  testStart('Create Post Test');
  final post = await Post.create(title: 'hellp', content: 'hellp');
  isTrue(post?.title == 'hellp' && post?.content == 'hellp',
      'Created Successfully');
  testReport();
}

void updatePost() async {
  testStart('Update Post Test');
  final post =
      await Post.create(title: 'Post title', content: 'this my post tile');
  isTrue(post?.content == 'this my post tile' && post?.title == 'Post title',
      'Creating Post');

  final updatePost = await post?.update(content: 'Updaing post content');

  //
  isTrue(updatePost?.content == 'Updaing post content', 'Updating the content');
  final updateTitle = await post?.update(title: 'Update post title');
  //
  isTrue(updateTitle?.title == 'Update post title', 'Updating the title');

  //
  final noUpdate = await post?.update();

  isTrue(noUpdate == null, 'No update');

  //
  testReport();
}
