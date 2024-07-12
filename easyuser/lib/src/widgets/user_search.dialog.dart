import 'package:easy_locale/easy_locale.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

/// [emptyBuilder] empty builder return true if the empty is called in
/// the query result and return false if the empty is called
/// when the textfield is empty or the user is not yet searching in this way you
/// customize which emtpy you want to display
///
/// [padding] padding create padding around the dialog content
///
/// [itemBuilder] use item builder to create your own item list but keep in mind
/// that UserSearchDialog is just a dialog and we should keep it small as much as
/// possible by default we are using a contraint max heigth of 224
class UserSearchDialog extends StatefulWidget {
  const UserSearchDialog(
      {super.key, this.emptyBuilder, this.padding, this.itemBuilder});

  final Widget Function(bool)? emptyBuilder;
  final EdgeInsetsGeometry? padding;
  final Widget Function(User, int)? itemBuilder;

  @override
  State<UserSearchDialog> createState() => _UserSearchDialogState();
}

class _UserSearchDialogState extends State<UserSearchDialog> {
  final searchController = TextEditingController();
  String searchText = '';

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Dialog(
        child: Padding(
          padding: widget.padding ?? const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Find User'.t),
              const SizedBox(
                height: 8,
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search user'.t,
                  suffixIcon: IconButton(
                    onPressed: () {
                      searchText = searchController.text;
                      setState(() {});
                    },
                    icon: const Icon(Icons.send),
                  ),
                ),
                controller: searchController,
              ),
              if (searchText != '') ...{
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 224),
                  child: UserListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 8),
                    query: UserService.instance.col
                        // .orderBy('createdAt', descending: true)
                        .where('displayName',
                            isGreaterThanOrEqualTo: searchText)
                        .where('displayName',
                            isLessThanOrEqualTo: '$searchText\uf8ff')
                        .limit(5),
                    emptyBuilder: () =>
                        widget.emptyBuilder?.call(true) ??
                        SizedBox(
                          height: 224,
                          child: Center(
                            child: Text('No User found'.t),
                          ),
                        ),
                    itemBuilder: (user, index) =>
                        widget.itemBuilder?.call(user, index) ??
                        UserListTile(
                          contentPadding: EdgeInsets.zero,
                          user: user,
                          // trailing: IconButton(
                          //   onPressed: () {
                          //     // add friend function
                          //   },
                          //   icon: const Icon(
                          //     Icons.add_box,
                          //   ),
                          // ),
                        ),
                  ),
                )
              } else ...{
                widget.emptyBuilder?.call(false) ??
                    SizedBox(
                      height: 224,
                      child: Center(
                        child: Text('Search to find user'.t),
                      ),
                    ),
              }
            ],
          ),
        ),
      ),
    );
  }
}
