import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nizvpn/theme/color.dart';

enum PopupType {
  blue,
  red,
  white,
}

Future<void> showCustomPopup(
  BuildContext context, {
  PopupType type = PopupType.blue,
  String? title,
  String? content,
  String? note,
  Widget? icon,
  String? actionLabel,
  Function? actionJob,
  String? cancelLabel,
  Function? cancelJob,
  bool hasBorder = false,
  bool hasBorderBtn = false,
  bool hasCloseButton = false,
  BorderRadiusGeometry? borderRadius,
  EdgeInsetsGeometry? paddingContent,
  bool centerTitle = false,
  bool centerContent = true,
  bool onlyActionBtnExpanded = false,
  bool columBtnExpanded = false,
  bool largePopup = false,
  bool disableBackey = false,
  Function? onDismiss,
}) async {
  actionJob ??= () {
    Navigator.of(context).pop();
  };
  cancelJob ??= () {
    Navigator.of(context).pop();
  };
  borderRadius ??= BorderRadius.circular(8);
  paddingContent ??=
      const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 6);
  bool twoButton = (actionLabel != null && cancelLabel != null);
  double widthPopup =
      MediaQuery.of(context).size.width * (largePopup ? 0.8 : 0.7);

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return WillPopScope(
        onWillPop: () async {
          if (disableBackey) {
            return false;
          } else {
            return true;
          }
        },
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Center(
            child: Container(
              color: Colors.transparent,
              width: widthPopup,
              child: Stack(
                children: [
                  Container(
                    margin: hasCloseButton
                        ? const EdgeInsets.only(top: 11, right: 11)
                        : const EdgeInsets.all(0),
                    padding: paddingContent,
                    width: widthPopup,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: borderRadius,
                      border: Border.all(
                        width: 2,
                        color: hasBorder ? bgColorGrey : Colors.transparent,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: centerContent
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (icon != null)
                          Container(
                            color: Colors.transparent,
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  constraints: const BoxConstraints(
                                    minWidth: 44,
                                    minHeight: 44,
                                    maxWidth: 104,
                                    maxHeight: 104,
                                  ),
                                  child: icon,
                                )
                              ],
                            ),
                          ),
                        const SizedBox(height: 10),
                        if (title != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            width: double.infinity,
                            child: Text(
                              title,
                              style: TextStyle(
                                color: mainColorBlack,
                                fontFamily: mainFontFamily,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                decoration: TextDecoration.none,
                              ),
                              textAlign: (centerContent || centerTitle)
                                  ? TextAlign.center
                                  : TextAlign.left,
                            ),
                          ),
                        if (content != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              content,
                              style: TextStyle(
                                color: (title != null)
                                    ? bgColorGrey
                                    : mainColorBlack,
                                fontFamily: mainFontFamily,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                decoration: TextDecoration.none,
                              ),
                              textAlign: centerContent
                                  ? TextAlign.center
                                  : TextAlign.left,
                            ),
                          ),
                        if (note != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              note,
                              style: TextStyle(
                                color: stateError,
                                fontFamily: mainFontFamily,
                                fontWeight: FontWeight.w400,
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        Container(
                          child: columBtnExpanded
                              ? Column(
                                  children: [
                                    if (actionLabel != null)
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _actionButton(
                                                actionLabel, actionJob, type),
                                          ),
                                        ],
                                      ),
                                    if (cancelLabel != null)
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _cancelButton(cancelLabel,
                                                cancelJob, type, hasBorderBtn),
                                          ),
                                        ],
                                      ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: twoButton
                                      ? MainAxisAlignment.spaceAround
                                      : MainAxisAlignment.center,
                                  children: [
                                    if (cancelLabel != null)
                                      _cancelButton(cancelLabel, cancelJob,
                                          type, hasBorderBtn),
                                    if (actionLabel != null)
                                      (!twoButton && onlyActionBtnExpanded)
                                          ? Expanded(
                                              child: _actionButton(
                                                  actionLabel, actionJob, type),
                                            )
                                          : _actionButton(
                                              actionLabel, actionJob, type),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                  if (hasCloseButton)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Image.asset(
                          'assets/icons/rebrand/ic_delete_circle.png',
                          width: 22,
                          height: 22,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  ).then((value) {
    if (onDismiss != null) {
      onDismiss();
    }
  });
}

Widget _actionButton(
  String text,
  Function? action,
  PopupType type,
) {
  return TextButton(
    style: ButtonStyle(
      minimumSize: MaterialStateProperty.all<Size>(const Size(100, 36)),
      padding: MaterialStateProperty.all<EdgeInsets>(
        const EdgeInsets.all(0),
      ),
      backgroundColor: MaterialStateProperty.all<Color>(
        (type == PopupType.blue) ? mainColorBlue700 : mainColorWhite,
      ),
      overlayColor: MaterialStateProperty.all<Color>(
        mainColorBlack.withOpacity(.1),
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      side: MaterialStateProperty.all<BorderSide>(
        BorderSide(
          width: 1.0,
          color: (type == PopupType.red)
              ? stateError
              : (type == PopupType.white)
                  ? bgColorGrey
                  : Colors.transparent,
        ),
      ),
    ),
    onPressed: () => action!(),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: (type == PopupType.blue)
            ? mainColorWhite
            : (type == PopupType.red)
                ? stateError
                : mainColorBlack,
        fontFamily: mainFontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
    ),
  );
}

Widget _cancelButton(
  String text,
  Function? action,
  PopupType type,
  bool hasBorderBtn,
) {
  return TextButton(
    style: ButtonStyle(
      minimumSize: MaterialStateProperty.all<Size>(const Size(100, 36)),
      padding: MaterialStateProperty.all<EdgeInsets>(
        const EdgeInsets.all(0),
      ),
      backgroundColor: MaterialStateProperty.all<Color>(
        mainColorWhite,
      ),
      overlayColor: MaterialStateProperty.all<Color>(
        mainColorBlack.withOpacity(.1),
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      side: MaterialStateProperty.all<BorderSide>(
        BorderSide(
          width: 1.0,
          color: (type == PopupType.white || hasBorderBtn)
              ? bgColorGrey
              : Colors.transparent,
        ),
      ),
    ),
    onPressed: () => action!(),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: mainColorBlack,
        fontFamily: mainFontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
    ),
  );
}
