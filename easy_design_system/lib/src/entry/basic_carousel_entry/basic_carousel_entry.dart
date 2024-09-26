import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loop_page_view/loop_page_view.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

typedef BasicCarouselItem = ({
  Widget title,
  Widget subtitle,
  Widget image,
});

/// Round Carousel Entry
///
class BasicCarouselEntry extends StatefulWidget {
  const BasicCarouselEntry({
    super.key,
    this.backgroundWidget,
    required this.items,
    // required this.onStart,
    required this.start,
    this.autoSwipeInterval = 3000,
    this.bottomGradient,
    this.indicatorColor = Colors.grey,
    this.indicatorActiveColor = Colors.white,
    this.bottomStroke = 0,
    this.bottomStrokeColor = Colors.grey,
    this.titleSpacing = 8.0,
  });
  final Widget? backgroundWidget;
  final List<BasicCarouselItem> items;
  // final VoidCallback onStart;
  final Widget start;
  final int autoSwipeInterval;
  final Widget? bottomGradient;
  final Color? indicatorColor;
  final Color? indicatorActiveColor;
  final double bottomStroke;
  final Color bottomStrokeColor;
  final double titleSpacing;

  @override
  State<BasicCarouselEntry> createState() => _BasicCarouselEntryState();
}

class _BasicCarouselEntryState extends State<BasicCarouselEntry> {
  DragUpdateDetails? updateDetails;
  LoopPageController controller = LoopPageController();
  final indicator = PublishSubject<int>();
  Timer? autoSwipe;

  @override
  void initState() {
    super.initState();

    if (widget.autoSwipeInterval > 100) {
      autoSwipe = Timer.periodic(Duration(milliseconds: widget.autoSwipeInterval), (timer) {
        if (mounted) {
          controller
              .nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          )
              .then((value) {
            if (!mounted) return;
            // then 에서 해야 올바른 페이지 번호가 나옴
            indicator.add(controller.page.toInt());
          });
        }
      });
    }
  }

  @override
  void dispose() {
    autoSwipe?.cancel();
    indicator.close();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const Center(
        child: Text('No items'),
      );
    }
    // 스와이프 제스쳐를 받아서, ListView 나 Indicator 등을 업데이트
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragUpdate: (details) {
        int sensitivity = 8;
        if (details.delta.dx.abs() > sensitivity) {
          updateDetails = details;
        }
      },
      onHorizontalDragEnd: (details) {
        if (updateDetails != null) {
          autoSwipe?.cancel();
          if (updateDetails!.delta.dx > 0) {
            // 오른쪽으로 스와이프'
            controller
                .previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            )
                .then((value) {
              // then 에서 해야 올바른 페이지 번호가 나옴
              indicator.add(controller.page.toInt());
            });
          } else if (updateDetails!.delta.dx < 0) {
            //  왼쪽으로 스와이프'
            controller
                .nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            )
                .then((value) {
              // then 에서 해야 올바른 페이지 번호가 나옴
              indicator.add(controller.page.toInt());
            });
          }
        }
      },

      /// Full screen size
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Theme.of(context).colorScheme.surface,
              ),
            ),

            /// Background
            if (widget.backgroundWidget != null) widget.backgroundWidget!,

            Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .6,
                  child: IgnorePointer(
                    child: LoopPageView.builder(
                      controller: controller,
                      itemCount: widget.items.length,
                      itemBuilder: (_, i) => widget.items[i].image,
                    ),
                  ),
                ),

                /// Graident on the picture
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: widget.bottomGradient ??
                      Container(
                        height: MediaQuery.of(context).size.height * .3,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(.99),
                            ],
                          ),
                        ),
                      ),
                ),
              ],
            ),

            Positioned(
              top: MediaQuery.of(context).size.height * .6,
              left: 0,
              right: 0,
              child: Divider(
                height: widget.bottomStroke,
                thickness: widget.bottomStroke,
                color: widget.bottomStrokeColor,
              ),
            ),

            // Indicator
            Positioned(
              top: MediaQuery.of(context).size.height * .57,
              left: 0,
              right: 0,
              child: Center(
                child: StreamBuilder<int>(
                  stream: indicator,
                  builder: (context, snapshot) {
                    return AnimatedSmoothIndicator(
                      activeIndex: snapshot.data ?? 0,
                      count: 4,
                      effect: ExpandingDotsEffect(
                        dotWidth: 8.0,
                        dotHeight: 8.0,
                        dotColor: widget.indicatorColor ?? Colors.white,
                        activeDotColor: widget.indicatorActiveColor ?? Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),

            /// 제목
            Positioned(
              top: MediaQuery.of(context).size.height * .70,
              left: 0,
              right: 0,
              child: Center(
                child: StreamBuilder<Object>(
                    stream: indicator,
                    builder: (context, snapshot) {
                      return widget.items[int.parse(snapshot.data?.toString() ?? '0')].title;
                    }),
              ),
            ),

            SizedBox(
              height: widget.titleSpacing,
            ),

            /// 부 제목
            Positioned(
              top: MediaQuery.of(context).size.height * .73,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.only(
                    top: widget.titleSpacing,
                  ),
                  width: MediaQuery.of(context).size.width * .7,
                  child: StreamBuilder<Object>(
                    stream: indicator,
                    builder: (context, snapshot) {
                      return widget.items[int.parse(snapshot.data?.toString() ?? '0')].subtitle;
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Center(
                  child: Column(
                    children: [
                      widget.start,
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
