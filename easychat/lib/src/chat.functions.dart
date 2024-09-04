import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:easy_helpers/easy_helpers.dart';

const String chatRoomDivider = '---';

// /// 채팅방 ID 에서, 1:1 채팅방인지 확인한다.
isSingleChatRoom(String roomId) {
  final splits = roomId.split(chatRoomDivider);
  return splits.length == 2 && splits[0].isNotEmpty && splits[1].isNotEmpty;
}

// /// 채팅방 ID 에서 그룹 채팅방 ID 인지 확인한다.
// isGroupChat(String roomId) => roomId.split('-').length == 1;

/// 1:1 채팅방 ID 에서 다른 사용자의 uid 를 리턴한다.
///
/// 그룹 채팅방 ID 이면, null 을 리턴한다.
///
/// 주의, 자기 자신과 대화를 할 수 있으니, 그 경우에는 자기 자신의 uid 를 리턴한다.
String? getOtherUserUidFromRoomId(String roomId) {
  //
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) return null;
  final splits = roomId.split(chatRoomDivider);
  if (splits.length != 2) {
    return null;
  }
  for (final uid in splits) {
    if (uid != currentUser.uid) {
      return uid;
    }
  }
  return currentUser.uid;
}

/// Returns a chat room ID from a user's uid.
/// 대화할 상대방의 UID 를 입력 받아, 일대일 채팅방 ID 를 만든다.
///
/// 로그인 사용자의 uid 와 [otherUserUid] 를 정렬해서 합친다.
String singleChatRoomId(String otherUserUid) {
  if (FirebaseAuth.instance.currentUser?.uid == null) {
    // throw 'chat/auth-required Loign to get the sing chat room id';
    throw ChatException(
      'auth-required',
      'login to get the single chat room id'.t,
    );
  }
  final uids = [FirebaseAuth.instance.currentUser!.uid, otherUserUid];
  uids.sort();
  return uids.join(chatRoomDivider);
}

/// Returns the chat room title for single and group chat.
String roomTitle(ChatRoom? room, User? user) {
  assert(room != null || user != null);

  if (user != null) {
    return user.displayName.or('no name'.t);
  }

  // Single chat or group chat can have name.
  if ((room?.name ?? "").trim().isNotEmpty) {
    return room!.name;
  }
  return 'chat room'.t;
}

// bool get iAmInvited => $room?.invitedUsers.contains(myUid!) ?? false;
// bool get iRejected => $room?.rejectedUsers.contains(myUid!) ?? false;

// String notMemberMessage(ChatRoom? room) {
//   if (iAmInvited) {
//     return 'unaccepted yet, accept before reading message'.t;
//   }
//   if (iRejected) {
//     return 'the chat was rejected, unable to show message'.t;
//   }
//   if (isJoiningNow) {
//     return 'please wait'.t;
//   }
//   // Else, it should be handled by the Firestore rulings.
//   return 'the chat room may be private or deleted'.t;
// }

// String notMemberTitle(ChatRoom? room) {
//   if (iAmInvited) {
//     return "chat invitation".t;
//   }
//   if (iRejected) {
//     return 'rejected chat'.t;
//   }
//   if (isJoiningNow) {
//     return 'loading'.t;
//   }
//   // Else, it should be handled by the Firestore rulings.
//   return 'unable to chat'.t;
// }
