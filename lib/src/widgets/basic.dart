part of z.flutter.widgets;

/// A box that contains an image and a text message. The [dense]
/// attribute is used to generate a more condensed layout variant
/// to be used in a portion of the viewport.
class InformationMessage extends StatelessWidget {
  final String imageAssetName;
  final String? messageText;
  final TextSpan? messageTextSpan;
  final bool dense;
  final String buttonTitle;
  final VoidCallback? onButtonPressed;

  const InformationMessage({
    Key? key,
    required this.imageAssetName,
    required this.messageText,
    this.dense = false,
    this.buttonTitle = "",
    this.onButtonPressed,
  })  : assert(messageText != null),
        messageTextSpan = null,
        super(key: key);

  const InformationMessage.rich({
    Key? key,
    required this.imageAssetName,
    required this.messageTextSpan,
    this.dense = false,
    this.buttonTitle = "",
    this.onButtonPressed,
  })  : assert(messageTextSpan != null),
        messageText = null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: dense ? Dimens.spacing500 : Dimens.spacingLarge300,
        horizontal: dense ? Dimens.spacingLarge200 : Dimens.spacingLarge300,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            imageAssetName,
            width: dense ? Dimens.spacingLarge400 : Dimens.spacingLarge600,
          ),
          Text.rich(
            TextSpan(
              style: theme.textTheme.bodyText2,
              text: messageText,
              children: messageTextSpan != null
                  ? <InlineSpan>[messageTextSpan!]
                  : null,
            ),
            textAlign: TextAlign.center,
          ),
          if (buttonTitle.isNotEmpty)
            TextButton(
              onPressed: onButtonPressed,
              style: TextButton.styleFrom(
                textStyle: theme.textTheme.bodyText2?.copyWith(
                  decoration: TextDecoration.underline,
                ),
              ),
              child: Text(buttonTitle),
            ),
        ],
      ),
    );
  }
}
