import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/color.dart';
// import 'package:sssmarket/Theme/colors.dart';

enum ButtonType {
  outLine,
  outLineWithIcon,
  flat,
  raised,
  icon,
  text,
  textInString
}

enum BorderType {
  circle, //30
  circle10, //10
  rect, //6
  rect20, //20
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    this.icon,
    this.text = '',
    this.onPressed,
    this.type,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.customWidth,
    this.customHeight,
    this.borderType,
    this.iconSize,
    this.fontSize,
    this.hasBorder = false,
    this.boderWidth,
    this.tooltip,
    this.fontWeight = FontWeight.w500,
    this.buttonTextPadding,
    this.isShowLoading,
    this.boderRadius,
    this.toUpperCase = true,
    this.autoResizeText = true,
    this.textStyle,
    this.iconPadding,
  });
  final Widget? icon;
  final String? text;
  final VoidCallback? onPressed;
  final ButtonType? type;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double? customWidth;
  final double? customHeight;
  final BorderType? borderType;
  final double? iconSize;
  final double? fontSize;
  final bool? hasBorder;
  final double? boderWidth;
  final String? tooltip;
  final FontWeight? fontWeight;
  final EdgeInsets? buttonTextPadding;
  final bool? isShowLoading;
  final BorderRadiusGeometry? boderRadius;
  final bool? toUpperCase;
  final bool? autoResizeText;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? iconPadding;

  static const double defaultHeight = 44.0;

  @override
  Widget build(BuildContext context) {
    double defaultWidth = MediaQuery.of(context).size.width;
    BorderRadius borderTypeRadius = borderType == BorderType.circle
        ? BorderRadius.circular(30.0)
        : borderType == BorderType.circle10
            ? BorderRadius.circular(10.0)
            : borderType == BorderType.rect20
                ? BorderRadius.circular(20.0)
                : BorderRadius.circular(6.0);

    if (type == ButtonType.outLine) {
      return SizedBox(
        width: customWidth ?? defaultWidth,
        height: customHeight ?? defaultHeight,
        child: OutlinedButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(
                backgroundColor ?? mainColorBlack),
            overlayColor: MaterialStateProperty.all<Color>(
              backgroundColor != null
                  ? Colors.white.withOpacity(.1)
                  : Colors.black.withOpacity(.1),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius:
                    boderRadius != null ? boderRadius! : borderTypeRadius,
              ),
            ),
            side: MaterialStateProperty.all<BorderSide>(
              BorderSide(
                width: boderWidth ?? 1,
                color: borderColor ?? mainColorBlack,
              ),
            ),
          ),
          onPressed: onPressed,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text(
                  text!.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: textStyle ??
                      TextStyle(
                        color: textColor ?? Colors.white,
                        fontFamily: mainFontFamily,
                        fontWeight: FontWeight.w600,
                        fontSize: fontSize ?? 12.0,
                      ),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (type == ButtonType.outLineWithIcon) {
      return SizedBox(
        width: customWidth ?? defaultWidth,
        height: customHeight ?? defaultHeight,
        child: OutlinedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              backgroundColor ?? mainColorBlack,
            ),
            overlayColor: MaterialStateProperty.all<Color>(
              backgroundColor != null
                  ? mainColorBlack.withOpacity(.1)
                  : Colors.black.withOpacity(.1),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius:
                    boderRadius != null ? boderRadius! : borderTypeRadius,
              ),
            ),
            side: MaterialStateProperty.all<BorderSide>(
              BorderSide(
                width: boderWidth ?? 2.0,
                color: borderColor ?? mainColorBlack,
              ),
            ),
          ),
          onPressed: onPressed,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: icon,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    text!,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle ??
                        TextStyle(
                          color: textColor ?? Colors.black,
                          fontFamily: mainFontFamily,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    } else if (type == ButtonType.raised) {
      return SizedBox(
        width: customWidth ?? defaultWidth,
        height: customHeight ?? defaultHeight,
        child: ElevatedButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.all(0),
            ),
            elevation: MaterialStateProperty.all<double>(3.0),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return backgroundColor != null
                      ? backgroundColor!.withOpacity(.1)
                      : Colors.black.withOpacity(.1);
                }
                return (onPressed != null)
                    ? backgroundColor ?? mainColorBlack
                    : bgColorGrey;
              },
            ),
            overlayColor: MaterialStateProperty.all<Color>(
              backgroundColor != null
                  ? Colors.white.withOpacity(.1)
                  : Colors.black.withOpacity(.1),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius:
                    boderRadius != null ? boderRadius! : borderTypeRadius,
              ),
            ),
            side: MaterialStateProperty.all<BorderSide>(
              BorderSide(
                width: boderWidth ?? 1.0,
                color: hasBorder!
                    ? borderColor ?? mainColorBlack
                    : Colors.transparent,
              ),
            ),
          ),
          onPressed: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              (isShowLoading != null && isShowLoading!)
                  ? const CupertinoActivityIndicator(radius: 15)
                  : text != ''
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: iconSize != null ? iconSize! / 3 : 2.0),
                            Text(
                              toUpperCase! ? text!.toUpperCase() : text!,
                              overflow: TextOverflow.ellipsis,
                              style: textStyle ??
                                  TextStyle(
                                    color: textColor ?? Colors.white,
                                    fontFamily: mainFontFamily,
                                    fontWeight: FontWeight.w700,
                                    fontSize: fontSize ?? 12.0,
                                  ),
                            ),
                            icon ?? SizedBox(width: iconSize ?? 5.0),
                          ],
                        )
                      : icon ?? const SizedBox(),
            ],
          ),
        ),
      );
    } else if (type == ButtonType.icon) {
      return Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          enableFeedback: false,
          padding: iconPadding ?? const EdgeInsets.all(0),
          splashColor: Colors.black.withOpacity(.1),
          splashRadius: 25.0,
          icon: icon ?? const SizedBox(),
          onPressed: onPressed,
          iconSize: iconSize ?? 30.0,
          tooltip: tooltip,
        ),
      );
    } else if (type == ButtonType.text) {
      return GestureDetector(
        onTap: onPressed,
        child: Container(
          color: Colors.transparent,
          padding: buttonTextPadding ??
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
          child: Text(
            text!,
            overflow: TextOverflow.ellipsis,
            style: textStyle ??
                TextStyle(
                  fontFamily: mainFontFamily,
                  color: background,
                  fontSize: fontSize ?? 12.0,
                  fontWeight: fontWeight,
                ),
          ),
        ),
      );
    } else if (type == ButtonType.textInString) {
      return GestureDetector(
        onTap: onPressed,
        child: Text(
          text!,
          overflow: TextOverflow.ellipsis,
          style: textStyle ??
              TextStyle(
                fontFamily: mainFontFamily,
                color: textColor ?? Colors.black,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
        ),
      );
    } else {
      return SizedBox(
        width: customWidth ?? defaultWidth,
        height: customHeight ?? defaultHeight,
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                backgroundColor ?? mainColorBlack),
            overlayColor: MaterialStateProperty.all<Color>(
                backgroundColor != null
                    ? Colors.white.withOpacity(.1)
                    : Colors.black.withOpacity(.1)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius:
                    boderRadius != null ? boderRadius! : borderTypeRadius,
              ),
            ),
            side: MaterialStateProperty.all<BorderSide>(
              BorderSide(
                width: boderWidth ?? 1.0,
                color: hasBorder!
                    ? borderColor ?? mainColorBlack
                    : Colors.transparent,
              ),
            ),
          ),
          onPressed: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              (isShowLoading != null && isShowLoading!)
                  ? const CupertinoActivityIndicator(
                      radius: 15,
                    )
                  : text != ''
                      ? autoResizeText!
                          ? FittedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      width: iconSize != null
                                          ? iconSize! / 3
                                          : 2.0),
                                  Text(
                                    toUpperCase! ? text!.toUpperCase() : text!,
                                    overflow: TextOverflow.ellipsis,
                                    style: textStyle ??
                                        TextStyle(
                                          color: textColor ?? Colors.white,
                                          fontFamily: mainFontFamily,
                                          fontWeight:
                                              fontWeight ?? FontWeight.w600,
                                          fontSize: fontSize ?? 12.0,
                                        ),
                                  ),
                                  icon ?? SizedBox(width: iconSize ?? 5.0),
                                ],
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                    width:
                                        iconSize != null ? iconSize! / 3 : 2.0),
                                Text(
                                  toUpperCase! ? text!.toUpperCase() : text!,
                                  overflow: TextOverflow.ellipsis,
                                  style: textStyle ??
                                      TextStyle(
                                        color: textColor ?? Colors.white,
                                        fontFamily: mainFontFamily,
                                        fontWeight:
                                            fontWeight ?? FontWeight.w600,
                                        fontSize: fontSize ?? 12.0,
                                      ),
                                ),
                                icon ?? SizedBox(width: iconSize ?? 5.0),
                              ],
                            )
                      : icon ?? const SizedBox(),
            ],
          ),
        ),
      );
    }
  }
}
