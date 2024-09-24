import 'package:flutter/material.dart';

/// Moving the child widget to the given alignment with the given duration.
class SleepWalker extends StatefulWidget {
  const SleepWalker({
    super.key,
    required this.child,
    required this.alignments,
    this.repeat = false,
  });

  final Widget child;
  final List<({Alignment alignment, Duration duration})> alignments;
  final bool repeat;

  @override
  State<SleepWalker> createState() => _SleepWalkerState();
}

class _SleepWalkerState extends State<SleepWalker> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: AlignmentTween(
        begin: widget.alignments[index].alignment,
        end: widget.alignments[index + 1].alignment,
      ),
      duration: widget.alignments[index].duration,

      /// 여기서 child 는 아래의 child 를 받아서, 위젯 트리에 추가하는 것이다.
      /// 즉, 이전 child 를 지우고, 새로운 child 를 widget tree 에 집어 넣는 것이다.
      builder: (BuildContext context, value, child) {
        return Align(
          alignment: value,
          child: child,
        );
      },
      onEnd: () {
        if (index + 2 >= widget.alignments.length) {
          if (widget.repeat) {
            index = 0;
            setState(() => index);
          }
          return;
        } else {
          index++;
          setState(() => index);
        }
      },
      child: widget.child,
    );
  }
}
