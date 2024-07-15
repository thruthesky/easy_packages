import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_helpers/easy_helpers.dart';
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
///
/// [exactSearch] if true the search will be exact if false the search will be
/// partial search.
///
/// [searchName] if true the search will be based on the name if false the
/// search will be based on the displayName. By default it is true.
class UserSearchDialog extends StatefulWidget {
  const UserSearchDialog({
    super.key,
    this.emptyBuilder,
    this.padding,
    this.itemBuilder,
    this.exactSearch = true,
    this.searchName = true,
  });

  final Widget Function(bool)? emptyBuilder;
  final EdgeInsetsGeometry? padding;
  final Widget Function(User, int)? itemBuilder;
  final bool exactSearch;
  final bool searchName;

  @override
  State<UserSearchDialog> createState() => _UserSearchDialogState();
}

class _UserSearchDialogState extends State<UserSearchDialog> {
  final searchController = TextEditingController();
  final userCol = UserService.instance.col;
  String searchText = '';

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  Query get query {
    final field = widget.searchName ? 'name' : 'displayName';
    return widget.exactSearch
        ? userCol.where(field, isEqualTo: searchText)
        : userCol
            .where(field, isGreaterThanOrEqualTo: searchText)
            .where(field, isLessThanOrEqualTo: '$searchText\uf8ff');
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
              const SizedBox(
                height: 8,
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search user'.t,
                  suffixIcon: IconButton(
                    onPressed: () {
                      searchText = searchController.text;
                      dog(searchText);
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
                    query: query.limit(4),
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
                        ),
                  ),
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
    );
  }
}
