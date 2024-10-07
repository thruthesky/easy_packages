import 'package:easy_locale/easy_locale.dart';

final localeTexts = <String, Map<String, dynamic>>{
  // user.service.dart
  'you cannot block yourself': {
    'en': 'You cannot block yourself.',
    'ko': '자신을 차단할 수 없습니다.',
  },
  'un-block confirm title': {
    'en': 'Un-block User',
    'ko': '사용자 차단 해제',
  },
  'un-block confirm message': {
    'en': 'Are you sure you want to un-block this user?',
    'ko': '이 사용자의 차단을 해제하시겠습니까?',
  },
  'user is un-blocked': {
    'en': 'User is un-blocked',
    'ko': '사용자의 차단이 해제되었습니다',
  },
  'block confirm title': {
    'en': 'Block User',
    'ko': '사용자 차단',
  },
  'block confirm message': {
    'en': 'Are you sure you want to block this user?',
    'ko': '이 사용자를 차단하시겠습니까?',
  },
  'user is blocked': {
    'en': 'User is blocked',
    'ko': '사용자가 차단되었습니다',
  },

  // user.profile_update.screen.dart
  'update profile': {
    'en': 'Update Profile',
    'ko': '프로필 수정',
  },
  'sign-in first': {
    'en': 'Sign-in first',
    'ko': '로그인을 먼저 해주세요',
  },
  'displayName': {
    'en': 'Display Name',
    'ko': '닉네임',
  },
  'name': {
    'en': 'Name',
    'ko': '이름',
  },
  'gender': {
    'en': 'Gender',
    'ko': '성별',
  },
  'male': {
    'en': 'Male',
    'ko': '남자',
  },
  'female': {
    'en': 'Female',
    'ko': '여자',
  },
  'year': {
    'en': 'Year',
    'ko': '년도',
  },
  'month': {
    'en': 'Month',
    'ko': '월',
  },
  'day': {
    'en': 'Day',
    'ko': '일',
  },
  'state message': {
    'en': 'State Message',
    'ko': '상태 메시지',
  },
  'state photo': {
    'en': 'State Photo',
    'ko': '상태 사진',
  },
  'upload State Photo': {
    'en': 'Upload State Photo',
    'ko': '상태 사진 업로드',
  },
  'profile updated successfully': {
    'en': 'Profile Updated Successfully',
    'ko': '프로필 수정 성공',
  },
  'update': {
    'en': 'Update',
    'ko': '수정',
  },

  // user.public_profile.screen.dart
  'unblock': {
    'en': 'Un-block',
    'ko': '차단해제',
  },
  'block': {
    'en': 'Block',
    'ko': '차단',
  },
  'report': {
    'en': 'Report',
    'ko': '신고',
  },

  // block.list_view.dart
  'block list view is empty': {
    'en': 'You have not blocked anyone',
    'ko': '아직 아무도 차단하지 않았습니다',
  },

  // display_name.dart
  'no name': {
    'en': 'No name',
    'ko': '이름 없음',
  },

  // email_password_login.dart
  'email': {
    'en': 'Email',
    'ko': '이메일',
  },
  'input email': {
    'en': 'Input Email',
    'ko': '이메일 입력',
  },
  'password': {
    'en': 'Password',
    'ko': '비밀번호',
  },
  'input password': {
    'en': 'Input Password',
    'ko': '비밀번호 입력',
  },
  'login': {
    'en': 'Login',
    'ko': '로그인',
  },
  'link account': {
    'en': 'Link Account',
    'ko': '계정 연결',
  },

  // user.search.dialog.dart
  'search user': {
    'en': 'Search User',
    'ko': '사용자 검색',
  },
  'no user found': {
    'en': 'No User found',
    'ko': '사용자를 찾을 수 없습니다',
  },
  'search user description': {
    'en': 'Search user description',
    'ko': '사용자 검색 설명',
  },

  // user.update_avatar.dart
  'delete avatar?': {
    'en': 'Delete Avatar?',
    'ko': '프로필을 삭제하시겠습니까?',
  },
  'are you sure you wanted to delete this avatar?': {
    'en': 'Are you sure you wanted to delete this avatar?',
    'ko': '이 프로필을 삭제하시겠습니까?',
  },
};

applyUserLocales() async {
  lo.merge(localeTexts);
}
