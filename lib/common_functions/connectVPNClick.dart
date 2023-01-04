import 'dart:io';
import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vpn/flutter_vpn.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:ndialog/ndialog.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

import '../core/provider/uiProvider.dart';
import '../core/provider/vpnProvider.dart';
import '../core/utils/NizVPN.dart';
import '../core/utils/preferences.dart';
import '../features/home/presentation/home_page.dart';

void connectVPNClickGlobal(BuildContext context, VpnProvider vpnProvider,
    {List<String>? whitePackages}) async {
  if (vpnProvider.vpnStage != NVPN.vpnDisconnected &&
      (vpnProvider.vpnStage?.length ?? 0) > 0) {
    if (vpnProvider.vpnStage == NVPN.vpnConnected) {
      var resp = await NAlertDialog(
        dialogStyle: DialogStyle(
            titleDivider: true, contentPadding: const EdgeInsets.only()),
        title: Text("${"disconnect".tr()}?"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              width: 300,
              height: 250,
              // child: AdsProvider.adWidget(context,
              //     bannerId: banner2, adSize: BannerSize.MEDIUM_RECTANGLE)
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text('disconnect_question'.tr()),
            ),
          ],
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0)))),
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text('disconnect'.tr()),
          ),
          TextButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0)))),
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text('cancel'.tr()),
          ),
        ],
      ).show(context);

      // AdsProvider.instance(context).showAd2(context);
      // AdsProviderV2.instance(context).showAd(context, 2);
      if (resp ?? false) {
        NVPN.stopVpn();
        var z = await Preferences.init();
        z.saveTime(-connectionTimeTotal!.inSeconds);
      }
    } else {
      NVPN.stopVpn();
      var z = await Preferences.init();
      z.saveTime(-(connectionTimeTotal?.inSeconds ?? 0));
    }
  } else {
    if (vpnProvider.vpnConfig != null) {
      if (vpnProvider.vpnConfig!.status == 1 && !vpnProvider.isPro) {
        return VpnProvider.renewSubs(context);
      }
      if (vpnProvider.vpnConfig!.config == null &&
          vpnProvider.vpnConfig!.slug != null) {
        await CustomProgressDialog.future(
          context,
          future: vpnProvider.setConfig(context, vpnProvider.vpnConfig!.slug,
              vpnProvider.vpnConfig!.protocol),
          dismissable: false,
          loadingWidget: Center(
            child: Container(
              height: 100,
              width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: const CircularProgressIndicator(),
            ),
          ),
        );
        return connectVPNClickGlobal(context, vpnProvider,
            whitePackages: whitePackages);
      }
    } else {
      return NAlertDialog(
        title: Text('unknown_server'.tr()),
        content: Text('select_a_server'.tr()),
        actions: [
          TextButton(
            onPressed: () => UIProvider.instance(context)
                .sheetController
                .snapToPosition(const SnappingPosition.factor(
                    positionFactor: .8,
                    grabbingContentOffset: GrabbingContentOffset.bottom)),
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0)))),
            child: Text('choose_server'.tr()),
          )
        ],
      ).show(context);
    }

    Future.delayed(const Duration(seconds: 5)).then((value) async {
      if ((await Preferences.init()).shared.getBool('show_dialog') ?? false) {
        return;
      }
      if (math.Random().nextBool()) {
        NAlertDialog(
          title: Text('rating_title'.tr()),
          content: Text('rating_description'.tr()),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('rating_done'.tr())),
            TextButton(
              child: Text('rating_goto'.tr()),
              onPressed: () {
                InAppReview.instance.openStoreListing();
                Navigator.pop(context);
              },
            ),
          ],
        ).show(context).then((value) async {
          Preferences.init().then((value) {
            value.shared.setBool('show_dialog', true);
          });
        });
      }
    });

    // AdsProvider.instance(context).showAd1(context);
    // AdsProviderV2.instance(context).showAd(context, 2);
    if (vpnProvider.vpnConfig!.protocol == 'ikev2') {
      if (Platform.isAndroid) {
        await FlutterVpn.prepare();
      }
      await FlutterVpn.connectIkev2EAP(
          // name: vpnProvider.vpnConfig!.config,
          certificateString: vpnProvider.vpnConfig!.config!,
          server: vpnProvider.vpnConfig!.serverIp!,
          username: vpnProvider.vpnConfig!.username!,
          password: vpnProvider.vpnConfig!.password!);
      // FlutterVpn.disconnect();
      // vpnProvider.st

    } else {
      await NVPN.startVpn(vpnProvider.vpnConfig!,
          bypassPackages: whitePackages);
    }
  }
}
