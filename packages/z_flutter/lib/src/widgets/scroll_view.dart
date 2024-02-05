part of '../../widgets.dart';

class SliverSection extends StatelessWidget {
  const SliverSection({
    super.key,
    this.header,
    this.footer,
    required this.body,
  });

  final Widget? header;
  final Widget? footer;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        if (header != null) header!,
        body,
        if (footer != null) footer!,
      ],
    );
  }
}
