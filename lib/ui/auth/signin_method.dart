import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nizvpn/common_widgets/show_custom_popup.dart';
import 'package:nizvpn/ui/auth/auth_utils.dart';
import 'package:nizvpn/common_widgets/assets_widget.dart';
import 'package:nizvpn/common_widgets/common_appbar.dart';
import 'package:nizvpn/common_widgets/custom_button.dart';
import 'package:nizvpn/common_widgets/loading_cupertino.dart';
import 'package:nizvpn/constants/string_constants.dart';
import 'package:nizvpn/theme/color.dart';
import 'package:nizvpn/ui/auth/signin_email.dart';
import 'package:nizvpn/ui/utils/global_function.dart';
import 'package:nizvpn/ui/utils/global_variable.dart';

class SignInMethod extends StatefulWidget {
  @override
  _SignInMethodState createState() => _SignInMethodState();
}

class _SignInMethodState extends State<SignInMethod> {
  double btnHeight = 54;

  bool isInProgressSignInFacebook = false;
  bool isInProgressSignInGoogle = false;
  bool isInProgressSignInApple = false;

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
              text: strSignInEmail,
              onPressed: onSignInEmail,
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
            margin:
                const EdgeInsets.symmetric(horizontal: baseSpace, vertical: 6),
            color: Colors.transparent,
            height: btnHeight,
            child: Stack(children: [
              CustomButton(
                text: strSignInFacebook,
                onPressed: onSignInFacebook,
                customHeight: btnHeight,
                type: ButtonType.outLineWithIcon,
                icon: isLightMode ? iconSignInFacebook : iconSignInFacebookDark,
                backgroundColor: isLightMode ? mainColorWhite : mainColorDark,
                borderType: BorderType.circle,
                borderColor: isLightMode ? mainColorDark : neutral500,
                textStyle: isLightMode ? styleTextBtn : styleTextBtnDark,
              ),
              if (isInProgressSignInFacebook) loadingCupertino(size: 20),
            ]),
          ),
          Container(
            margin:
                const EdgeInsets.symmetric(horizontal: baseSpace, vertical: 6),
            color: Colors.transparent,
            height: btnHeight,
            child: Stack(children: [
              CustomButton(
                text: strSignInGoogle,
                onPressed: onSignInGoogle,
                customHeight: btnHeight,
                type: ButtonType.outLineWithIcon,
                icon: isLightMode ? iconSignInGoogle : iconSignInGoogleDark,
                backgroundColor: isLightMode ? mainColorWhite : mainColorDark,
                borderType: BorderType.circle,
                borderColor: isLightMode ? mainColorDark : neutral500,
                textStyle: isLightMode ? styleTextBtn : styleTextBtnDark,
              ),
              if (isInProgressSignInGoogle) loadingCupertino(size: 20),
            ]),
          ),
          if (Platform.isIOS)
            Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: baseSpace, vertical: 6),
              color: Colors.transparent,
              height: btnHeight,
              child: Stack(children: [
                CustomButton(
                  text: strSignInApple,
                  onPressed: onSignInApple,
                  customHeight: btnHeight,
                  type: ButtonType.outLineWithIcon,
                  icon: isLightMode ? iconSignInApple : iconSignInAppleDark,
                  backgroundColor: isLightMode ? mainColorWhite : mainColorDark,
                  borderType: BorderType.circle,
                  borderColor: isLightMode ? mainColorDark : neutral500,
                  textStyle: isLightMode ? styleTextBtn : styleTextBtnDark,
                ),
                if (isInProgressSignInApple) loadingCupertino(size: 20),
              ]),
            ),
          Container(
            margin:
                const EdgeInsets.symmetric(horizontal: baseSpace, vertical: 18),
            color: Colors.transparent,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: strNoHaveAccount,
                    style: isLightMode ? styleTextBottom : styleTextBottomDark,
                  ),
                  TextSpan(
                    text: strSignUp,
                    style: isLightMode ? styleTextLink : styleTextLinkDark,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).pop();
                        gotoSignUp(context);
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

  void onSignInEmail() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SignInEmail(),
      ),
    );
  }

  Future<void> onSignInFacebook() async {
    isInProgressSignInFacebook = true;
    setState(() {});
    var res = await signInFacebook();
    isInProgressSignInFacebook = false;
    setState(() {});

    if (res == null) {
      showCustomPopup(
        context,
        type: PopupType.red,
        content: strUserCancelSignIn,
        actionLabel: strBtnOK,
      );
    } else if (res is User) {
      updateUserSignIn(res);
      isSignedInFacebook = true;
      saveLocalAuth();
      Navigator.of(context).pop();
    } else if (res is String) {
      showCustomPopup(
        context,
        type: PopupType.red,
        content: res,
        actionLabel: strBtnOK,
      );
    }
  }

  Future<void> onSignInGoogle() async {
    isInProgressSignInGoogle = true;
    setState(() {});
    var res = await signInGoogle();
    isInProgressSignInGoogle = false;
    setState(() {});

    if (res == null) {
      showCustomPopup(
        context,
        type: PopupType.red,
        content: strUserCancelSignIn,
        actionLabel: strBtnOK,
      );
    } else if (res is User) {
      updateUserSignIn(res);
      isSignedInGoogle = true;
      saveLocalAuth();
      Navigator.of(context).pop();
    } else if (res is String) {
      showCustomPopup(
        context,
        type: PopupType.red,
        content: res,
        actionLabel: strBtnOK,
      );
    }
  }

  Future<void> onSignInApple() async {
    isInProgressSignInApple = true;
    setState(() {});
    var res = await signInApple();
    isInProgressSignInApple = false;
    setState(() {});

    if (res == null) {
      showCustomPopup(
        context,
        type: PopupType.red,
        content: strUserCancelSignIn,
        actionLabel: strBtnOK,
      );
    } else if (res is User) {
      updateUserSignIn(res);
      isSignedInApple = true;
      saveLocalAuth();
      Navigator.of(context).pop();
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
