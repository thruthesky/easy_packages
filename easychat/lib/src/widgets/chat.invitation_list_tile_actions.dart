import 'package:flutter/material.dart';
import 'package:easy_locale/easy_locale.dart';

/// The actions for the ChatRoomInvitationListTile.
///
/// It contains two buttons: accept and reject.
///
/// Purpose:
/// - To display the progress (as disabled) while preventing the user from double clicking the same button.
class ChatInvitationListTileActions extends StatefulWidget {
  const ChatInvitationListTileActions({
    super.key,
    required this.onTapAccept,
    required this.onTapReject,
  });

  final Future Function() onTapAccept;
  final Future Function() onTapReject;

  @override
  State<ChatInvitationListTileActions> createState() =>
      _ChatInvitationListTileActionsState();
}

class _ChatInvitationListTileActionsState
    extends State<ChatInvitationListTileActions> {
  bool inProgress = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: inProgress
              ? null
              : () async {
                  if (inProgress) return;
                  setState(() => inProgress = true);
                  await widget.onTapAccept();
                  if (!mounted) return;
                  setState(() => inProgress = false);
                },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(12),
          ),
          child: Text("accept".t),
        ),
        const SizedBox(width: 4),
        ElevatedButton(
          onPressed: inProgress
              ? null
              : () async {
                  if (inProgress) return;
                  setState(() => inProgress = true);
                  await widget.onTapReject();
                  if (!mounted) return;
                  setState(() => inProgress = false);
                },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(12),
          ),
          child: Text("reject".t),
        ),
      ],
    );
  }
}
