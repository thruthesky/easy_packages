import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easy_report/easy_report.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class UserPublicProfileScreen extends StatelessWidget {
  static const String routeName = '/UserPublicProfile';
  const UserPublicProfileScreen({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        // To add gradient
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter, // Start direction
              end: Alignment.bottomCenter, // End direction
              colors: [
                Colors.black, // Start Color
                // Slowly transition
                Color.fromARGB(225, 0, 0, 0),
                Color.fromARGB(200, 0, 0, 0),
                Color.fromARGB(156, 0, 0, 0),
                Color.fromARGB(99, 0, 0, 0),
                Colors.transparent, // End Color
              ],
            ),
          ),
        ),
        leading: const BackButton(
          color: Colors.white,
        ),
        shape: const LinearBorder(),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          if (user.uid == myUid)
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                i.showProfileUpdateScreen(context);
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            child: user.statePhotoUrl == null
                ? Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  )
                : SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: CachedNetworkImage(
                      errorWidget: (context, url, error) => Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      imageUrl: user.statePhotoUrl!,
                      fit: BoxFit.cover,
                    ),
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
          SafeArea(
            child: Center(
              child: Column(
                children: [
                  const Spacer(),
                  UserField<String>(
                    uid: user.uid,
                    field: User.field.photoUrl,
                    builder: (photoUrl) {
                      return UserAvatar(
                        photoUrl: photoUrl,
                        initials: user.displayName.or(user.name.or(user.uid)),
                        size: 100,
                        radius: 50,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    user.displayName,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  if (user.stateMessage.notEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        user.stateMessage!,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                  if (user.uid != my.uid)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...?UserService.instance.prefixActionBuilderOnPublicProfileScreen?.call(user),
                        TextButton(
                          onPressed: () async {
                            await i.block(context: context, otherUid: user.uid);
                          },
                          child: UserBlocked(
                            otherUid: user.uid,
                            builder: (blocked) => Text(
                              blocked ? 'unblock'.t : 'block'.t,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            await ReportService.instance.report(
                              context: context,
                              path: user.ref.path,
                              reportee: user.uid,
                              type: "User",
                              summary: "Reporting a user.",
                            );
                          },
                          child: Text(
                            'report'.t,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 32,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
