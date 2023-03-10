import 'dart:async';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_update/in_app_update.dart';
// import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:nizvpn/core/provider/adsProviderV2.dart';
import 'package:nizvpn/core/provider/purchaseProvider.dart';
import 'package:nizvpn/ui/auth/auth_utils.dart';
import 'package:nizvpn/ui/onboarding/onboarding_screen.dart';
import 'package:nizvpn/ui/subscription/subcription_screen.dart';
import 'package:nizvpn/theme/color.dart';
import 'package:nizvpn/ui/utils/global_variable.dart';
import 'package:provider/provider.dart';

import 'core/provider/uiProvider.dart';
import 'core/provider/vpnProvider.dart';
import 'core/resources/environment.dart';
import 'core/utils/preferences.dart';
import 'ui/screens/mainScreen.dart';
import 'ui/screens/privacyPolicyScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      name: 'com-papa-vpn',
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // await MobileAds.initialize();
    Provider.debugCheckInvalidValueType = null;
    await EasyLocalization.ensureInitialized();
    if (kDebugMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    }
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => VpnProvider()),
          // ChangeNotifierProvider(create: (context) => AdsProvider()),
          ChangeNotifierProvider(create: (context) => AdsProviderV2()),
          ChangeNotifierProvider(create: (context) => MainScreenProvider()),
          ChangeNotifierProvider(create: (context) => UIProvider()),
          ChangeNotifierProvider(create: (context) => PurchaseProvider()),
        ],
        child: Consumer<UIProvider>(
          builder: (context, value, child) => EasyLocalization(
            path: 'assets/languages',
            startLocale: value.selectedLocale ?? const Locale('en', 'US'),
            supportedLocales: value.locales!,
            useOnlyLangCode: true,
            child: Root(),
          ),
        ),
      ),
    );
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

class Root extends StatefulWidget {
  @override
  RootState createState() => RootState();
}

class RootState extends State<Root> {
  bool ready = false;
  bool checkSubscription = false;
  bool readyGetLocalAuth = false;

  @override
  void initState() {
    AppTrackingTransparency.requestTrackingAuthorization();
    if (Platform.isAndroid) {
      try {
        InAppUpdate.checkForUpdate().then((value) {
          if (value.flexibleUpdateAllowed) {
            return InAppUpdate.startFlexibleUpdate()
                .then((value) => InAppUpdate.completeFlexibleUpdate());
          }
          if (value.immediateUpdateAllowed) {
            return InAppUpdate.performImmediateUpdate();
          }
        }).onError((error, stackTrace) => null);
      } catch (e) {}
    }
    UIProvider.initializeLanguages(context);
    VpnProvider.instance(context).initialize();
    VpnProvider.refreshInfoVPN(context);
    PurchaseProvider.initPurchase(context);

    if (!ready) {
      setState(() {
        ready = true;
      });
    }

    Future.delayed(const Duration(seconds: 8)).then((value) {
      if (!ready) {
        setState(() {
          ready = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
      },
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        debugShowCheckedModeBanner: false,
        locale: context.locale,
        theme: ThemeData(
          useMaterial3: true,
          primaryColor: primaryColor,
          fontFamily: mainFontFamily,
          textTheme: TextTheme(
              // bodyText1: TextStyle(color: Colors.amber),
              bodyText2: TextStyle(color: background)),
          scaffoldBackgroundColor: Colors.white,
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
              foregroundColor: MaterialStateProperty.all(Colors.black),
              textStyle: MaterialStateProperty.all(
                  const TextStyle(color: Colors.black)),
            ),
          ),
          buttonTheme: ButtonThemeData(
            focusColor: Colors.grey.shade300,
          ),
          appBarTheme: const AppBarTheme(
            color: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        home: ready
            ? Container(
                color: Platform.isIOS ? Colors.white : Colors.black,
                child: SafeArea(
                  top: false,
                  child: FutureBuilder<Preferences>(
                    future: Preferences.init(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (!readyGetLocalAuth) {
                          readyGetLocalAuth = true;
                          getLocalAuth();
                        }
                        if (!snapshot.data!.firstOpen) {
                          return OnboardingScreen(
                            rootState: this,
                          );
                        }
                        if (snapshot.data!.privacyPolicy) {
                          if (snapshot.data!.subscribed) {
                            checkSubscription = true;
                          }
                          if (checkSubscription == false) {
                            return SubcriptionScreen(onDone: () {
                              setState(() {
                                checkSubscription = true;
                              });
                            });
                          }
                          return MainScreen();
                        } else {
                          return PrivacyPolicyIntroScreen(rootState: this);
                        }
                      } else {
                        return SplashScreen();
                      }
                    },
                  ),
                ),
              )
            : SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isLightMode ? mainColorWhite : mainColorDark,
      body: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
                text: '$appname ',
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w600)),
            TextSpan(
                text: 'VPN',
                style: GoogleFonts.poppins(
                    color: primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w600)),
          ]),
        ),
      ),
    );
  }
}
