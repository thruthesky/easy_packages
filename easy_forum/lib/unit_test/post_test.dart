import 'package:easy_forum/easy_forum.dart';
import 'package:easy_forum/unit_test/post_test.helper.dart';
import 'package:easy_helpers/easy_helpers.dart';

const url =
    'https://www.pexels.com/photo/person-in-spider-man-costume-13246954/';
void createPost() async {
  testStart('Create Post Test');
  final post = await Post.create(title: 'hellp', content: 'hellp', urls: [url]);
  dog('post ${post!.id}');
  isTrue(
      post.title == 'hellp' && post.content == 'hellp', 'Created Successfully');
  testReport();
}

void updatePost() async {
  testStart('Update Post Test');

  final post =
      await Post.create(title: 'Post title', content: 'this my post tile');
  isTrue(post?.content == 'this my post tile' && post?.title == 'Post title',
      'Creating Post');

  dog('post ${post!.id}');
  final updatePost = await post.update(content: 'Updaing post content');

  //
  isTrue(updatePost?.content == 'Updaing post content', 'Updating the content');
  final updateTitle = await post.update(title: 'Update post title');
  //

  isTrue(updateTitle?.title == 'Update post title', 'Updating the title');

  final updateUrls = await post.update(urls: [url]);

  isTrue(updateUrls!.urls!.contains(url), 'Updating the post');

  await isException(() async {
    await post.update();
  });

  //

  //
  testReport();
}
