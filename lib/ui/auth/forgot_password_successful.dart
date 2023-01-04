import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nizvpn/common_widgets/assets_widget.dart';
import 'package:nizvpn/common_widgets/common_appbar.dart';
import 'package:nizvpn/common_widgets/custom_button.dart';
import 'package:nizvpn/constants/string_constants.dart';
import 'package:nizvpn/theme/color.dart';
import 'package:nizvpn/ui/utils/global_function.dart';
import 'package:nizvpn/ui/utils/global_variable.dart';

class ForgotPasswordSuccessful extends StatefulWidget {
  @override
  _ForgotPasswordSuccessfulState createState() =>
      _ForgotPasswordSuccessfulState();
}

class _ForgotPasswordSuccessfulState extends State<ForgotPasswordSuccessful> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: isLightMode ? mainColorWhite : mainColorDark,
        appBar: commonAppbar(context, noBack: true),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 1, child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: baseSpace, vertical: 6),
                  child: imgForgotPasswordSuccessful,
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(
                  left: baseSpace, right: baseSpace, top: 32),
              color: Colors.transparent,
              child: Text(
                strThankyou,
                style:
                    isLightMode ? styleTextSuccessful : styleTextSuccessfulDark,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: baseSpace, vertical: 14),
              color: Colors.transparent,
              child: Text(
                strSendMailLink,
                style: isLightMode ? styleAppSuggest : styleAppSuggestDark,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(flex: 3, child: Container()),
            Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: baseSpace, vertical: 6),
              color: Colors.transparent,
              child: CustomButton(
                text: strSignIn,
                onPressed: () {
                  gobackMainScreen(context);
                  gotoSignIn(context);
                },
                customHeight: 54,
                type: ButtonType.outLineWithIcon,
                backgroundColor: mainColorBlue700,
                borderType: BorderType.circle,
                borderColor: mainColorBlue700,
                textStyle: styleTextBtnActive,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: baseSpace, vertical: 18),
              color: Colors.transparent,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: strHaveProblem,
                      style:
                          isLightMode ? styleTextBottom : styleTextBottomDark,
                    ),
                    TextSpan(
                      text: strContactUs,
                      style: isLightMode ? styleTextLink : styleTextLinkDark,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => onContactUs(),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(flex: 1, child: Container()),
          ],
        ),
      ),
    );
  }

  void onContactUs() {}
}
