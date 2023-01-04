import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../../core/resources/environment.dart';
import '../../core/utils/NizVPN.dart';
import '../../theme/color.dart';
import '../components/customDivider.dart';

class KillSwitchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('setting_killswitch'.tr()),
        leading: IconButton(
          icon: const Icon(LineIcons.angleLeft),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        children: [
          Text(
            'killswitch_title'.tr(),
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const ColumnDivider(space: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("1. ${"killswitch_step1".tr()}"),
                const ColumnDivider(),
                Text(
                    "2. ${"killswitch_step2".tr().replaceAll("\$appname", appname)}"),
                const ColumnDivider(),
                Text("3. ${"killswitch_step3".tr()}"),
                const ColumnDivider(space: 15),
                TextButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        const StadiumBorder(),
                      ),
                      backgroundColor: MaterialStateProperty.all(primaryColor)),
                  onPressed: NVPN.openKillSwitch,
                  child: Text(
                    'killswitch_opensetting'.tr(),
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          const ColumnDivider(),
          Text(
            'killswitch_note'.tr(),
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          )
        ],
      ),
      // bottomNavigationBar: AdsProvider.adbottomSpace(),
    );
  }
}
