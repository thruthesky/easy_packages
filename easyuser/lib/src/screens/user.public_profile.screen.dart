import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class UserPublicProfileScreen extends StatelessWidget {
  static const String routeName = '/UserPublicProfile';
  const UserPublicProfileScreen({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return UserDoc(
      uid: user.uid,
      sync: true,
      builder: (user) => user == null
          ? const Center(child: CircularProgressIndicator.adaptive())
          : Stack(
              children: [
                SizedBox(
                  height: double.infinity,
                  child: user.statePhotoUrl == null
                      ? Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: user.statePhotoUrl!,
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
                    height: 320,
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
                    leading: const BackButton(
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.transparent,
                    actions: [
                      if (user.uid == myUid)
                        IconButton(
                          icon: const Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            i.showProfileUpdaeScreen(context);
                          },
                        ),
                    ],
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
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          if (user.stateMessage.isNotEmpty)
                            Text(
                              user.stateMessage,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          const SizedBox(
                            height: 32,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
