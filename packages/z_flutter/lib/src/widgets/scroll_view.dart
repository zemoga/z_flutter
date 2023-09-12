part of z.flutter.widgets;

class SliverSection extends StatelessWidget {
  const SliverSection({
    Key? key,
    this.header,
    this.footer,
    required this.body,
  }) : super(key: key);

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
