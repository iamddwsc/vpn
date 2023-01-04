import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../core/resources/environment.dart';
import '../../core/utils/preferences.dart';
import '../../main.dart';
import '../onboarding/introduction_screen.dart';
import '../onboarding/model/page_view_model.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key, @required this.rootState}) : super(key: key);
  final RootState? rootState;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              image: LottieBuilder.asset('assets/animations/1.json'),
              title: 'Welcome to $appname VPN',
              body:
                  "I will take you around to see what's so exciting about $appname VPN",
            ),
            PageViewModel(
              image: LottieBuilder.asset('assets/animations/2.json'),
              title: 'Privacy Protection',
              body: "Internet access is mind-free, we'll keep you safe",
            ),
            PageViewModel(
              image: LottieBuilder.asset('assets/animations/3.json'),
              title: 'Fast and Limitless!',
              body: 'We provide you the fastest servers without limits',
            ),
          ],
          showSkipButton: true,
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
          skip: const Text('Skip',
              style: TextStyle(fontSize: 20, color: Colors.black)),
          showNextButton: true,
          done: const Text('Done',
              style: TextStyle(fontSize: 20, color: Colors.black)),
        ),
      ),
    );
  }
}
