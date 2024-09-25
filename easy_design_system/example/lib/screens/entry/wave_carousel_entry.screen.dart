import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class WaveCarouselEntryScreen extends StatefulWidget {
  static const String routeName = '/WaveCarouselEntry';
  const WaveCarouselEntryScreen({super.key});

  @override
  State<WaveCarouselEntryScreen> createState() =>
      _WaveCarouselEntryScreenState();
}

class _WaveCarouselEntryScreenState extends State<WaveCarouselEntryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WaveCarouselEntry(
        autoSwipeInterval: 3000,
        bottomStroke: 8,
        bottomStrokeColor: Colors.grey,
        titleSpacing: 16,
        start: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('CONTINUE'),
        ),
        logo: Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFffe1f1),
          ),
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: 'https://picsum.photos/250/?image=400',
              fit: BoxFit.cover,
            ),
          ),
        ),
        items: [
          (
            title: Text(
              "Casual Talk",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text(
              "Please join casual and enjoyable conversations with potential matches using our meeting app. Easily connect and chat.",
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
              textAlign: TextAlign.center,
            ),
            image: CachedNetworkImage(
              imageUrl: 'https://picsum.photos/250?image=90',
              fit: BoxFit.cover,
            ),
          ),
          (
            title: Text(
              "Extends Social Circle",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text(
              "Discover interesting individuals to connect with. Our meeting app makes it easy to broaden your horizons and meet diverse people.",
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
              textAlign: TextAlign.center,
            ),
            image: CachedNetworkImage(
              imageUrl: 'https://picsum.photos/250?image=100',
              fit: BoxFit.cover,
            ),
          ),
          (
            title: Text(
              "Discover New Connections",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text(
              "Our meeting app is designed to help you find new connections and expand your social circle. Join us and meet new people.",
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
              textAlign: TextAlign.center,
            ),
            image: CachedNetworkImage(
              imageUrl: 'https://picsum.photos/250?image=110',
              fit: BoxFit.cover,
            ),
          ),
          (
            title: Text(
              "Meaningful Connections",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text(
              "Create meaningful connections through honest conversations. Our app fosters a friendly and welcoming environment for meeting potential partners.",
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
              textAlign: TextAlign.center,
            ),
            image: CachedNetworkImage(
              imageUrl: 'https://picsum.photos/250?image=120',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
