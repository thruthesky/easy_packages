import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';

final localeTexts = <String, Map<String, String>>{
  'chat': {
    'en': 'Chat',
    'ko': '채팅',
  },
  'send': {
    'en': 'Send',
    'ko': '보내기',
  },

  // chat.room.edit.screen.dart
  'chat room create': {
    'en': 'Chat Room Create',
    'ko': '채팅방 생성',
  },
  'chat room update': {
    'en': 'Chat Room Update',
    'ko': '채팅방 수정',
  },
  'group chat name': {
    'en': 'Group Chat Name',
    'ko': '그룹 채팅 이름',
  },
  'enter room name': {
    'en': 'Enter room name',
    'ko': '채팅방 이름을 입력하세요',
  },
  'you can change this chat room name later': {
    'en': 'This is the chat room name. You can change it later.',
    'ko': '이것이 채팅방 이름입니다. 나중에 변경할 수 있습니다.',
  },
  'description': {
    'en': 'Description',
    'ko': '그룹 채팅 설명',
  },
  'enter description': {
    'en': 'Enter description',
    'ko': '그룹 채팅 설명을 입력하세요',
  },
  'this is chat room description': {
    'en': 'This is the chat room description.',
    'ko': '이것이 채팅방 설명입니다.',
  },
  'open chat': {
    'en': 'Open Chat',
    'ko': '공개 채팅',
  },
  'anyone can join this chat room': {
    'en': 'Anyone can join this chat room.',
    'ko': '누구나 이 채팅방에 참여할 수 있습니다.',
  },
  'create': {
    'en': 'Create',
    'ko': '생성',
  },
  'update': {
    'en': 'Update',
    'ko': '수정',
  },

  // chat.room.list.screen.dart
  'chat room list': {
    'en': 'Chat Room List',
    'ko': '채팅방 목록',
  },
  ChatRoomQuery.allMine.name.toLowerCase(): {
    'en': 'My Chats',
    'ko': '내 채팅',
  },
  ChatRoomQuery.allMineByTime.name.toLowerCase(): {
    'en': 'My Chats Ordered by Time',
    'ko': '내 채팅 시간 순',
  },
  ChatRoomQuery.single.name.toLowerCase(): {
    'en': '1:1 Chats',
    'ko': '1:1 채팅',
  },
  ChatRoomQuery.singleByTime.name.toLowerCase(): {
    'en': '1:1 Chats Ordered by Time',
    'ko': '1:1 채팅 시간 순',
  },
  ChatRoomQuery.group.name.toLowerCase(): {
    'en': 'Group Chats',
    'ko': '그룹 채팅',
  },
  ChatRoomQuery.groupByTime.name.toLowerCase(): {
    'en': 'Group Chats Ordered by Time',
    'ko': '그룹 채팅 시간 순',
  },
  ChatRoomQuery.receivedInvites.name.toLowerCase(): {
    'en': 'Received Chat Invitations',
    'ko': '받은 채팅 초대',
  },
  ChatRoomQuery.rejectedInvites.name.toLowerCase(): {
    'en': 'Rejected Chat Invitations',
    'ko': '반려된 채팅 초대',
  },
  ChatRoomQuery.open.name.toLowerCase(): {
    'en': 'Open Chats',
    'ko': '공개 채팅',
  },

  // chat.room.screen.dart
  'no name': {
    'en': 'No name',
    'ko': '이름 없음',
  },
  'chat room': {
    'en': 'Chat Room',
    'ko': '채팅방',
  },
  'unaccepted yet, once you sent a message, the chat is automatically accepted':
      {
    'en':
        "You haven't accepted this chat yet. Once you send a message, the chat is automatically accepted.",
    'ko': "아직 이 채팅을 수락하지 않았습니다. 메시지를 보내면 채팅이 자동으로 수락됩니다.",
  },
  'rejected chat, if replied, the chat will be accepted': {
    'en':
        "You have rejected this chat. However, if you sent a reply, the chat is automatically accepted.",
    'ko': "이 채팅을 거절하셨습니다. 그러나 답장을 보내면 채팅이 자동으로 수락됩니다.",
  },
  'this is open chat, if sent a message, you join the room': {
    'en':
        "This is an open group. Once you sent a message, you will automatically join the group.",
    'ko': "이것은 오픈 그룹입니다. 메시지를 보내면 자동으로 그룹에 가입됩니다.",
  },
  'the chat room mau be private or deleted': {
    'en': "The Chat Room may be private and/or deleted.",
    'ko': "채팅방은 비공개 또는 삭제될 수 있습니다.",
  },
  'unable to show chat messages': {
    'en': "Unable to show chat messages.",
    'ko': "채팅 메시지를 보여줄 수 없습니다.",
  },

  // received.chat.room.invite_list.screen.dart
  'accept/reject chat requests': {
    'en': 'Accept/Reject Chat Requests',
    'ko': '채팅 요청 수락/반려',
  },
  'no chat requests': {
    'en': 'No Chat Requests',
    'ko': '채팅 요청',
  },

  // rejected.chat.room.invite_list.screen.dart
  'rejected chat requests': {
    'en': 'Rejected Chat Requests',
    'ko': '반려된 채팅 요청',
  },
  'rejected chat': {
    'en': 'Rejected Chat',
    'ko': '반려된 채팅',
  },
  'you have rejected chat already, accept the chat instead?': {
    'en': "You have rejected the chat already. Accept and continue chat?",
    'ko': "이미 이 채팅을 거절하셨습니다. 수락하고 계속 채팅하시겠습니까?"
  },
  'no chat rejected': {
    'en': 'No chat rejected.',
    'ko': '아직 채팅을 거절하지 않았습니다.',
  },

  // chat.bubble.dart
  'reply': {
    'en': 'Reply',
    'ko': '답장',
  },
  'edit': {
    'en': 'Edit',
    'ko': '수정',
  },
  'delete': {
    'en': 'Delete',
    'ko': '삭제',
  },
  'edited': {
    'en': 'Edited',
    'ko': '편집됨',
  },
  'this message has been deleted': {
    'en': 'This message has been deleted.',
    'ko': '이 메시지는 삭제되었습니다.',
  },

  // chat.bubble.reply.dart
  'replying to': {
    'en': 'Replying to',
    'ko': '답글',
  },
  'replying to user': {
    'en': 'Replying to {username}',
    'ko': '{username}에게 답장 중',
  },
  'the message being replied has been deleted': {
    'en': 'The message being replied has been deleted',
    'ko': '답장 중인 메시지가 삭제되었습니다'
  },
  'photo': {
    'en': 'Photo',
    'ko': '사진',
  },

  // chat.messages.list_view.dart
  'something went wrong': {
    'en': 'Something went wrong',
    'ko': '오류가 발생했습니다',
  },
  'no chat message in room yet': {
    'en': 'No chat message yet!',
    'ko': '채팅 메시지가 없습니다!',
  },

  // chat.new_message_counter.dart
  // Nothing to translate

  // chat.room.input_box.dart
  // 'something went wrong' -> chat.messages.list_view.dart
  // Nothing else to translate

  // chat.room.invitation.list_tile.dart
  'accept': {
    'en': 'Accept',
    'ko': '수락',
  },
  'reject': {
    'en': 'Reject',
    'ko': '거절',
  },

  // chat.room.invitation.short.list.dart
  // 'something went wrong' -> chat.room.input_box.dart
  'message request/invitations': {
    'en': "Message Requests/Invitations!",
    'ko': "메시지 요청/초대!",
  },
  'see more requests': {
    'en': "See more requests...",
    'ko': "더 많은 요청 보기...",
  },

  // chat.room.list_tile.dart
  'last message was deleted': {
    'en': 'The last message was deleted',
    'ko': '마지막 메시지가 삭제되었습니다',
  },

  // chat.room.list_view.dart
  // 'something went wrong' -> chat.room.invitation.short.list.dart
  'chat list is empty': {
    'en': 'No Chat rooms yet.',
    'ko': '아직 채팅방이 없습니다.',
  },

  // chat.room.member.list.dialog.dart
  'members': {
    'en': 'Members',
    'ko': '멤버',
  },

  // chat.room.menu.drawer.dart
  'members counted': {
    'en': 'Members ({num})',
    'ko': '멤버 ({num})',
  },
  'and more members': {
    'en': '... and more.',
    'ko': '... 더 많은 멤버',
  },
  'see all members': {
    'en': 'See All Members',
    'ko': '모든 멤버 보기',
  },
  'invite more users': {
    'en': 'Invite More Users',
    'ko': '더 많은 사용자 초대',
  },
  'you cannot invite yourself': {
    'en': 'You cannot invite yourself.',
    'ko': '자신을 초대할 수 없습니다.',
  },
  'the user is already invited': {
    'en': 'The user is already invited.',
    'ko': '이 사용자는 이미 초대되었습니다.',
  },
  'the user is already a member': {
    'en': 'The user is already a member.',
    'ko': '이 사용자는 이미 멤버입니다.',
  },
  'invited user': {
    'en': 'Invited User',
    'ko': '초대된 사용자',
  },
  'user has been invited': {
    'en': '{username} has been invited.',
    'ko': '{username}님이 초대되었습니다',
  },
  'options': {
    'en': 'Options',
    'ko': '옵션',
  },
  // 'update' -> chat.room.edit.screen.dart
  'leave': {
    'en': 'Leave',
    'ko': '나가기',
  },
  'leaving room': {
    'en': 'Leaving Room',
    'ko': '채팅방 나가기',
  },
  'leaving room confirmation': {
    'en': "Are you sure you want to leave the room?",
    'ko': "채팅을 나가시겠습니까?",
  },
  'block': {
    'en': 'Block',
    'ko': '차단',
  },
  'report': {
    'en': 'Report',
    'ko': '신고',
  },

  // chat.room.replying_to
  // 'replying to' -> chat.bubble.reply.dart
  // Nothing else to translate

  // edit.chat.message.dialog.dart
  'edit message': {
    'en': 'Edit Message',
    'ko': '메시지 수정',
  },
  'cancel': {
    'en': 'Cancel',
    'ko': '취소',
  },
  'empty message': {
    'en': 'Empty Message',
    'ko': '빈 메시지',
  },
  'saving empty message, confirm if delete instead': {
    'en': "Saving empty message. Do you want to delete the message instead?",
    'ko': "빈 메시지를 저장 중입니다. 대신 메시지를 삭제하시겠습니까?"
  },
  'save': {
    'en': 'Save',
    'ko': '저장',
  },

  // chat.exception.dart
  // Nothing to translate

  // chat.functions.dart
  'login to get the single chat room id': {
    'en': 'Login to get the single chat room id',
    'ko': '1:1 채팅방 ID를 얻으려면 로그인하세요.',
  },

  // chat.service.dart
  'can only send message if member, invited or open chat': {
    'en':
        'You can only send a message to a chat room where you are a member or an invited user, or the room is an open group chat room',
    'ko': "회원이거나 초대된 사용자이거나, 방이 오픈 그룹 채팅방인 경우에만 메시지를 보낼 수 있습니다."
  },
};

applyChatLocales() async {
  lo.merge(localeTexts);

  // final locale = await currentLocale;
  // if (locale == null) return;

  // for (var entry in localeTexts.entries) {
  //   if (lo.get(key: entry.key, locale: locale) != null) continue;
  //   lo.set(key: entry.key, locale: locale, value: entry.value[locale]);
  // }
}
