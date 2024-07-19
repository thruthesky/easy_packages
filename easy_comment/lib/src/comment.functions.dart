/// getCommentOrderString
///
/// Firebase Firestore Database 에서 코멘트의 정렬을 위한 문자열을 생성한다. 코멘트는
/// 글에 대한 코멘트이며, 글에 대한 코멘트는 글의 noOfComments 값을 가지고 있다.
///
/// 코멘트의 단계에서 형제 코멘트가 하나 생성 될 때, sortString 의 블록 값이 1씩 증가한다.
///
/// 맨 첫 번째 코멘트란, 글에 최초로 작성되는 코멘트. 1번째 코멘트. 해당 글에 하나 뿐이다.
/// 첫번째 레벨 코멘트란, 글 바로 아래에 작성되는 코멘트로, 부모 코멘트가 없는 코멘트이다. 이 경우 depth=0 이다.
///
/// [noOfComments] 는 글의 noOfComments 를 그대로 입력하면 된다.
/// 참고, 맨 첫번째 코멘트를 작성할 때는 noOfComments 값을 그냥 0의 값(또는 NULL)을 입력하면 된다.
///
/// [sortString] 는 부모 코멘트의 sortString 을 그 대로 입력하면 된다. 첫번째 레벨 코멘트의 경우, 빈 NULL (또는 빈문자열)을 입력하면 된다.
///
/// [depth] 는 부모 코멘트의 depth + 1 값으로 들어와야 한다. 부모 코멘트의 depth 가 3 이면, 3+1 로 입력되어야 한다.
/// 단, 입력되는 [sortString] 값이 null 또는 빈 문자열이면, [depth] 값은 무시된다. 왜냐하면, 첫번째 레벨 코멘트이기 때문이다.
/// 그리고, 새 코멘트를 저장 할 때에는 [depth] 에 +1 을 해서 저장해야 한다. 첫번째 레벨의 경우, 기본값을 0으로 저장하면 된다.
/// 즉, 첫번째 레벨의 코멘트는 항상 depth = 0 이다.
///
///
///
String getCommentOrderString({
  required int depth,
  int? noOfComments,
  String? sortString,
}) {
  /// [maxDepth] 코멘트 레벨 최대 깊이
  const int maxDepth = 9;
  noOfComments ??= 0;
  sortString ??= "";
  if (sortString.isEmpty) {
    /// 첫번째 블록을 +1 하는 것이 아니라, DB 액세스를 줄이고자, noOfComments 값을 사용한다.
    final String firstPart = noOfComments.toString().padLeft(6, '0');
    return '$firstPart.000000.000000.000000.000000.000000.000000.000000.000000.000000';
  } else {
    /// maxDepth 보다 depth 가 크면, maxDepth - 1 로 설정해서, 맨 마지막 블록을 증가시킨다.
    /// 즉, max depth 를 제한한다.
    if (depth >= maxDepth) depth = maxDepth - 1;

    List<String> parts = sortString.split('.');

    /// 블록에서, 1씩 증가하는 것이 아니라, noOfComments 값으로 증가한다.
    /// 이 문제를 해결 하기 위해서는 이전 (형제) 코멘트를 한번 더 DB 에서 읽어야하는 상황이 발생해서,
    /// DB 액세스를 줄이고자, noOfComments 값을 사용한다.
    int blockValue = int.parse(parts[depth]);
    blockValue = noOfComments;
    parts[depth] = blockValue.toString().padLeft(6, '0');

    /// 아래의 코드는 굳이 필요 없지만, 혹시 모르니 남겨 둔다.
    for (int i = depth + 1; i < maxDepth; i++) {
      parts[i] = '000000'; // 하위 depth를 초기화
    }

    return parts.join('.');
  }
}
