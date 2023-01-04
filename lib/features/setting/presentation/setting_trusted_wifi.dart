import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../common_widgets/custom_button.dart';
import '../../../common_widgets/custom_header.dart';
import '../../../core/utils/preferences.dart';
import '../../../theme/color.dart';

class SettingTrustedWifi extends StatefulWidget {
  const SettingTrustedWifi({super.key});

  @override
  State<SettingTrustedWifi> createState() => _SettingTrustedWifiState();
}

class _SettingTrustedWifiState extends State<SettingTrustedWifi> {
  // String wifiName = '';
  List<String> listTrustedWifi = [];
  List<String> listWifi = [];
  final _keyAllApps = GlobalKey<AnimatedListState>();
  final _keyTrustedApps = GlobalKey<AnimatedListState>();
  bool renderFlag = true;

  @override
  void initState() {
    super.initState();

    _getWifiInfo();
  }

  void _getWifiInfo() async {
    if (Platform.isAndroid) {
      var status = await Permission.location.status;
      if (status.isPermanentlyDenied ||
          status.isDenied ||
          status.isRestricted) {
        if (await Permission.location.request().isGranted) {
          // Either the permission was already granted before or the user just granted it.
        }
      }
      var p = await Preferences.init();
      listTrustedWifi = p.trustedWifi;
      final info = NetworkInfo();
      var wifiName = (await info.getWifiName())?.replaceAll('"', '');
      if (!listWifi.contains(wifiName) && !listTrustedWifi.contains(wifiName)) {
        listWifi.insert(0, wifiName ?? '');
      }
      setState(() {
        renderFlag = false;
      });
    }
  }

  void _addItem(String wifiName, GlobalKey<AnimatedListState> key) async {
    var p = await Preferences.init();
    if (key == _keyAllApps) {
      listWifi.insert(0, wifiName);
      p.saveListTrustedWifi(p.trustedWifi..remove(wifiName));
    } else {
      listTrustedWifi.insert(0, wifiName);

      p.saveListTrustedWifi(p.trustedWifi..add(wifiName));
    }
    key.currentState!
        .insertItem(0, duration: const Duration(milliseconds: 500));
  }

  void _removeItem(int index, GlobalKey<AnimatedListState> key) {
    String w;
    if (key == _keyAllApps) {
      w = listWifi[index];
      listWifi.removeAt(index);
    } else {
      w = listTrustedWifi[index];
      listTrustedWifi.removeAt(index);
    }
    if (listTrustedWifi.isEmpty) {
      setState(() {});
    }
    key.currentState!.removeItem(
        index,
        (context, animation) => AppListItem(
              wifiName: w,
              onTap: () {},
              animation: animation,
            ),
        duration: const Duration(milliseconds: 500));
    _addItem(w, key == _keyAllApps ? _keyTrustedApps : _keyAllApps);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
      preferredSize: const Size(double.infinity, kToolbarHeight),
      child: MyCustomHeader(
        title: 'trusted_wifi'.tr(),
        // rightImageButton: 'assets/images/search_icon3x.png',
        // rightButtonAction: () {
        //   print('right button action');
        // },
      )),
      body: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Builder(builder: (context) {
        if (renderFlag) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'trusted_wifi_desc'.tr(),
              style: const TextStyle(fontSize: 12),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 500),
              child: SizedBox(
                height: listTrustedWifi.isEmpty ? 16 : 0,
              ),
            ),
            AnimatedList(
              key: _keyTrustedApps,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              initialItemCount: listTrustedWifi.length,
              itemBuilder: (context, index, animation) {
                if (listTrustedWifi.isEmpty) return const SizedBox.shrink();
                return AppListItem(
                    wifiName: listTrustedWifi[index],
                    onTap: () => _removeItem(index, _keyTrustedApps),
                    animation: animation,
                    isWhiteApp: true);
              },
            ),
            Text(
              'add_networks'.tr(),
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600),
            ),
            // const SizedBox(
            //   height: 8,
            // ),
            AnimatedList(
              shrinkWrap: true,
              key: _keyAllApps,
              physics: const NeverScrollableScrollPhysics(),
              initialItemCount: listWifi.length,
              itemBuilder: (context, index, animation) {
                return AppListItem(
                    onTap: () => _removeItem(index, _keyAllApps),
                    animation: animation,
                    wifiName: listWifi[index]);
              },
            )
          ],
        );
      }),
    ),
      ),
    );
  }
}

class AppListItem extends StatelessWidget {
  const AppListItem(
      {Key? key,
      required this.onTap,
      required this.animation,
      this.isWhiteApp = false,
      required this.wifiName})
      : super(key: key);

  final String wifiName;
  final VoidCallback onTap;
  final Animation<double> animation;
  final bool isWhiteApp;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      child: buildWidget(),
    );
  }

  Row buildWidget() {
    return Row(
      children: [
        Container(
            height: 22,
            width: 22,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(200),
              child: Image.asset(
                'assets/images/setting/wifi_icon3x.png',
                scale: 3,
              ),
            )),
        const SizedBox(
          width: 8,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              wifiName,
              style: TextStyle(fontWeight: FontWeight.w600, color: background),
            ),
          ],
        ),
        const Spacer(),
        CustomButton(
          type: ButtonType.icon,
          icon: Image.asset(
            isWhiteApp
                ? 'assets/images/setting/remove_3x.png'
                : 'assets/images/setting/add_3x.png',
            scale: 3,
          ),
          onPressed: onTap,
        )
      ],
    );
  }
}
