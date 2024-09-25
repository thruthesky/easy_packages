import 'package:easy_design_system/easy_design_system.dart';
import 'package:flutter/material.dart';

RoundedRectangleBorder comicRoundedRectangleBorder(BuildContext context, [double? round]) =>
    RoundedRectangleBorder(
      side: BorderSide(
        width: comicBorderWidth,
        color: Theme.of(context).colorScheme.outline,
      ),
      borderRadius: BorderRadius.circular(round ?? comicBorderRadius),
    );

Color comicContainerBackgroundColor(BuildContext context) => Theme.of(context).colorScheme.surface;
