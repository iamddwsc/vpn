import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nizvpn/common_widgets/custom_button.dart';
import 'package:nizvpn/common_widgets/go_premium.dart';
import 'package:nizvpn/theme/color.dart';

class NoTimeLeftScreen extends StatelessWidget {
  const NoTimeLeftScreen({super.key, required this.addMoreTime});

  final VoidCallback addMoreTime;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: LayoutBuilder(
                builder: (p0, p1) {
                  if (p1.maxHeight < 700) {
                    return SingleChildScrollView(
                      child: NoTimeReponsiveWidget(
                          addMoreTime: addMoreTime, isLongScreen: false),
                    );
                  } else {
                    return NoTimeReponsiveWidget(
                        addMoreTime: addMoreTime, isLongScreen: true);
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

class NoTimeReponsiveWidget extends StatelessWidget {
  const NoTimeReponsiveWidget(
      {super.key, required this.addMoreTime, required this.isLongScreen});

  final VoidCallback addMoreTime;
  final bool isLongScreen;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // const Spacer(),
        if (isLongScreen) const Spacer(),
        Padding(
          padding: EdgeInsets.fromLTRB(68, isLongScreen ? 36 : 24, 68, 0),
          child: Image.asset(
            'assets/images/home/no_time_left.png',
            fit: BoxFit.fitWidth,
          ),
        ),
        SizedBox(
          height: isLongScreen ? 47 : 36,
        ),
        Text(
          'no_connected_time'.tr(),
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.w600, color: primaryColor),
        ),
        const SizedBox(
          height: 14,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 39),
            child: Text(
              'no_connected_time_desc'.tr(),
              textAlign: TextAlign.center,
            )),
        // const Spacer(),
        if (isLongScreen)
          const Spacer()
        else
          const SizedBox(
            height: 18,
          ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomButton(
              customHeight: 54,
              text: 'watch_ad'.tr(),
              textStyle:
                  TextStyle(fontWeight: FontWeight.w700, color: background),
              backgroundColor: Colors.transparent,
              boderRadius: BorderRadius.circular(30),
              borderColor: background,
              hasBorder: true,
              toUpperCase: false,
              onPressed: addMoreTime,
            )),
        const SizedBox(
          height: 16,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomButton(
              customHeight: 54,
              text: 'get_premium'.tr(),
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w700, color: Colors.white),
              backgroundColor: primaryColor,
              boderRadius: BorderRadius.circular(30),
              toUpperCase: false,
              onPressed: (() => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const GoPremiumScreen()))),
            )),
        const SizedBox(
          height: 32,
        )
        // GestureDetector(
        //     onTap: addMoreTime,
        //     child: const SizedBox(
        //         height: 50, width: 50, child: Text('add more')))
      ],
    );
  }
}
