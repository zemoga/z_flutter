part of '../../widgets.dart';

///
abstract class IndicatorPainter extends CustomPainter {
  const IndicatorPainter({
    required this.pageCount,
    required this.page,
  });

  final int pageCount;
  final double page;

  @override
  bool shouldRepaint(IndicatorPainter oldDelegate) {
    return oldDelegate.page != page;
  }
}

///
abstract interface class IndicatorStyle {
  const IndicatorStyle();

  Size computeSize(int pageCount);

  IndicatorPainter buildPainter(int pageCount, double page);
}

///
abstract interface class DotsStyle implements IndicatorStyle {
  const DotsStyle({
    this.dotWidth = 8.0,
    this.dotHeight = 8.0,
    this.dotSpacing = 4.0,
    this.dotRadius = const Radius.circular(4.0),
    this.dotColor = const Color(0xDD000000),
  });
  final double dotWidth;
  final double dotHeight;
  final double dotSpacing;
  final Radius dotRadius;
  final Color dotColor;
}

///
final class _ColorTransitionDotsPainter extends IndicatorPainter {
  _ColorTransitionDotsPainter({
    required super.pageCount,
    required super.page,
    required this.style,
  });

  final ColorTransitionDotsStyle style;

  @override
  void paint(Canvas canvas, Size size) {
    final activePage = page.floor();
    final lerpFactor = page - activePage;
    final dotPaint = Paint();
    var drawingOffset = 0.0;
    for (var i = 0; i < pageCount; i++) {
      var color = style.dotColor;
      if (i == activePage) {
        color = Color.lerp(style.dotColorActive, style.dotColor, lerpFactor)!;
      }
      if (i - 1 == activePage) {
        color = Color.lerp(style.dotColor, style.dotColorActive, lerpFactor)!;
      }

      final xPos = drawingOffset;
      final yPos = size.height / 2;
      final rRect = RRect.fromLTRBR(
        xPos,
        yPos - style.dotHeight / 2,
        xPos + style.dotWidth,
        yPos + style.dotHeight / 2,
        style.dotRadius,
      );
      dotPaint.color = color;
      canvas.drawRRect(rRect, dotPaint);
      drawingOffset = rRect.right + style.dotSpacing;
    }
  }
}

///
final class ColorTransitionDotsStyle extends DotsStyle {
  const ColorTransitionDotsStyle({
    super.dotWidth,
    super.dotHeight,
    super.dotSpacing,
    super.dotRadius,
    super.dotColor = const Color(0x42000000),
    this.dotColorActive = const Color(0xDD000000),
  });

  final Color dotColorActive;

  @override
  Size computeSize(int count) {
    final sizeWidth = count * (dotWidth + dotSpacing) - dotSpacing;
    return Size(sizeWidth, dotHeight);
  }

  @override
  IndicatorPainter buildPainter(int pageCount, double page) {
    return _ColorTransitionDotsPainter(
      pageCount: pageCount,
      page: page,
      style: this,
    );
  }
}

///
final class _ExpandingDotsPainter extends IndicatorPainter {
  const _ExpandingDotsPainter({
    required super.pageCount,
    required super.page,
    required this.style,
  });

  final ExpandingDotsStyle style;

  @override
  void paint(Canvas canvas, Size size) {
    final activePage = page.floor();
    final lerpFactor = page - activePage;
    final dotPaint = Paint()..color = style.dotColor;
    var drawingOffset = 0.0;
    for (var i = 0; i < pageCount; i++) {
      var width = style.dotWidth;
      if (i == activePage) {
        width = lerpDouble(style.dotWidthActive, style.dotWidth, lerpFactor)!;
      }
      if (i - 1 == activePage) {
        width = lerpDouble(style.dotWidth, style.dotWidthActive, lerpFactor)!;
      }

      final xPos = drawingOffset;
      final yPos = size.height / 2;
      final rRect = RRect.fromLTRBR(
        xPos,
        yPos - style.dotHeight / 2,
        xPos + width,
        yPos + style.dotHeight / 2,
        style.dotRadius,
      );
      canvas.drawRRect(rRect, dotPaint);
      drawingOffset = rRect.right + style.dotSpacing;
    }
  }

  @override
  bool shouldRepaint(_ExpandingDotsPainter oldDelegate) {
    return oldDelegate.page != page;
  }
}

///
final class ExpandingDotsStyle extends DotsStyle {
  const ExpandingDotsStyle({
    super.dotWidth,
    super.dotHeight,
    super.dotSpacing,
    super.dotRadius,
    super.dotColor,
    double dotExpansionFactor = 4.0,
  }) : dotWidthActive = dotWidth * dotExpansionFactor;

  final double dotWidthActive;

  @override
  Size computeSize(int count) {
    final sizeWidth = dotWidthActive + (dotWidth + dotSpacing) * (count - 1);
    return Size(sizeWidth, dotHeight);
  }

  @override
  IndicatorPainter buildPainter(int pageCount, double page) {
    return _ExpandingDotsPainter(pageCount: pageCount, page: page, style: this);
  }
}

///
final class PageViewIndicator extends StatelessWidget {
  const PageViewIndicator({
    super.key,
    required this.pageCount,
    required this.pageController,
    this.style = const ColorTransitionDotsStyle(),
    this.axisDirection = Axis.horizontal,
  });

  final int pageCount;
  final PageController pageController;
  final IndicatorStyle style;
  final Axis axisDirection;

  @override
  Widget build(BuildContext context) {
    final quarterTurns = axisDirection == Axis.vertical ? 1 : 0;
    final initialPage = pageController.initialPage;
    return ListenableBuilder(
      listenable: pageController,
      builder: (context, _) {
        final page = pageController.page ?? initialPage.toDouble();
        return RotatedBox(
          quarterTurns: quarterTurns,
          child: CustomPaint(
            size: style.computeSize(pageCount),
            painter: style.buildPainter(pageCount, page),
          ),
        );
      },
    );
  }
}
