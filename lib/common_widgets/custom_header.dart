import 'package:flutter/material.dart';

import '../theme/color.dart';
import 'custom_button.dart';

class MyCustomHeader extends StatelessWidget {
  const MyCustomHeader({
    Key? key,
    this.leftWidget,
    this.centerWidget,
    this.rightWidget,
    this.hasBackButton = true,
    this.title,
    this.rightTextButton,
    this.rightImageButton,
    this.rightButtonAction,
  }) : super(key: key);
  final Widget? leftWidget;
  final Widget? centerWidget;
  final Widget? rightWidget;
  final String? title;
  final String? rightTextButton;

  /// Path for ImageButton
  final String? rightImageButton;
  final VoidCallback? rightButtonAction;
  final bool hasBackButton;

  @override
  Widget build(BuildContext context) {
    Widget right = rightTextButton != null
        ? CustomButton(
            type: ButtonType.text,
            text: rightTextButton!,
            buttonTextPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            textStyle: const TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
            toUpperCase: false,
          )
        : rightImageButton != null
            ? CustomButton(
                type: ButtonType.icon,
                icon: Image.asset(
                  rightImageButton!,
                  scale: 3,
                ),
                buttonTextPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                onPressed: rightButtonAction,
              )
            : const SizedBox(
                width: 50,
              );
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Row(
        children: [
          hasBackButton
              ? GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => Navigator.of(context).pop(),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Image.asset(
                      'assets/images/back_arrow3x.png',
                      scale: 3,
                    ),
                  ),
                )
              : leftWidget ??
                  SizedBox(
                    width: 63,
                    height: 49,
                    child: Image.asset(
                      'assets/images/home/giftbox3x.png',
                      scale: 3,
                    ),
                  ),
          centerWidget ??
              Expanded(
                child: Center(
                  child: Text(
                    title ?? '',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: background),
                  ),
                ),
              ),
          rightWidget ?? right,
        ],
      ),
    );
  }
}
