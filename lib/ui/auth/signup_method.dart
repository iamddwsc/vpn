import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nizvpn/common_widgets/assets_widget.dart';
import 'package:nizvpn/common_widgets/common_appbar.dart';
import 'package:nizvpn/common_widgets/custom_button.dart';
import 'package:nizvpn/common_widgets/loading_cupertino.dart';
import 'package:nizvpn/common_widgets/show_custom_popup.dart';
import 'package:nizvpn/constants/string_constants.dart';
import 'package:nizvpn/theme/color.dart';
import 'package:nizvpn/ui/auth/auth_utils.dart';
import 'package:nizvpn/ui/auth/signup_email.dart';
import 'package:nizvpn/ui/utils/global_function.dart';
import 'package:nizvpn/ui/utils/global_variable.dart';

class SignUpMethod extends StatefulWidget {
  @override
  _SignUpMethodState createState() => _SignUpMethodState();
}

class _SignUpMethodState extends State<SignUpMethod> {
  double btnHeight = 54;

  bool isInProgressSignUpFacebook = false;
  bool isInProgressSignUpGoogle = false;
  bool isInProgressSignUpApple = false;

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
    return Scaffold(
      backgroundColor: isLightMode ? mainColorWhite : mainColorDark,
      appBar: commonAppbar(context),
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
                child: imgLogo3x,
              ),
            ],
          ),
          Container(
            margin:
                const EdgeInsets.symmetric(horizontal: baseSpace, vertical: 6),
            color: Colors.transparent,
            child: Text(
              strAppFullName,
              style: isLightMode ? styleAppName : styleAppNameDark,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin:
                const EdgeInsets.symmetric(horizontal: baseSpace, vertical: 6),
            color: Colors.transparent,
            child: Text(
              strAppSuggest,
              style: isLightMode ? styleAppSuggest : styleAppSuggestDark,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(flex: 2, child: Container()),
          Container(
            margin:
                const EdgeInsets.symmetric(horizontal: baseSpace, vertical: 6),
            color: Colors.transparent,
            height: btnHeight,
            child: CustomButton(
              text: strSignUpEmail,
              onPressed: onSignUpEmail,
              customHeight: btnHeight,
              type: ButtonType.outLineWithIcon,
              icon: isLightMode ? iconSignInEmail : iconSignInEmailDark,
              backgroundColor: isLightMode ? mainColorWhite : mainColorDark,
              borderType: BorderType.circle,
              borderColor: isLightMode ? mainColorDark : neutral500,
              textStyle: isLightMode ? styleTextBtn : styleTextBtnDark,
            ),
          ),
          Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: baseSpace, vertical: 6),
              color: Colors.transparent,
              height: btnHeight,
              child: Stack(children: [
                CustomButton(
                  text: strSignUpFacebook,
                  onPressed: onSignUpFacebook,
                  customHeight: btnHeight,
                  type: ButtonType.outLineWithIcon,
                  icon:
                      isLightMode ? iconSignInFacebook : iconSignInFacebookDark,
                  backgroundColor: isLightMode ? mainColorWhite : mainColorDark,
                  borderType: BorderType.circle,
                  borderColor: isLightMode ? mainColorDark : neutral500,
                  textStyle: isLightMode ? styleTextBtn : styleTextBtnDark,
                ),
                if (isInProgressSignUpFacebook) loadingCupertino(size: 20),
              ])),
          Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: baseSpace, vertical: 6),
              color: Colors.transparent,
              height: btnHeight,
              child: Stack(children: [
                CustomButton(
                  text: strSignInGoogle,
                  onPressed: onSignUpGoogle,
                  customHeight: btnHeight,
                  type: ButtonType.outLineWithIcon,
                  icon: isLightMode ? iconSignInGoogle : iconSignInGoogleDark,
                  backgroundColor: isLightMode ? mainColorWhite : mainColorDark,
                  borderType: BorderType.circle,
                  borderColor: isLightMode ? mainColorDark : neutral500,
                  textStyle: isLightMode ? styleTextBtn : styleTextBtnDark,
                ),
                if (isInProgressSignUpGoogle) loadingCupertino(size: 20),
              ])),
          if (Platform.isIOS)
            Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: baseSpace, vertical: 6),
                color: Colors.transparent,
                height: btnHeight,
                child: Stack(children: [
                  CustomButton(
                    text: strSignUpApple,
                    onPressed: onSignUpApple,
                    customHeight: btnHeight,
                    type: ButtonType.outLineWithIcon,
                    icon: isLightMode ? iconSignInApple : iconSignInAppleDark,
                    backgroundColor:
                        isLightMode ? mainColorWhite : mainColorDark,
                    borderType: BorderType.circle,
                    borderColor: isLightMode ? mainColorDark : neutral500,
                    textStyle: isLightMode ? styleTextBtn : styleTextBtnDark,
                  ),
                  if (isInProgressSignUpApple) loadingCupertino(size: 20),
                ])),
          Container(
            margin:
                const EdgeInsets.symmetric(horizontal: baseSpace, vertical: 18),
            color: Colors.transparent,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: strReadyHaveAccount,
                    style: isLightMode ? styleTextBottom : styleTextBottomDark,
                  ),
                  TextSpan(
                    text: strSignIn,
                    style: isLightMode ? styleTextLink : styleTextLinkDark,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).pop();
                        gotoSignIn(context);
                      },
                  ),
                ],
              ),
            ),
          ),
          Expanded(flex: 1, child: Container()),
        ],
      ),
    );
  }

  void onSignUpEmail() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SignUpEmail(),
      ),
    );
  }

  Future<void> onSignUpFacebook() async {
    isInProgressSignUpFacebook = true;
    setState(() {});
    var res = await signInFacebook();
    isInProgressSignUpFacebook = false;
    setState(() {});

    if (res == null) {
      showCustomPopup(
        context,
        type: PopupType.red,
        content: strUserCancelSignUp,
        actionLabel: strBtnOK,
      );
    } else if (res is User) {
      gotoSignUpSuccessful(context);
    } else if (res is String) {
      showCustomPopup(
        context,
        type: PopupType.red,
        content: res,
        actionLabel: strBtnOK,
      );
    }
  }

  Future<void> onSignUpGoogle() async {
    isInProgressSignUpGoogle = true;
    setState(() {});
    var res = await signInGoogle();
    isInProgressSignUpGoogle = false;
    setState(() {});

    if (res == null) {
      showCustomPopup(
        context,
        type: PopupType.red,
        content: strUserCancelSignUp,
        actionLabel: strBtnOK,
      );
    } else if (res is User) {
      gotoSignUpSuccessful(context);
    } else if (res is String) {
      showCustomPopup(
        context,
        type: PopupType.red,
        content: res,
        actionLabel: strBtnOK,
      );
    }
  }

  Future<void> onSignUpApple() async {
    isInProgressSignUpApple = true;
    setState(() {});
    var res = await signInApple();
    isInProgressSignUpApple = false;
    setState(() {});

    if (res == null) {
      showCustomPopup(
        context,
        type: PopupType.red,
        content: strUserCancelSignUp,
        actionLabel: strBtnOK,
      );
    } else if (res is User) {
      gotoSignUpSuccessful(context);
    } else if (res is String) {
      showCustomPopup(
        context,
        type: PopupType.red,
        content: res,
        actionLabel: strBtnOK,
      );
    }
  }
}
