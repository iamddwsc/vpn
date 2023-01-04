import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nizvpn/common_widgets/custom_button.dart';

import '../../../theme/color.dart';

class ServerInformationWidget extends StatelessWidget {
  const ServerInformationWidget({
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
                'server_information'.tr(),
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
            child: Text(
              'server_information_des'.tr(),
              style: TextStyle(fontSize: 12, color: gray800),
            ),
          ),
          const SizedBox(
            height: 22,
          ),
          ServerMeasurement(
            type: 'server_information_load'.tr(),
            status: '69%',
          ),
          ServerMeasurement(
            type: 'server_information_latency'.tr(),
            status: '5 ms',
          ),
          ServerMeasurement(
            type: 'server_information_ip'.tr(),
            status: '123.123.123.1',
          ),
          ServerMeasurement(
            type: 'server_information_type'.tr(),
            status: 'Upgrade Basic',
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Text(
                'weak_connection'.tr(),
                style: const TextStyle(fontSize: 12),
              ),
              const Text(' '),
              CustomButton(
                type: ButtonType.text,
                buttonTextPadding: const EdgeInsets.all(0),
                text: 'report_issue'.tr(),
                textStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline),
                onPressed: () {
                  debugPrint('===== Report issue');
                },
              )
            ],
          ),
          const SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }
}

class ServerMeasurement extends StatelessWidget {
  const ServerMeasurement({Key? key, required this.type, required this.status})
      : super(key: key);

  final String type;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            type,
          ),
          const Spacer(),
          Text(
            status,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
