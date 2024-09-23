import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easy_post_v2/unit_test/post_test.helper.dart';

const url = 'https://www.pexels.com/photo/person-in-spider-man-costume-13246954/';
const category = 'temp';
Future createPost() async {
  testStart('Create Post Test');
  final ref = await Post.create(category: category, title: 'hellp', content: 'hellp', urls: [url]);
  final post = await Post.get(ref.key!);
  isTrue(post.title == 'hellp' && post.content == 'hellp', 'Created Successfully');
  testReport();
}

void updatePost() async {
  testStart('Update Post Test');

  final ref = await Post.create(category: 'temp', title: 'Post title', content: 'this my post tile');
  final post = await Post.get(ref.key!);
  isTrue(post.content == 'this my post tile' && post.title == 'Post title', 'Creating Post');

  dog('post ${post.id}');
  // final updatePost = await post.update(content: 'Updaing post content');

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

  final post = await Post.get(ref.key!);
  isTrue(post.youtubeUrl == 'https://www.youtube.com/watch?v=nM0xDI5R50E', "Posting url");

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

void deletePost() async {
  const category = 'temp';
  testStart('Delete post');
  final ref = await Post.create(
    category: category,
    title: 'deleting post',
    content: 'deleting post ',
    youtubeUrl: 'https://www.youtube.com/watch?v=nM0xDI5R50E',
  );

  final post = await Post.get(ref.key!);

  await post.delete();

  final deletedPost = await Post.get(ref.key!);
  isTrue(deletedPost.deleted == true, "Deleting post");

  await isException(() async {
    await deletedPost.delete();
  });

  // final ref2 = await Post.create(
  //   category: 'temp',
  //   title: 'youtube',
  //   youtubeUrl: 'https://www.youtube.com/watch?v=nM0xDI5R50E',
  // );
  // final post2 = await Post.get(ref2.id);

  // await post2.delete();

  // final deletedPost2 = await Post.get(ref2.id);
  // isTrue(deletedPost2.deleted == true, "Deleting post");

  // await isException(() async {
  //   await deletedPost2.delete();
  // });
  testReport();
}

void getYoutube() async {
  // await getYoutubeConfig('https://www.youtube.com/watch?v=nM0xDI5R50E');
}
