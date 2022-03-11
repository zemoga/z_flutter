part of z.flutter.widgets;

const int kTabletSizeWidthThreshold = 600;

extension MediaQueryDataExt on MediaQueryData {
  bool get isPortrait => orientation == Orientation.portrait;

  bool get isLandscape => !isPortrait;

  bool get isTablet =>
      (isPortrait && size.width > kTabletSizeWidthThreshold) ||
      (isLandscape && size.height > kTabletSizeWidthThreshold);
}
