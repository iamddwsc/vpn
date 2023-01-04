import 'package:flutter/material.dart';
import 'package:nizvpn/common_widgets/assets_widget.dart';
import 'package:nizvpn/theme/color.dart';
import 'package:nizvpn/ui/utils/global_variable.dart';

AppBar commonAppbar(
  BuildContext context, {
  String title = '',
  bool titleCenter = true,
  bool noBack = false,
  String? backText,
  Widget? backIcon,
  Function? backAction,
  bool hasNext = false,
  String? nextText,
  Widget? nextIcon,
  Function? nextAction,
}) {
  Widget titleWidget = Text(
    title,
    style: isLightMode ? styleAppBarTitle : styleAppBarTitleDark,
  );

  Widget backWidget;
  if (noBack) {
    backWidget = Container();
  } else {
    if (backText != null) {
      backWidget = TextButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.all(0),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          ),
        ),
        child: Text(
          backText,
          style: isLightMode ? styleAppBarBack : styleAppBarBackDark,
        ),
        onPressed: () {
          if (backAction != null) {
            backAction();
          } else {
            Navigator.of(context).pop();
          }
        },
      );
    } else {
      var icBack = isLightMode ? iconBack : iconBackDark;
      if (backIcon != null) {
        icBack = backIcon;
      }
      backWidget = IconButton(
        padding: const EdgeInsets.all(0),
        icon: icBack,
        onPressed: () {
          if (backAction != null) {
            backAction();
          } else {
            Navigator.of(context).pop();
          }
        },
      );
    }
  }

  Widget nextWidget;
  if (!hasNext) {
    nextWidget = Container();
  } else {
    if (nextText != null) {
      nextWidget = TextButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.all(0),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          ),
        ),
        child: Text(
          nextText,
          style: isLightMode ? styleAppBarNext : styleAppBarNextDark,
        ),
        onPressed: () {},
      );
    } else {
      if (nextIcon != null) {
        nextWidget = IconButton(
          padding: const EdgeInsets.all(0),
          icon: nextIcon,
          onPressed: () {
            if (nextAction != null) {
              nextAction();
            } else {
              Navigator.of(context).pop();
            }
          },
        );
      } else {
        nextWidget = Container();
      }
    }
  }

  return AppBar(
    backgroundColor: isLightMode ? mainColorWhite : mainColorDark,
    leading: backWidget,
    title: titleWidget,
    centerTitle: titleCenter,
    actions: [
      nextWidget,
    ],
  );
}
