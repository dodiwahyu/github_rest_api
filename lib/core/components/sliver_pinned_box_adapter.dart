import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SliverPinnedBoxAdapter extends SingleChildRenderObjectWidget {
  const SliverPinnedBoxAdapter(
      {Key? key, required this.pinned, required this.safeArea , required Widget child})
      : super(key: key, child: child);

  final bool pinned;
  final EdgeInsets safeArea;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderSliverPinnedBoxAdapter(safeArea: safeArea, pinned: pinned);
}

class _RenderSliverPinnedBoxAdapter extends RenderSliverSingleBoxAdapter {
  _RenderSliverPinnedBoxAdapter(
      { required this.pinned, required this.safeArea ,RenderBox? child})
      : super(child: child);

  /// If true, ✅ should stay pinned at the top of the list,
  /// ✅ but move back into it's original position when scrolling down
  ///
  /// If false, ✅ should move out of the list, ❌ but move back into it's original position
  /// when scrolling down
  ///
  /// ❌ You should be able to place a `pinned = false` sliver above a `pinned = true` sliver
  /// and have them never overlap
  ///
  /// ❌ Should not react to overscroll on iOS
  final bool pinned;

  /// Handle safeArea
  final EdgeInsets safeArea;

  double previousScrollOffset = 0;
  double ratchetingScrollDistance = 0;

  @override
  void performLayout() {
    child?.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    double childExtent = (child?.size.height ?? 0.0);

    final double paintedChildSize =
        calculatePaintOffset(constraints, from: 0.0, to: childExtent);
    final double cacheExtent =
        calculateCacheOffset(constraints, from: 0.0, to: childExtent);

    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);

    final dy = previousScrollOffset - constraints.scrollOffset;
    previousScrollOffset = constraints.scrollOffset;

    ratchetingScrollDistance =
        (ratchetingScrollDistance + dy).clamp(0.0, childExtent);

    double paddingTop = 0.0;

    if (ratchetingScrollDistance < childExtent) {
      paddingTop = childExtent - ratchetingScrollDistance;
      if (paddingTop > safeArea.top) {
        paddingTop = safeArea.top;
      }
    }

    if (pinned) {
      if (kDebugMode) {
        print(ratchetingScrollDistance);
        print(safeArea.top);
      }
    }

    geometry = SliverGeometry(
      scrollExtent: childExtent + paddingTop,
      paintExtent: paintedChildSize,
      cacheExtent: cacheExtent,
      maxPaintExtent: childExtent,
      hitTestExtent: paintedChildSize,
      hasVisualOverflow: childExtent > constraints.remainingPaintExtent ||
          constraints.scrollOffset > 0.0,
      paintOrigin: pinned
          ? constraints.scrollOffset + paddingTop
          : max(
              0,
              constraints.scrollOffset - childExtent + ratchetingScrollDistance,
            ),
      visible: true,
    );

    setChildParentData(child!, constraints, geometry!);
  }
}
