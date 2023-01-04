import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nizvpn/ui/components/customChart.dart';

import '../../../theme/color.dart';

class SecuredDataWidget extends StatelessWidget {
  const SecuredDataWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.fromLTRB(16, 25, 16, 0),
      decoration: BoxDecoration(
          color: neutral300, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'secured_data'.tr(),
                style:
                    TextStyle(fontWeight: FontWeight.w700, color: background),
              ),
              Image.asset(
                'assets/images/home/info3x.png',
                scale: 3,
                color: neutral900,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Text.rich(TextSpan(
                  text: '96.8 MB',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700),
                  children: [
                    TextSpan(
                        text: 'secured_data_total'.tr(),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400))
                  ]))),
          const BarChartSample6(),
          const SizedBox(
            height: 16,
          ),
          const SecuredDataMeasurement(
              types: ['downloaded', 'uploaded'], values: [83.1, 13.7]),
        ],
      ),
    );
  }
}

enum SecuredDataEnum { downloaded, uploaded }

class SecuredDataMeasurement extends StatelessWidget {
  const SecuredDataMeasurement(
      {super.key, required this.types, required this.values});

  final List<String> types;
  final List<double> values;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width -
        64 -
        50; // 64 is total margin + padding, 50 is blank sizedbox
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/home/download3x.png',
                scale: 3,
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                'downloaded'.tr(),
                style: const TextStyle(fontSize: 12),
              ),
              const Spacer(),
              Text(
                '${values[0]} MB',
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              )
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                curve: Curves.fastLinearToSlowEaseIn,
                width: values[0] > values[1]
                    ? width
                    : values[0] * width / values[1],
                height: 5,
                decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(30)),
              ),
              const SizedBox(
                width: 50,
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          // uploaded
          Row(
            children: [
              Image.asset(
                'assets/images/home/upload3x.png',
                scale: 3,
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                'uploaded'.tr(),
                style: const TextStyle(fontSize: 12),
              ),
              const Spacer(),
              Text(
                '${values[1]} MB',
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              )
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                curve: Curves.fastLinearToSlowEaseIn,
                width: values[1] > values[0]
                    ? width
                    : values[1] * width / values[0],
                height: 5,
                decoration: BoxDecoration(
                    color: stateError, borderRadius: BorderRadius.circular(30)),
              ),
              const SizedBox(
                width: 50,
              )
            ],
          ),
        ],
      ),
    );
  }
}
