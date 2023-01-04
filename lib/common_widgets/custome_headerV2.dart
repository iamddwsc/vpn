import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../theme/color.dart';
import 'custom_button.dart';

AppBar customHeader(String title,
    {String? leadingIcon,
    String? actionIcon,
    VoidCallback? rightActionPress,
    BuildContext? context}) {
  return AppBar(
    leading: leadingIcon != null
        ? GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => Navigator.of(context!).pop(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Image.asset(
                'assets/images/back_arrow3x.png',
                scale: 3,
              ),
            ),
          )
        : const SizedBox(
            width: 50,
          ),
    title: Text(
      title.tr(),
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w700, color: background),
    ),
    actions: actionIcon != null
        ? [
            CustomButton(
              type: ButtonType.icon,
              icon: Image.asset(
                actionIcon,
                scale: 3,
              ),
              buttonTextPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              onPressed: rightActionPress,
            )
          ]
        : null,
  );
}
