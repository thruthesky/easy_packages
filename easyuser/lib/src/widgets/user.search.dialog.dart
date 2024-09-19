// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

/// [emptyBuilder] will be called with a boolean when the list is empty.
/// true will be passed if the user submit the search word and no user found.
/// false will be passwd otherwise. So, when the dialog is opened, the list
/// will be empty and the emptyBuilder will be called with false.
///
/// [padding] padding create padding around the dialog content
///
/// [itemBuilder] use item builder to create your own item list but keep in mind
/// that UserSearchDialog is just a dialog and we should keep it small as much as
/// possible by default we are using a contraint max heigth of 224
///
/// [exactSearch] if true the search will be exact if false the search will be
/// partial search.
///
/// [searchName] if true the search will be based on the name.
///
/// [searchNickname] if true the search will be based on the nickname.
///
/// If both of [searchName] and [searchNickname] are false, the search will be
/// based on the name.
///
///
class UserSearchDialog extends StatefulWidget {
  const UserSearchDialog({
    super.key,
    this.emptyBuilder,
    this.padding,
    this.itemBuilder,
    this.exactSearch = true,
    this.searchName = false,
    this.searchNickname = false,
  });

  final Widget Function(bool)? emptyBuilder;
  final EdgeInsetsGeometry? padding;
  final Widget Function(User, int)? itemBuilder;
  final bool exactSearch;
  final bool searchName;
  final bool searchNickname;

  @override
  State<UserSearchDialog> createState() => _UserSearchDialogState();
}

class _UserSearchDialogState extends State<UserSearchDialog> {
  final searchController = TextEditingController();
  // TODO cleanup
  // final userCol = UserService.instance.col;
  final usersRef = UserService.instance.usersRef;
  String searchText = '';

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  Query get query {
    String field;
    if (widget.searchName) {
      field = 'caseIncensitveName';
    } else if (widget.searchNickname) {
      field = 'caseIncensitiveDisplayName';
    } else {
      field = 'caseIncensitveName';
    }

    return widget.exactSearch
        ? usersRef.orderByChild(field).equalTo(searchText)
        // TODO cleanup
        // : userCol
        //     .where(field, isGreaterThanOrEqualTo: searchText)
        //     .where(field, isLessThanOrEqualTo: '$searchText\uf8ff');
        : usersRef.orderByChild(field).startAt(searchText).endAt('$searchText\uf8ff');
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search user'.t,
                    suffixIcon: IconButton(
                      onPressed: onSubmit,
                      icon: const Icon(Icons.send),
                    ),
                  ),
                  controller: searchController,
                  onSubmitted: onSubmit,
                ),
                if (searchText != '') ...{
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 224,
                      minHeight: 224,
                    ),
                    // TODO clean up
                    // child: FirestoreUserListView(
                    //   shrinkWrap: true,
                    //   padding: const EdgeInsets.only(top: 8),
                    //   query: query.limit(4),
                    //   emptyBuilder: () =>
                    //       widget.emptyBuilder?.call(true) ??
                    //       SizedBox(
                    //         height: 224,
                    //         child: Center(
                    //           child: Text('No User found'.t),
                    //         ),
                    //       ),
                    //   itemBuilder: (user, index) =>
                    //       widget.itemBuilder?.call(user, index) ??
                    //       UserListTile(
                    //         user: user,
                    //         onTap: () => Navigator.of(context).pop(user),
                    //       ),
                    // ),
                    // TODO add List View
                    child: const Text("@TODO: Add list view"),
                  )
                } else ...{
                  widget.emptyBuilder?.call(false) ??
                      SizedBox(
                        height: 224,
                        child: Center(
                          child: Text('Search user description'.t),
                        ),
                      ),
                }
              ],
            ),
          ),
        ),
      ),
    );
  }

  onSubmit([String? value]) {
    searchText = searchController.text.toLowerCase();
    dog(searchText);
    setState(() {});
  }
}
