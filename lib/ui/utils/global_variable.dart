import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const String strEmpty = '';
const double baseSpace = 16;

bool isLightMode = true;

bool isSignedInApp = false;
bool isSignedInEmail = false;
bool isSignedInFacebook = false;
bool isSignedInGoogle = false;
bool isSignedInApple = false;

User? currentUserApp;
String currentUserUid = strEmpty;
String currentUserEmail = strEmpty;
String currentUserAvatar = strEmpty;

final layerLink = LayerLink();
