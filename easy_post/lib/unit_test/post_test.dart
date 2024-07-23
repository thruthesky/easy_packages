import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easy_post_v2/unit_test/post_test.helper.dart';

const url =
    'https://www.pexels.com/photo/person-in-spider-man-costume-13246954/';
void createPost() async {
  testStart('Create Post Test');
  final ref = await Post.create(
      category: 'temp', title: 'hellp', content: 'hellp', urls: [url]);
  dog('$ref');
  final post = await Post.get(ref.id);
  isTrue(
      post.title == 'hellp' && post.content == 'hellp', 'Created Successfully');
  testReport();
}

void updatePost() async {
  testStart('Update Post Test');

  final ref = await Post.create(
      category: 'temp', title: 'Post title', content: 'this my post tile');
  final post = await Post.get(ref.id);
  isTrue(post.content == 'this my post tile' && post.title == 'Post title',
      'Creating Post');

  dog('post ${post.id}');
  final updatePost = await post.update(content: 'Updaing post content');

  //
  // isTrue(updatePost?.content == 'Updaing post content', 'Updating the content');
  // final updateTitle = await post.update(title: 'Update post title');
  // //

  // isTrue(updateTitle?.title == 'Update post title', 'Updating the title');

  // final updateUrls = await post.update(urls: [url]);

  // isTrue(updateUrls!.urls.contains(url), 'Updating the post');

  await isException(() async {
    await post.update();
  });

  //

  //
  testReport();
}

void createYouyubePost() async {
  testStart('Update Post Test');
  final ref = await Post.create(
    category: 'youtube',
    youtubeUrl: 'https://www.youtube.com/watch?v=nM0xDI5R50E',
  );

  final post = await Post.get(ref.id);
  isTrue(post.youtubeUrl == 'https://www.youtube.com/watch?v=nM0xDI5R50E',
      "Posting url");

  await isException(() async {
    await Post.create(
      category: 'youtube',
      youtubeUrl: 'https://www.youtube.com/watch?v=nM0xDI5R50Easdasdasd',
    );
  });

  await Post.create(
    category: 'youtube',
    youtubeUrl: 'https://www.youtube.com/watch?v=nM0xDI5R50Easdasdasd',
  );
  testReport();
}
