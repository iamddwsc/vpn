import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nizvpn/core/utils/preferences.dart';
import 'package:nizvpn/features/setting/common_widget/setting_selection.dart';

import '../../../common_widgets/custom_header.dart';

class SettingAppearance extends StatefulWidget {
  const SettingAppearance({super.key});

  @override
  State<SettingAppearance> createState() => _SettingAppearanceState();
}

class _SettingAppearanceState extends State<SettingAppearance> {
  int? _selected;

  @override
  void initState() {
    super.initState();
    _getSetting();
  }

  void _getSetting() async {
    _selected = (await Preferences.init()).appearance;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        top: Platform.isAndroid ? true : false,
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size(double.infinity, kToolbarHeight),
              child: MyCustomHeader(
                title: 'appearance'.tr(),
              )),
          body: Builder(builder: (context) {
            if (_selected == null) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                children: [
                  SettingSelection(
                      type: 'light'.tr(),
                      value: 0,
                      groupValue: _selected!,
                      onTap: () {
                        setState(() {
                          _selected = 0;
                        });
                      }),
                  SettingSelection(
                      type: 'dark'.tr(),
                      value: 1,
                      groupValue: _selected!,
                      onTap: () {
                        setState(() {
                          _selected = 1;
                        });
                      })
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
