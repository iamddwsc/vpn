import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nizvpn/common_widgets/custom_button.dart';
import 'package:nizvpn/features/setting/common_widget/setting_selection.dart';
import 'package:nizvpn/features/setting/presentation/server_list.dart';
import 'package:nizvpn/theme/color.dart';

import '../../../common_widgets/custom_header.dart';

class SettingAutoConnect extends StatefulWidget {
  const SettingAutoConnect({super.key});

  @override
  State<SettingAutoConnect> createState() => _SettingAutoConnectState();
}

class _SettingAutoConnectState extends State<SettingAutoConnect> {
  int _selected = 4;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: MyCustomHeader(
            title: 'auto_connect'.tr(),
            // leftWidget: const SizedBox.shrink(),
            // rightWidget: const SizedBox.shrink(),
          )),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingSelection(
              type: 'auto_connect_opt1'.tr(),
              value: 1,
              groupValue: _selected,
              onTap: () {
                setState(() {
                  _selected = 1;
                });
              },
            ),
            SettingSelection(
              type: 'auto_connect_opt2'.tr(),
              value: 2,
              groupValue: _selected,
              onTap: () {
                setState(() {
                  _selected = 2;
                });
              },
            ),
            SettingSelection(
              type: 'auto_connect_opt3'.tr(),
              value: 3,
              groupValue: _selected,
              onTap: () {
                setState(() {
                  _selected = 3;
                });
              },
            ),
            SettingSelection(
              type: 'off'.tr(),
              value: 4,
              groupValue: _selected,
              onTap: () {
                setState(() {
                  _selected = 4;
                });
              },
            ),
            const SizedBox(
              height: 32,
            ),
            Text(
              'auto_connect_to'.tr(),
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: background),
            ),
            const SizedBox(
              height: 8,
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ServerList()));
              },
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'auto'.tr(),
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: background),
                      ),
                      const Text(
                        'recommended',
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                  const Spacer(),
                  CustomButton(
                    type: ButtonType.icon,
                    icon: Image.asset(
                      'assets/images/right_arrow3x.png',
                      scale: 3,
                      color: neutral900,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
