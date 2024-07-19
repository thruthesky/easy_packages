/// getCommentOrderString
///
/// Firebase Firestore Database 에서 코멘트의 정렬을 위한 문자열을 생성한다. 코멘트는
/// 글에 대한 코멘트이며, 글에 대한 코멘트는 글의 noOfComments 값을 가지고 있다.
///
/// 코멘트의 단계에서 형제 코멘트가 하나 생성 될 때, sortString 의 블록 값이 1씩 증가한다.
String getCommentOrderString({
  required int depth,
  int? noOfComments,
  String? sortString,
}) {
  /// 맨 첫 번째 코멘트란, 글에 최초로 작성되는 코멘트. 1번째 코멘트. 해당 글에 하나 뿐이다.
  /// 첫번째 레벨 코멘트란, 글 바로 아래에 작성되는 코멘트로, 부모 코멘트가 없는 코멘트이다. 이 경우 depth=0 이다.
  ///
  /// [noOfComments] 는 글의 noOfComments 를 그대로 입력하면 된다.
  /// 참고, 맨 첫번째 코멘트를 작성할 때는 noOfComments 값을 그냥 0의 값(또는 NULL)을 입력하면 된다.
  ///
  /// [sortString] 는 부모 코멘트의 sortString 을 그 대로 입력하면 된다. 첫번째 레벨 코멘트의 경우, 빈 NULL (또는 빈문자열)을 입력하면 된다.
  ///
  /// [depth] 는 부모 코멘트의 depth 이다. depth 를 부모의 것을 그대로 입력하면 된다. 부모 코멘트의 depth 가 3 이면, 3+1 로 입력하지 말고 그냥 3을 그대로 입력한다.
  /// 함수로 전달하기 전에 +1 을 할 필요 없다. 왜냐하면, 첫번째 레벨 코멘트는 [sortString] 이 빈문자열이어서, [depth] 값 자체가 필요없다.
  /// [sortString] 값이 있다는 것은, 첫 번째 레벨 코멘트가 아니라는 뜻이고, [depth]에 1 이상의 값이 들어가 있다는 뜻이다.
  ///
  /// 참고, 코멘트를 저장 할 때에는 [depth] 에 +1 을 해서 저장해야 한다. 첫번째 레벨의 경우, 기본값 1로 저장.
  /// 즉, 모든 코멘트에는 (첫 번째 레벨 코멘트라도) depth 필드에 1 이상의 값을 가진다.
  /// 코멘트 생성시 [sortString] 과 [depth] 지정 예제)
  /// ```dart
  /// FirebaseFirestore.instance.collection('comments').add({
  ///     'sortString': getCommentSortString(noOfComments: post.noOfComments, depth: parent?.depth ?? 0, sortString: parentComment?.sort),
  ///     'depth': parent == null ? 1 : parent.depth + 1,
  /// });
  /// ```
  ///
  /// [maxDepth] 코멘트 레벨 최대 깊이
  const int maxDepth = 9;
  noOfComments ??= 0;
  sortString ??= "";
  if (sortString == "") {
    final firstPart = 100000 + noOfComments;
    return '$firstPart.100000.100000.100000.100000.100000.100000.100000.100000.100000';
  } else {
    if (depth > maxDepth) depth = maxDepth;
    List<String> parts = sortString.split('.');
    String block = parts[depth];
    int computed =
        int.parse(block) + noOfComments + 1; // 처음이 0일 수 있다. 0이면, 부모와 같아서 안됨.
    parts[depth] = computed.toString();
    sortString = parts.join('.');
    return sortString;
  }
}
