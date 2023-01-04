import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nizvpn/core/utils/preferences.dart';
import 'package:nizvpn/ui/utils/global_variable.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

bool isInProgressSignOutApp = false;

Future<dynamic> signInGoogle() async {
  User? user;
  try {
    final googleSignIn = GoogleSignIn();
    final isSignedIn = await googleSignIn.isSignedIn();
    if (isSignedIn) {
      debugPrint('===== signInGoogle signOut');
      await googleSignIn.signOut();
    }
    final googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final authCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(authCredential);
      user = userCredential.user;
    } else {
      debugPrint('===== signInGoogle cancel');
    }
  } catch (e) {
    debugPrint('===== signInGoogle ERR $e');
    return getErrorMessage(e);
  }
  debugPrint('===== signInGoogle $user');
  return user;
}

Future<dynamic> signInApple() async {
  User? user;
  try {
    final authorizationCredentialAppleID =
        await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    final oAuthProvider = OAuthProvider('apple.com');
    final authCredential = oAuthProvider.credential(
      idToken: authorizationCredentialAppleID.identityToken,
      accessToken: authorizationCredentialAppleID.authorizationCode,
    );
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(authCredential);
    user = userCredential.user;
  } catch (e) {
    debugPrint('===== signInApple ERR $e');
    return getErrorMessage(e);
  }
  debugPrint('===== signInApple $user');
  return user;
}

Future<dynamic> signInFacebook() async {
  User? user;
  String? errMessage;
  try {
    final loginResult =
        await FacebookAuth.instance.login(permissions: ['email']);
    switch (loginResult.status) {
      case LoginStatus.success:
        final credential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);
        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        user = userCredential.user;
        break;
      case LoginStatus.cancelled:
        errMessage = loginResult.message;
        break;
      case LoginStatus.failed:
        errMessage = loginResult.message;
        break;
      case LoginStatus.operationInProgress:
        errMessage = loginResult.message;
        break;
    }
    if (errMessage != null) {
      return errMessage;
    }
  } catch (e) {
    debugPrint('===== signInFacebook ERR $e');
    return getErrorMessage(e);
  }
  debugPrint('===== signInFacebook $user');
  return user;
}

Future<dynamic> signInEmail(String email, String password) async {
  User? user;
  try {
    final userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    user = userCredential.user;
  } catch (e) {
    debugPrint('===== signInEmail ERR $e');
    return getErrorMessage(e);
  }
  debugPrint('===== signInEmail $user');
  return user;
}

Future<dynamic> signUpEmail(String email, String password) async {
  User? user;
  try {
    final userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    user = userCredential.user;
  } catch (e) {
    debugPrint('===== signUpEmail ERR $e');
    return getErrorMessage(e);
  }
  debugPrint('===== signUpEmail $user');
  return user;
}

Future<void> signOutApp() async {
  try {
    await FirebaseAuth.instance.signOut().whenComplete(() {
      isInProgressSignOutApp = false;
      saveLocalAuth(isSignOut: true);
    });
  } catch (e) {
    isInProgressSignOutApp = false;
  }
}

Future<void> saveLocalAuth({bool isSignOut = false}) async {
  debugPrint('===== saveLocalAuth');
  if (isSignOut) {
    isSignedInApp = false;
    isSignedInEmail = false;
    isSignedInApple = false;
    isSignedInGoogle = false;
    isSignedInApple = false;
    currentUserUid = strEmpty;
    currentUserEmail = strEmpty;
    currentUserAvatar = strEmpty;
  } else {
    isSignedInApp = true;
  }
  var localStore = await Preferences.init();
  localStore.saveAuth(isSignedInApp);
  localStore.saveUserUid(currentUserUid);
  localStore.saveUserEmail(currentUserEmail);
  localStore.saveUserAvatar(currentUserAvatar);
}

Future<void> getLocalAuth() async {
  debugPrint('===== getLocalAuth');
  var localStore = await Preferences.init();
  isSignedInApp = localStore.isAuth;
  var uId = localStore.getUserUid;
  if (uId != null) {
    currentUserUid = uId;
  }
  var email = localStore.getUserEmail;
  if (email != null) {
    currentUserEmail = email;
  }
  var url = localStore.getUserAvatar;
  if (url != null) {
    currentUserAvatar = url;
  }
  debugPrint('===== isSignedInApp $isSignedInApp');
  debugPrint('===== currentUserEmail $currentUserEmail');
}

void updateUserSignIn(User user) {
  currentUserApp = user;
  currentUserUid = user.uid;
  currentUserEmail = user.email ?? currentUserEmail;
  currentUserAvatar = user.photoURL ?? currentUserAvatar;
}

String getErrorMessage(dynamic error) {
  String err = strEmpty;
  if (error is FirebaseAuthException) {
    if (error.plugin == 'firebase_auth') {
      err = error.code;
      // err = error.message!;
    }
  } else if (error is SignInWithAppleAuthorizationException) {
    err = error.message;
  } else if (error is MissingPluginException) {
    err = error.message!;
  }
  return err;
}
