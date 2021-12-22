import 'package:flutter/material.dart';

/// A sliver that contains a circular progress indicator centered within
/// the constrained area created from [width] and [height].
class SliverCenteredCircularProgressIndicator extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? indicatorColor;
  final Color? backgroundColor;

  const SliverCenteredCircularProgressIndicator({
    Key? key,
    this.width,
    this.height,
    this.indicatorColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
        child: Container(
          color: backgroundColor,
          width: width,
          height: height,
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              indicatorColor ?? Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      );
}
