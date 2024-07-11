import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

/// UserPhotoListView is a stateless widget that displays a horizontal list view of user photos.
///
/// It is designed to be used within a UI where a compact representation of user profiles is needed.
/// Each user profile consists of a user avatar and a display name, arranged vertically.
/// The list is scrollable horizontally, allowing for the display of multiple user profiles within a constrained space.
class UserPhotoListView extends StatelessWidget {
  const UserPhotoListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Creates a horizontally scrollable list of user photos and names.
    return SizedBox(
      height: 64, // Sets the height of the widget to 64 logical pixels.
      child: UserListView(
        scrollDirection:
            Axis.horizontal, // Makes the list scrollable horizontally.
        itemBuilder: (user, index) => Padding(
          // Applies horizontal padding differently for the first item for visual alignment.
          padding: EdgeInsets.fromLTRB(index == 0 ? 24 : 4, 0, 4, 0),
          child: SizedBox(
            width:
                72 - 16, // Sets the width of each item, accounting for padding.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .center, // Centers the children horizontally.
              children: [
                UserAvatar(user: user), // Displays the user's avatar.
                DisplayName(
                    user: user,
                    maxLines: 1), // Displays the user's name, truncated to fit.
              ],
            ),
          ),
        ),
      ),
    );
  }
}
