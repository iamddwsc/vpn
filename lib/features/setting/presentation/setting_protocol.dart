import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../common_widgets/custom_header.dart';
import '../common_widget/setting_selection.dart';

class SettingProtocol extends StatefulWidget {
  const SettingProtocol({super.key});

  @override
  State<SettingProtocol> createState() => _SettingProtocolState();
}

class _SettingProtocolState extends State<SettingProtocol> {
  int _selected = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: MyCustomHeader(
            title: 'protocol'.tr(),
            // leftWidget: const SizedBox.shrink(),
            // rightWidget: const SizedBox.shrink(),
          )),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
        child: Column(
          children: [
            SettingSelection(
              type: 'recommended'.tr(),
              value: 1,
              groupValue: _selected,
              onTap: () {
                setState(() {
                  _selected = 1;
                });
              },
            ),
            SettingSelection(
              type: 'IEK v2',
              value: 2,
              groupValue: _selected,
              onTap: () {
                setState(() {
                  _selected = 2;
                });
              },
            ),
            SettingSelection(
              type: 'OpenVPN (TCP)',
              value: 3,
              groupValue: _selected,
              onTap: () {
                setState(() {
                  _selected = 3;
                });
              },
            ),
            SettingSelection(
              type: 'OpenVPN (UDP)',
              value: 4,
              groupValue: _selected,
              onTap: () {
                setState(() {
                  _selected = 4;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
