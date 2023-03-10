import 'package:flutter/material.dart';

class IntroButton extends StatelessWidget {
  const IntroButton({
    Key? key,
    required this.child,
    this.onPressed,
    this.style,
    this.semanticLabel,
  }) : super(key: key);
  final Widget child;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Semantics(
        label: semanticLabel,
        button: true,
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ).merge(style),
          child: child,
        ),
      ),
    );
  }
}
