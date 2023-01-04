import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nizvpn/features/setting/presentation/setting_appearance.dart';
import 'package:nizvpn/features/setting/presentation/setting_auto_connect.dart';
import 'package:nizvpn/features/setting/presentation/setting_dns.dart';
import 'package:nizvpn/features/setting/presentation/setting_protocol.dart';
import 'package:nizvpn/features/setting/presentation/setting_split_tunneling.dart';
import 'package:nizvpn/features/setting/presentation/setting_trusted_wifi.dart';
import 'package:nizvpn/theme/color.dart';

import '../../../common_widgets/custom_header.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size(double.infinity, kToolbarHeight),
          child: MyCustomHeader(
            title: 'Settings',
            hasBackButton: false,
            leftWidget: SizedBox.shrink(),
            rightWidget: SizedBox.shrink(),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'VPN connection',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 12, 12),
                    decoration: BoxDecoration(
                        color: neutral300,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SettingItem(
                          title: 'auto_connect'.tr(),
                          desc: 'off'.tr(),
                          onTap: () => _autoConnect(context),
                        ),
                        SettingItem(
                          title: 'protocol'.tr(),
                          desc: 'recommended'.tr(),
                          onTap: () => _protocol(context),
                        ),
                        SettingItem(
                          title: 'split_tunneling'.tr(),
                          desc: 'split_tunneling_desc'.tr(),
                          onTap: () => _splitTunneling(context),
                        ),
                        SettingItem(
                          title: 'trusted_wifi'.tr(),
                          desc: 'trusted_wifi_desc'.tr(),
                          onTap: () => _trustedWifi(context),
                        ),
                        SettingItem(
                          title: 'dns'.tr(),
                          desc: 'default'.tr(),
                          hasDivider: false,
                          onTap: () => _dns(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Text(
                    'Tools',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 0, 12),
                    decoration: BoxDecoration(
                        color: neutral300,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SettingItem(
                          title: 'thread_protection'.tr(),
                          desc: 'thread_protection_desc'.tr(),
                          hasToggle: true,
                          toggleAction: () {},
                          addDividerRightPadding: true,
                        ),
                        SettingItem(
                          title: 'malicious_warning'.tr(),
                          desc: 'malicious_warning_desc'.tr(),
                          hasToggle: true,
                          toggleAction: () {},
                          hasDivider: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Text(
                    'General',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 0, 12),
                    decoration: BoxDecoration(
                        color: neutral300,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SettingItem(
                          title: 'appearance'.tr(),
                          desc: 'dark'.tr(),
                          addDividerRightPadding: true,
                          onTap: () => _appearance(context),
                        ),
                        SettingItem(
                          title: 'help_us'.tr(),
                          desc: 'help_us_desc'.tr(),
                          hasToggle: true,
                          toggleAction: () {},
                          addDividerRightPadding: true,
                        ),
                        SettingItem(
                          title: 'app_version'.tr(),
                          desc: '2.0.1 ${'app_version_desc'.tr()}',
                          hasDivider: false,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _autoConnect(BuildContext context) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const SettingAutoConnect()));
  }

  void _protocol(BuildContext context) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const SettingProtocol()));
  }

  void _splitTunneling(BuildContext context) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const SettingSplitTunneling()));
  }

  void _trustedWifi(BuildContext context) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const SettingTrustedWifi()));
  }

  void _dns(BuildContext context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SettingDNS()));
  }

  void _appearance(BuildContext context) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const SettingAppearance()));
  }
}

class SettingItem extends StatefulWidget {
  const SettingItem({
    Key? key,
    required this.title,
    required this.desc,
    this.hasToggle = false,
    this.toggleAction,
    this.onTap,
    this.toggleValue = false,
    this.hasDivider = true,
    this.addDividerRightPadding = false,
  })  : assert(!(toggleAction == null && hasToggle == true),
            'Need to set toggleAction if hasToggle is true'),
        super(key: key);

  final String title;
  final String desc;
  final bool hasToggle;
  final VoidCallback? toggleAction;
  final VoidCallback? onTap;
  final bool toggleValue;
  final bool hasDivider;
  final bool addDividerRightPadding;

  @override
  State<SettingItem> createState() => _SettingItemState();
}

class _SettingItemState extends State<SettingItem> {
  bool toggleValue = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: widget.onTap ?? () {},
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                          color: background,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      widget.desc,
                      style: TextStyle(fontSize: 12, color: gray800),
                    ),
                    //
                  ],
                ),
              ),
              if (widget.hasToggle) ...[
                // const Spacer(),
                Switch(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  thumbColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return primaryColor;
                    }
                    return neutral900;
                  }),
                  // activeTrackColor: neutral500,
                  trackColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return neutral500;
                  }),
                  value: toggleValue,
                  onChanged: (value) {
                    if (value) {
                      widget.toggleAction!();
                    }
                    setState(() {
                      toggleValue = value;
                    });
                  },
                )
              ]
            ],
          ),
        ),
        if (widget.hasDivider)
          Padding(
            padding: EdgeInsets.only(
                top: 4,
                bottom: 8,
                right: widget.addDividerRightPadding ? 12 : 0),
            child: Divider(
              color: neutral500,
            ),
          )
      ],
    );
  }
}
