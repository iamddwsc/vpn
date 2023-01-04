import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nizvpn/common_widgets/loading_cupertino.dart';
import 'package:nizvpn/common_widgets/show_custom_popup.dart';
import 'package:nizvpn/ui/auth/auth_utils.dart';
import 'package:regexpattern/regexpattern.dart';
import 'package:nizvpn/common_widgets/assets_widget.dart';
import 'package:nizvpn/common_widgets/common_appbar.dart';
import 'package:nizvpn/common_widgets/custom_button.dart';
import 'package:nizvpn/constants/string_constants.dart';
import 'package:nizvpn/theme/color.dart';
import 'package:nizvpn/ui/auth/forgot_password.dart';
import 'package:nizvpn/ui/utils/global_function.dart';
import 'package:nizvpn/ui/utils/global_variable.dart';

class SignInEmail extends StatefulWidget {
  @override
  _SignInEmailState createState() => _SignInEmailState();
}

class _SignInEmailState extends State<SignInEmail> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  double btnHeight = 54;

  bool isActiveBtn = false;
  bool isShowPassword = false;
  bool isInProgressSignInEmail = false;

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
    return GestureDetector(
      onTap: unFocus,
      child: Scaffold(
        backgroundColor: isLightMode ? mainColorWhite : mainColorDark,
        resizeToAvoidBottomInset: false,
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
                  margin: const EdgeInsets.only(left: baseSpace),
                  child: imgLogoSmall,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8, right: baseSpace),
                  color: Colors.transparent,
                  child: Text(
                    strAppFullName,
                    style:
                        isLightMode ? styleAppNameSmall : styleAppNameSmallDark,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: baseSpace, vertical: baseSpace),
              color: Colors.transparent,
              child: Text(
                strLoginSuggest,
                style: isLightMode ? styleAppSuggest : styleAppSuggestDark,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(flex: 1, child: Container()),
            Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: baseSpace, vertical: baseSpace),
              color: Colors.transparent,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          strEmail,
                          style: isLightMode
                              ? styleAppSuggest
                              : styleAppSuggestDark,
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 6, bottom: baseSpace),
                      child: TextFormField(
                        controller: _emailController,
                        onChanged: (val) => onChangeEmail(),
                        validator: (value) {
                          String inputEmail = value!.trim().toLowerCase();
                          bool isEmail = inputEmail.isEmail();
                          if (!isEmail) {
                            return strInputEmailInvalid;
                          }
                          return null;
                        },
                        style: styleTextInput,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: baseSpace),
                          hintText: strEmailHint,
                          hintStyle: styleTextHintInput,
                          filled: true,
                          fillColor: neutral300,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: neutral300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: neutral300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: mainColorBlue700),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          strPassword,
                          style: isLightMode
                              ? styleAppSuggest
                              : styleAppSuggestDark,
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 6, bottom: baseSpace),
                      child: TextFormField(
                        controller: _passwordController,
                        onChanged: (val) => onChangePassword(),
                        validator: (value) {
                          String inputPassword = value!.trim();
                          bool isPassword = inputPassword.isPasswordEasy();
                          if (!isPassword) {
                            return strInputPasswordInvalid;
                          }
                          return null;
                        },
                        style: styleTextInput,
                        obscureText: !isShowPassword,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: baseSpace),
                          hintText: strPasswordHint,
                          hintStyle: styleTextHintInput,
                          suffixIcon: IconButton(
                            splashRadius: 15.0,
                            icon: Icon(
                              isShowPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: neutral900,
                            ),
                            onPressed: () {
                              unFocus();
                              isShowPassword = !isShowPassword;
                              setState(() {});
                            },
                          ),
                          filled: true,
                          fillColor: neutral300,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: neutral300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: neutral300),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: mainColorBlue700),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          child: Text(
                            strForgotPassword,
                            style:
                                isLightMode ? styleTextLink : styleTextLinkDark,
                          ),
                          onTap: () {
                            onForgotPassword();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(flex: 2, child: Container()),
            Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: baseSpace, vertical: 6),
              color: Colors.transparent,
              height: btnHeight,
              child: Stack(children: [
                CustomButton(
                  text: strSignIn,
                  onPressed: isActiveBtn ? onSignIn : null,
                  customHeight: btnHeight,
                  type: ButtonType.outLineWithIcon,
                  backgroundColor:
                      isActiveBtn ? mainColorBlue700 : colorGrey300,
                  borderType: BorderType.circle,
                  borderColor: isActiveBtn ? mainColorBlue700 : colorGrey300,
                  textStyle:
                      isActiveBtn ? styleTextBtnActive : styleTextBtnDisable,
                ),
                if (isInProgressSignInEmail) loadingCupertino(size: 20),
              ]),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: baseSpace, vertical: 18),
              color: Colors.transparent,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: strNoHaveAccount,
                      style:
                          isLightMode ? styleTextBottom : styleTextBottomDark,
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
      ),
    );
  }

  void unFocus() {
    FocusScopeNode focusNode = FocusScope.of(context);
    if (!focusNode.hasPrimaryFocus) {
      focusNode.unfocus();
    }
  }

  void onChangeEmail() {
    checkActiveBtn();
  }

  void onChangePassword() {
    checkActiveBtn();
  }

  void checkActiveBtn() {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      isActiveBtn = true;
    } else {
      isActiveBtn = false;
    }
    setState(() {});
  }

  void onForgotPassword() {
    unFocus();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ForgotPassword(),
      ),
    );
  }

  Future<void> onSignIn() async {
    if (_formKey.currentState!.validate()) {
      isInProgressSignInEmail = true;
      setState(() {});
      var res = await signInEmail(
        _emailController.text.trim().toLowerCase(),
        _passwordController.text.trim(),
      );
      isInProgressSignInEmail = false;
      setState(() {});
      
      if (res == null) {
      } else if (res is User) {
        updateUserSignIn(res);
        isSignedInEmail = true;
        saveLocalAuth();
        gobackMainScreen(context);
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
}
