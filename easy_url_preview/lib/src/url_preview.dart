import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_url_preview/src/url_preview.model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// [UrlPreview] is a widget that shows a preview of a URL.
///
/// [previewUrl] is the url of the preview.
///
/// [title] is the title of the preview.
///
/// [description] is the description of the preview.
///
/// [imageUrl] is the image of the preview.
///
/// [text] is the text that contains the URL. If it's not empty, then it will
/// load the preview information and display
///
class UrlPreview extends StatefulWidget {
  const UrlPreview({
    super.key,
    this.previewUrl,
    this.title,
    this.description,
    this.imageUrl,
    this.text,
    this.maxLinesOfDescription = 2,
  });

  final String? previewUrl;
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? text;
  final int maxLinesOfDescription;

  @override
  State<UrlPreview> createState() => _UrlPreviewState();
}

class _UrlPreviewState extends State<UrlPreview> {
  String? previewUrl;
  String? title;
  String? description;
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    previewUrl = widget.previewUrl;
    title = widget.title;
    description = widget.description;
    imageUrl = widget.imageUrl;
    if (widget.text != null && widget.text!.isNotEmpty) {
      loadPreview();
    }
  }

  void loadPreview() async {
    // log('-> loadPreview() begin;');
    final model = UrlPreviewModel();
    String? firstLink = model.getFirstLink(text: widget.text!);
    // log('-> firstLink: $firstLink');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (firstLink != null) {
      final String? data = prefs.getString(firstLink);
      // log('-> Using cached data: $data');
      if (data != null) {
        /// [parts] is a list of strings that are separated by '||'
        final List<String> parts = data.split('||');
        if (parts.length == 4) {
          setState(() {
            previewUrl = parts[0];
            title = parts[1];
            description = parts[2];
            imageUrl = parts[3];
          });
          return;
        }
      }
    }

    await model.load(widget.text);
    // log('-> model.load() -> result: $model');
    if (!model.hasData) return;

    setState(() {
      previewUrl = model.firstLink;
      title = model.title;
      description = model.description;
      imageUrl = model.image;
    });

    await prefs.setString(
      model.firstLink!,
      '${model.firstLink}||${model.title}||${model.description}||${model.image}',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (previewUrl == null || previewUrl!.isEmpty) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () async {
        if (await canLaunchUrlString(previewUrl!)) {
          await launchUrlString(previewUrl!);
        } else {
          throw 'Could not launch $previewUrl';
        }
      },
      child: Container(
        /// [imageUrl] are sometimes smaller than the length of the [description] and leads to
        /// inconsistent design of the [UrlPreview] in [ChatViewScreen] and [ForumChatViewScreen]
        /// [BoxConstraints] to make it a single width and consistent design

        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null && imageUrl!.isNotEmpty) ...[
              CachedNetworkImage(
                imageUrl: imageUrl!,
                // Don't show
                errorWidget: (context, url, error) {
                  log("Not showing an image preview because there's a problem with the url: $imageUrl");
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 8),
            ],
            if (title != null && title!.isNotEmpty) ...[
              Text(
                title!,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (description != null && description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                description!.length > 100 ? '${description!.substring(0, 90)}...' : description!,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
                maxLines: widget.maxLinesOfDescription,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
