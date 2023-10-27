part of z.flutter.widgets;

class FooterView extends StatelessWidget {
  const FooterView({
    super.key,
    required this.body,
    required this.footer,
  });

  final Widget body;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: body,
          ),
          footer,
        ],
      ),
    );
  }
}
