import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_storage/easy_storage.dart';
import 'package:flutter/material.dart';

/// ThumbnailImage
///
/// Display thumbnailed image from 'Image Resize' extension.
///
/// [url] is the image url
///
/// [size] is the size of the thumbnail image. Default is 'small' and can be
/// 'medium' or 'large'
///
/// Example:
/// ```dart
/// ThumbnailImage(
///  url: 'https://firebasestorage.googleapis.com/v0/b/grc-30andro-nez-6959712.jpg?alt=media&token=bdfe51',
/// size: 'medium',
/// )
/// ```
///
/// If the thumbnail image is not found, it will display the original image.
///
/// Refer README.md for more information
///
/// Note,
/// - If the thumbnail image does not exist, it will display the original image
///   * and it will flickering in this case !!
/// - If the thumbnail image exists, it will not flicker even if a setState is
///   called from outside or even if the parent widget is removed from widget
///   tree and re-created.
class ThumbnailImage extends StatelessWidget {
  const ThumbnailImage({
    super.key,
    required this.url,
    this.size = 'small',
    this.fit = BoxFit.cover,
    this.placeholder,
  });

  final String url;

  final String size;

  final BoxFit fit;
  final Widget Function(BuildContext, String)? placeholder;

  @override
  Widget build(BuildContext context) {
    String thumbnaileUrl = url.thumbnail;
    if (size == 'medium') {
      thumbnaileUrl = url.thumbnailMedium;
    } else if (size == 'large') {
      thumbnaileUrl = url.thumbnailLarge;
    }

    return CachedNetworkImage(
      imageUrl: thumbnaileUrl,
      fit: fit,
      placeholder: placeholder,
      errorWidget: (context, errorUrl, error) {
        return CachedNetworkImage(
          imageUrl: url,
          fit: fit,
          placeholder: placeholder,
          errorWidget: (context, url, error) => const Icon(Icons.error),
        );
      },
      errorListener: (value) => debugPrint(
        'Thumbnail not found -> Displaying original image.',
      ),
    );
  }
}
