import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nizvpn/ui/utils/global_function.dart';
import 'package:regexpattern/regexpattern.dart';
import 'package:nizvpn/common_widgets/common_appbar.dart';
import 'package:nizvpn/common_widgets/custom_button.dart';
import 'package:nizvpn/constants/string_constants.dart';
import 'package:nizvpn/theme/color.dart';
import 'package:nizvpn/ui/utils/global_variable.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool isActiveBtn = false;
  bool isSendCodeSuccessful = false;
  String sendCodeSuccessful = '';

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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: baseSpace, vertical: baseSpace),
                  color: Colors.transparent,
                  child: Text(
                    strForgotPasswordTitle,
                    style: isLightMode
                        ? styleTextSuccessful
                        : styleTextSuccessfulDark,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: baseSpace),
              color: Colors.transparent,
              alignment: Alignment.centerLeft,
              child: Text(
                isSendCodeSuccessful
                    ? sendCodeSuccessful
                    : strForgotPasswordContent,
                style: isLightMode ? styleAppSuggest : styleAppSuggestDark,
                textAlign: TextAlign.left,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          strEmail,
                          style: isLightMode
                              ? styleAppSuggest
                              : styleAppSuggestDark,
                        ),
                        // if (!isSendCodeSuccessful)
                        //   Text(
                        //     strEmailNoExist,
                        //     style: isLightMode
                        //         ? styleTextError
                        //         : styleTextErrorDark,
                        //   ),
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
                  ],
                ),
              ),
            ),
            Expanded(flex: 4, child: Container()),
            Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: baseSpace, vertical: 6),
              color: Colors.transparent,
              child: CustomButton(
                text: strSendCode,
                onPressed: isActiveBtn ? onSendCode : null,
                customHeight: 54,
                type: ButtonType.outLineWithIcon,
                backgroundColor: isActiveBtn ? mainColorBlue700 : colorGrey300,
                borderType: BorderType.circle,
                borderColor: isActiveBtn ? mainColorBlue700 : colorGrey300,
                textStyle:
                    isActiveBtn ? styleTextBtnActive : styleTextBtnDisable,
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

  void unFocus() {
    FocusScopeNode focusNode = FocusScope.of(context);
    if (!focusNode.hasPrimaryFocus) {
      focusNode.unfocus();
    }
  }

  void onChangeEmail() {
    if (_emailController.text.isNotEmpty && _formKey.currentState!.validate()) {
      isActiveBtn = true;
    } else {
      isActiveBtn = false;
    }
    setState(() {});
  }

  void onContactUs() {}

  void onSendCode() {
    String email = _emailController.text.trim();
    isSendCodeSuccessful = !isSendCodeSuccessful;
    if (isSendCodeSuccessful) {
      sendCodeSuccessful =
          'We’ve send code verification to your email $email, not you?';
    }
    setState(() {});
    gotoForgotPasswordSuccessful(context);
  }
}
