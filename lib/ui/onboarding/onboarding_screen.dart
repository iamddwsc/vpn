import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:nizvpn/common_widgets/common_appbar.dart';
import 'package:nizvpn/ui/onboarding/introduction_screen.dart';
import 'package:nizvpn/ui/onboarding/model/page_decoration.dart';
import 'package:nizvpn/ui/onboarding/model/position.dart';
import 'package:nizvpn/theme/color.dart';
import 'package:nizvpn/ui/utils/global_variable.dart';

import '../../core/utils/preferences.dart';
import '../../main.dart';
import 'model/page_view_model.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key, this.rootState});

  final RootState? rootState;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: isLightMode ? mainColorWhite : mainColorDark,
      appBar: commonAppbar(context, noBack: true),
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            image: Image.asset(
              'assets/images/splash/onboarding1.png',
            ),
            titleWidget: const Text(
              'Secure browsing\nwith no limits',
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            bodyWidget: const Text(
              'Speed up browsing with more than +120\n locations privately and securely',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            decoration: PageDecoration(
                // imagePadding: EdgeInsets.all(24 * height / 852),
                // bodyAlignment: Alignment.center,
                // imageAlignment: Alignment.center,
                contentMargin: EdgeInsets.all(16 * height / 852),
                titlePadding: EdgeInsets.only(bottom: 24 * height / 852)),
          ),
          PageViewModel(
            image: Image.asset('assets/images/splash/onboarding2.png'),
            titleWidget: const Text(
              'Super fasting\nstreaming',
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            bodyWidget: const Text(
              'Stream and game online with maximum speed and more security',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            decoration: PageDecoration(
                // imagePadding: EdgeInsets.all(24 * height / 852),
                // bodyAlignment: Alignment.center,
                // imageAlignment: Alignment.center,
                contentMargin: EdgeInsets.all(16 * height / 852),
                titlePadding: EdgeInsets.only(bottom: 24 * height / 852)),
          ),
          PageViewModel(
            image: Image.asset('assets/images/splash/onboarding3.png'),
            titleWidget: const Text(
              'Block malware\nand phising',
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            bodyWidget: const Text(
              'Protect your phone, block maximum malware and phishing',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            decoration: PageDecoration(
                // imagePadding: EdgeInsets.all(24 * height / 852),
                // bodyAlignment: Alignment.center,
                // imageAlignment: Alignment.center,
                contentMargin: EdgeInsets.all(16 * height / 852),
                titlePadding: EdgeInsets.only(bottom: 24 * height / 852)),
          ),
          PageViewModel(
              image: Image.asset('assets/images/splash/onboarding4.png'),
              titleWidget: const Text('Keep your data\nsafety',
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center),
              bodyWidget: const Text(
                'Keep your data safe and completely secure from malware',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              decoration: PageDecoration(
                  // imagePadding: EdgeInsets.all(24 * height / 852),
                  // bodyAlignment: Alignment.center,
                  // imageAlignment: Alignment.center,
                  contentMargin: EdgeInsets.all(16 * height / 852),
                  titlePadding: EdgeInsets.only(bottom: 24 * height / 852)))
        ],
        // showSkipButton: true,
        onDone: () {
          Preferences.init().then((value) {
            // ignore: invalid_use_of_protected_member
            rootState!.setState(() {
              value.saveFirstOpen();
            });
          });
        },
        next: const Text('Next',
            style: TextStyle(fontSize: 20, color: Colors.black)),
        skip: const Text('',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        showNextButton: false,
        done: const Text('Done',
            style: TextStyle(fontSize: 20, color: Colors.black)),
        customPositionSkipBtn: const Position(top: 0, right: 0),
        dotsDecorator: DotsDecorator(
            activeSize: const Size.square(6),
            size: const Size.square(6),
            activeColor: primaryColor,
            color: indicatorInActiveColor),
      ),
    );
  }
}
