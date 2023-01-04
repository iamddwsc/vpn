import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../common_widgets/custom_button.dart';
import '../../../common_widgets/signal_level.dart';
import '../../../theme/color.dart';

class PeakSpeedWidget extends StatelessWidget {
  const PeakSpeedWidget({
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
                'peak_speed'.tr(),
                style:
                    TextStyle(fontWeight: FontWeight.w700, color: background),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'peak_speed_des'.tr(),
            style: TextStyle(fontSize: 12, color: gray800),
          ),
          const SizedBox(
            height: 20,
          ),
          SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(minimum: 0, maximum: 5, ranges: <GaugeRange>[
                GaugeRange(
                    startValue: 0,
                    endValue: 3,
                    color: primaryColor,
                    startWidth: 10,
                    endWidth: 10),
              ], annotations: const [
                GaugeAnnotation(
                    widget: Text(
                      '3.0',
                      style: TextStyle(fontSize: 28, color: primaryColor),
                    ),
                    angle: 90,
                    positionFactor: 0.5),
              ], pointers: const <GaugePointer>[
                NeedlePointer(
                  value: 3,
                  enableAnimation: true,
                  needleStartWidth: 0,
                  needleEndWidth: 2,
                  needleColor: Color(0xFFDADADA),
                  knobStyle: KnobStyle(
                      color: Colors.white,
                      borderColor: Color(0xFFDADADA),
                      knobRadius: 0.06,
                      borderWidth: 0.04),
                  tailStyle: TailStyle(
                    color: Color(0xFFDADADA),
                    width: 2,
                    length: 0.15,
                  ),
                  animationDuration: 5000,
                ),
                RangePointer(
                  value: 3,
                  width: 2,
                  enableAnimation: true,
                  color: primaryColor500,
                  animationDuration: 5000,
                )
              ])
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          const SignalMeasurement(
            type: 'streaming',
            level: 1,
          ),
          const SignalMeasurement(
            type: 'browsing',
            level: 3,
          ),
          const SignalMeasurement(
            type: 'gaming',
            level: 2,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            child: Divider(
              color: neutral500.withOpacity(0.5),
            ),
          ),
          Row(
            children: [
              CustomButton(
                type: ButtonType.text,
                text: 'peak_premium_notice'.tr(),
                textStyle: const TextStyle(
                    color: primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
                buttonTextPadding: const EdgeInsets.all(0),
              ),
              const Spacer(),
              Container(
                height: 20,
                width: 20,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: primaryColor),
                padding:
                    const EdgeInsets.symmetric(horizontal: 7.5, vertical: 5.85),
                child: Image.asset(
                  'assets/images/right_arrow3x.png',
                  color: Colors.white,
                  scale: 3,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}

class SignalMeasurement extends StatelessWidget {
  const SignalMeasurement({Key? key, required this.type, required this.level})
      : super(key: key);

  final int level;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(type.tr()),
          const Spacer(),
          Text(
            (level == 1
                    ? 'poor'
                    : level == 2
                        ? 'average'
                        : 'excellent')
                .tr(),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            width: 16,
          ),
          SignalLevel(level: level),
        ],
      ),
    );
  }
}
