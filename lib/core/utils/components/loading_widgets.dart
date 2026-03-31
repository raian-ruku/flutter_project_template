import 'package:flutter/material.dart';
import 'package:simplified_text_widget/simplified_text_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LoadingWidgets {}

Widget _skeleton({Widget? child, bool? ignoreContainers}) {
  return Skeletonizer(
    enabled: true,
    ignoreContainers: ignoreContainers,
    textBoneBorderRadius: TextBoneBorderRadius(
      BorderRadiusGeometry.circular(8),
    ),
    effect: PulseEffect(from: AppColors.gray30, to: AppColors.gray10),
    child: child!,
  );
}
