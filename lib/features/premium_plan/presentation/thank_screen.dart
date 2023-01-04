import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nizvpn/theme/color.dart';

import '../../../common_widgets/custom_header.dart';

class ThankScreen extends StatelessWidget {
  const ThankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const TextStyle size12 = TextStyle(fontSize: 12);
    return SafeArea(
      child: Scaffold(
        appBar: const PreferredSize(
            preferredSize: Size(double.infinity, kToolbarHeight),
            child: MyCustomHeader(
              title: 'MasterVPN Premium',
              hasBackButton: false,
              leftWidget: SizedBox.shrink(),
              rightWidget: SizedBox.shrink(),
            )),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                'thank_title'.tr(),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 7,
              ),
              Text(
                'thank_desc1'.tr(),
                style: size12,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 4,
              ),
              Text.rich(TextSpan(
                  text: '( ${'exprixy'.tr()}: ',
                  style: size12,
                  children: const [
                    TextSpan(
                        text: '365 days )',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: primaryColor))
                  ])),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  descItem(size12, 2),
                  descItem(size12, 3),
                  descItem(size12, 4),
                  descItem(size12, 5),
                ],
              ),
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }

  Padding descItem(TextStyle size12, int localizationIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/premium/done_icon3x.png',
            scale: 3,
            color: secondaryColor,
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            'thank_desc$localizationIndex'.tr(),
            style: size12,
          )
        ],
      ),
    );
  }
}
