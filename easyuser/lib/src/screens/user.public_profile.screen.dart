import 'package:cached_network_image/cached_network_image.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class UserPublicProfileScreen extends StatelessWidget {
  static const String routeName = '/UserPublicProfile';
  const UserPublicProfileScreen({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: double.infinity,
          child: user.photoUrl == null
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: Center(
                    child: Text(
                      user.displayName.isEmpty
                          ? user.uid[0].toUpperCase()
                          : user.displayName[0].toUpperCase(),
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ),
                )
              : CachedNetworkImage(
                  imageUrl: user.photoUrl!,
                  fit: BoxFit.cover,
                ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 220,
            decoration: const BoxDecoration(
              // borderRadius: borderRadius,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black54,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 220,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black54,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
          ),
          body: SafeArea(
            child: Center(
              child: Column(
                children: [
                  const Spacer(),
                  UserAvatar(
                    user: user,
                    size: 100,
                    radius: 50,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    user.displayName,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    user.name == '' ? '' : '(${user.name})',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
