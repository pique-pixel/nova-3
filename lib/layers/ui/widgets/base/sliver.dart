import 'package:flutter/widgets.dart';
import 'dart:math' as math;

class PreferredSizePersistentHeaderWidgetDelegate
    extends SliverPersistentHeaderDelegate {
  final PreferredSizeWidget child;

  PreferredSizePersistentHeaderWidgetDelegate({@required this.child});

  @override
  double get minExtent => child.preferredSize.height;

  @override
  double get maxExtent => child.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(PreferredSizePersistentHeaderWidgetDelegate oldDelegate) {
    return false;
  }
}

class FixedSizePersistentHeaderWidgetDelegate
    extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  FixedSizePersistentHeaderWidgetDelegate({
    @required this.child,
    @required this.height,
  });

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(FixedSizePersistentHeaderWidgetDelegate oldDelegate) {
    return false;
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
