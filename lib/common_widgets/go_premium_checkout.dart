import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nizvpn/theme/color.dart';

import 'custom_button.dart';
import 'custom_header.dart';

class GoPremiumCheckout extends StatelessWidget {
  GoPremiumCheckout({super.key});

  final TextStyle weight600 = TextStyle(
    fontWeight: FontWeight.w600,
    color: background,
  );
  final TextStyle size12 = TextStyle(
    // fontWeight: FontWeight.w600,
    fontSize: 12,
    color: gray900,
  );
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: MyCustomHeader(
            // title: 'virtual_server'.tr(),
            hasBackButton: false,
            leftWidget: const SizedBox.shrink(),
            rightImageButton: 'assets/images/close.png',
            rightButtonAction: () {
              Navigator.of(context).pop();
            },
          )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: CircleAvatar(
              backgroundColor: primaryColor,
              // foregroundColor: primaryColor,
              radius: 25,
              child: Image.asset(
                'assets/images/controller.png',
                scale: 3,
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'go_premium_checkout_desc1'.tr(),
              style: weight600,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              'go_premium_checkout_desc2'.tr(),
              style: size12,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 56,
          ),
          Text(
            'go_premium_checkout_desc3'.tr(),
            style: weight600,
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: background,
                )),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              children: [
                profitInfo(title: 'connection_speed'.tr(), desc: '4x'),
                profitInfo(title: 'virtual_locations'.tr(), desc: '116+'),
                profitInfo(title: 'linked_devices'.tr(), desc: '6'),
                profitInfo(title: 'optionzed'.tr(), isDot: true)
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CustomButton(
                    customHeight: 54,
                    text: '\$ 12,99 / Months',
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: index == 0 ? Colors.white : background),
                    backgroundColor:
                        index == 0 ? primaryColor : Colors.transparent,
                    boderRadius: BorderRadius.circular(30),
                    hasBorder: index != 0 ? true : false,
                    borderColor: index != 0 ? background : null,
                    toUpperCase: false,
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => GoPremiumCheckout())),
                  ),
                );
              },
            ),
          ),
          Text(
            '12 months at \$9.99/mo - Save 45%',
            style: size12,
          ),
          const SizedBox(
            height: 48,
          )
        ],
      ),
    ));
  }

  Padding profitInfo(
      {required String title, String? desc, bool isDot = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            title.tr(),
            style: size12,
          ),
          const Spacer(),
          isDot
              ? Container(
                  height: 8,
                  width: 8,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(5)),
                )
              : Text(
                  desc!,
                  style: size12.copyWith(
                      color: primaryColor, fontWeight: FontWeight.w700),
                )
        ],
      ),
    );
  }
}
