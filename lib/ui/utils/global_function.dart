import 'package:flutter/material.dart';
import 'package:nizvpn/ui/auth/forgot_password_successful.dart';
import 'package:nizvpn/ui/auth/signin_method.dart';
import 'package:nizvpn/ui/auth/signup_method.dart';
import 'package:nizvpn/ui/auth/signup_successful.dart';

double dynamicSize(double num, double baseNum, {double? factor}) {
  return num < 750 ? baseNum : baseNum * num / (factor ?? 750);
}

void gobackMainScreen(BuildContext context) {
  Navigator.popUntil(context, ModalRoute.withName('/'));
}

Future<void> gotoSignIn(BuildContext context) async {
  await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => SignInMethod(),
    ),
  );
}

void gotoSignUp(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => SignUpMethod(),
    ),
  );
}

void gotoSignUpSuccessful(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => SignUpSuccessful(),
    ),
  );
}

void gotoForgotPasswordSuccessful(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ForgotPasswordSuccessful(),
    ),
  );
}
