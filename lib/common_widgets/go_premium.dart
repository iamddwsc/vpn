import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nizvpn/common_widgets/go_premium_checkout.dart';

import '../theme/color.dart';
import 'custom_button.dart';

class GoPremiumScreen extends StatelessWidget {
  const GoPremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // var z = 'premium_term_privacy'.tr();
    // print(z.toString());
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: LayoutBuilder(
                builder: (p0, p1) {
                  if (p1.maxHeight < 700) {
                    return const SingleChildScrollView(
                      child: GoPremiumReponsiveWidget(isLongScreen: false),
                    );
                  } else {
                    return const GoPremiumReponsiveWidget(isLongScreen: true);
                  }
                },
              ),
            ),
            Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Image.asset(
                    'assets/images/close.png',
                    scale: 3,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class GoPremiumReponsiveWidget extends StatelessWidget {
  const GoPremiumReponsiveWidget({super.key, required this.isLongScreen});

  final bool isLongScreen;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: isLongScreen ? MainAxisSize.max : MainAxisSize.min,
      children: [
        if (isLongScreen) const Spacer(),
        Padding(
          padding: EdgeInsets.fromLTRB(68, isLongScreen ? 36 : 24, 68, 0),
          child: Image.asset('assets/images/premium/go_premium.png'),
        ),
        const SizedBox(
          height: 47,
        ),
        Text(
          'go_premium_free7d'.tr(),
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.w600, color: primaryColor),
        ),
        const SizedBox(
          height: 14,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 39),
            child: Text(
              'go_premium_desc1'.tr(),
              textAlign: TextAlign.center,
            )),
        const SizedBox(
          height: 36,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomButton(
              customHeight: 54,
              text: 'continue'.tr(),
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w700, color: Colors.white),
              backgroundColor: primaryColor,
              boderRadius: BorderRadius.circular(30),
              toUpperCase: false,
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GoPremiumCheckout()));
              },
            )),
        const SizedBox(
          height: 12,
        ),
        Text(
          'go_premium_desc2'.tr(),
          style: TextStyle(fontSize: 10, color: gray900),
        ),
        const SizedBox(
          height: 22,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text.rich(
            style: TextStyle(
              fontSize: 10,
              color: gray800,
            ),
            TextSpan(
                text: 'go_premium_term_privacy'.tr(gender: '0'),
                children: [
                  TextSpan(
                      text: 'go_premium_term_privacy'.tr(gender: '1'),
                      style: const TextStyle(
                          color: primaryColor,
                          decoration: TextDecoration.underline)),
                  TextSpan(
                    text: 'go_premium_term_privacy'.tr(gender: '2'),
                  ),
                  TextSpan(
                      text: 'go_premium_term_privacy'.tr(gender: '3'),
                      style: const TextStyle(
                          color: primaryColor,
                          decoration: TextDecoration.underline)),
                  TextSpan(
                    text: 'go_premium_term_privacy'.tr(gender: '4'),
                  ),
                  TextSpan(
                      text: 'go_premium_term_privacy'.tr(gender: '5'),
                      style: const TextStyle(
                          color: primaryColor,
                          decoration: TextDecoration.underline)),
                  TextSpan(
                    text: 'go_premium_term_privacy'.tr(gender: '6'),
                  )
                ]),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }
}
