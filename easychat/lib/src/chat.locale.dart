import 'package:easy_locale/easy_locale.dart';

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

  // chat.bubble.dart
  'edited': {
    'en': 'Edited',
    'ko': '편집됨',
  },
  'this message has been deleted': {
    'en': 'This message has been deleted.',
    'ko': '이 메시지는 삭제되었습니다.',
  },

  // chat.bubble.long_press.popup_menu.dart
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

  // chat.bubble.reply.dart
  'replying to': {
    'en': 'Replying to',
    'ko': '답글',
  },
  'replying to user': {
    'en': 'Replying to {username}',
    'ko': '{username}에게 답장 중',
  },
  // 'this message has been deleted' -> chat.bubble.dart

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
    'ko': '반려',
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
    'en': 'You have no chat friends. Start chatting with someone.',
    'ko': '채팅 친구가 없습니다. 누군가와 채팅을 시작하세요.',
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
  final locale = await currentLocale;
  if (locale == null) return;

  for (var entry in localeTexts.entries) {
    lo.set(key: entry.key, locale: locale, value: entry.value[locale]);
  }
}
