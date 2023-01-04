import 'dart:async';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:ndialog/ndialog.dart';
import 'package:nizvpn/common_functions/connectVPNClick.dart';
import 'package:nizvpn/features/home/presentation/no_time_left.dart';
import 'package:nizvpn/features/setting/presentation/server_list.dart';
import 'package:nizvpn/features/home/presentation/countdown_timer.dart';
import 'package:nizvpn/features/home/utils/int_to_time.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

// import '/constants/string_constants.dart';

import '../../../common_widgets/custom_button.dart';
import '../../../common_widgets/custom_header.dart';
import '../../../constants/string_constants.dart';
import '../../../core/provider/uiProvider.dart';
import '../../../core/provider/vpnProvider.dart';
import '../../../core/resources/environment.dart';
import '../../../core/utils/NizVPN.dart';
import '../../../core/utils/preferences.dart';
import '../../../theme/color.dart';
import 'peak_speed_widget.dart';
import 'rate_widget.dart';
import 'secured_data_widget.dart';
import 'server_information_widget.dart';

Duration? connectionTimeTotal;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void didChangeDependencies() {
    VpnProvider.refreshInfoVPN(context);
    super.didChangeDependencies();
  }

  TextStyle measureTextStyle = TextStyle(fontSize: 10, color: background);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: MyCustomHeader(
            hasBackButton: false,
            title: '$appname $plan',
            rightTextButton: 'help'.tr(),
          ),
        ),
        body: Consumer<VpnProvider>(builder: (context, snapshot, child) {
          return Column(children: [
            CountDownTimer(
                onCompleted: () => NVPN.stopVpn(),
                onUpdate: (duration) {
                  setState(() {
                    connectionTimeTotal = duration;
                  });
                },
                isConnected: snapshot.isConnected!),
            Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: snapshot.isConnected!
                            ? double.infinity
                            : constraints.maxHeight),
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 1200),
                      curve: Curves.linearToEaseOut,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FutureBuilder<Preferences>(
                            future: Preferences.init(),
                            builder: (context, snap) {
                              return ActionWidget(
                                action: () {
                                  if (snap.data!.remainingTimeUse > 0) {
                                    // _connectVPNClick(
                                    //     snapshot, snap.data!.whitePackages);
                                    connectVPNClickGlobal(context, snapshot,
                                        whitePackages:
                                            snap.data!.whitePackages);
                                  } else {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                NoTimeLeftScreen(
                                                  addMoreTime: () {
                                                    snap.data!.saveTime(900);
                                                    Navigator.of(context).pop();
                                                  },
                                                )));
                                  }
                                },
                                du: connectionTimeTotal ??
                                    const Duration(seconds: 0),
                              );
                            },
                          ),
                          if (snapshot.isConnected!)
                            SpeedMeasurementWidget(
                                measureTextStyle: measureTextStyle),
                          if (snapshot.isConnected!) const RatingWidget(),
                          const GoPremiumWidget(),
                          const ServerHomeWidget(),
                          if (snapshot.isConnected!) ...[
                            const PeakSpeedWidget(),
                            const ServerInformationWidget(),
                            const SecuredDataWidget()
                          ]
                        ],
                      ),
                    ),
                  ),
                );
              }),
            )
          ]);
        }));
  }

  void _connectVPNClick(
      VpnProvider vpnProvider, List<String> whitePackages) async {
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
        if (resp != null && resp as bool) {
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
          return _connectVPNClick(vpnProvider, whitePackages);
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
      NVPN.startVpn(vpnProvider.vpnConfig!, bypassPackages: whitePackages);
    }
  }
}

class GoPremiumWidget extends StatelessWidget {
  const GoPremiumWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      // padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 48,
              width: 48,
              decoration:
                  BoxDecoration(color: secondaryColor, shape: BoxShape.circle),
              // margin: EdgeInsets.symmetric(vertical: 12),
              child: Image.asset(
                'assets/images/home/crown3x.png',
                scale: 3,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'go_premium'.tr(),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: gray50),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  RichText(
                      text: const TextSpan(
                          text:
                              'Free 7 days of MasterVPN. No ads & faster speeds. Pay \$ 0 to day. ',
                          style: TextStyle(fontSize: 10),
                          children: [
                        TextSpan(
                            text: 'Start free trial',
                            style: TextStyle(fontWeight: FontWeight.w700))
                      ]))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServerHomeWidget extends StatelessWidget {
  const ServerHomeWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<VpnProvider>(
      builder: (context, value, _) => GestureDetector(
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const ServerList())),
        child: Container(
          height: 58,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          // padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: neutral300,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              top: 8,
              bottom: 8,
            ),
            child: Row(
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 32,
                  width: 32,
                  decoration: const BoxDecoration(
                      color: primaryColor, shape: BoxShape.circle),
                  // margin: EdgeInsets.symmetric(vertical: 12),
                  child: Image.asset(
                    'assets/images/home/starship3x.png',
                    scale: 3,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            'auto'.tr(),
                            style: TextStyle(
                                fontWeight: FontWeight.w700, color: background),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Container(
                            height: 18,
                            width: 43,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: neutral500),
                            child: Center(
                                child: Text(
                              'basic'.tr(),
                              style: TextStyle(fontSize: 8, color: shadeWhite0),
                            )),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          Text(
                            'limited_speed'.tr(),
                            style: TextStyle(fontSize: 10, color: background),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            'get_premium'.tr(),
                            style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: primaryColor),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                CustomButton(
                  type: ButtonType.icon,
                  icon: Image.asset(
                    'assets/images/right_arrow3x.png',
                    scale: 3,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ActionWidget extends StatelessWidget {
  const ActionWidget({Key? key, required this.action, required this.du})
      : super(key: key);

  final VoidCallback action;
  final Duration du;

  @override
  Widget build(BuildContext context) {
    return Consumer<VpnProvider>(builder: (context, value, _) {
      String stage = (value.vpnStage ?? NVPN.vpnDisconnected).toLowerCase();
      String tulisan = 'unprotected'.tr();
      bool connected = false;
      String buttonIcon = 'assets/images/home/switch3x.png';
      if (stage == NVPN.vpnConnected.toLowerCase()) {
        buttonIcon = 'assets/images/home/connected3x.png';
        tulisan = 'connected'.tr();
        connected = true;
      } else if (stage != NVPN.vpnDisconnected.toLowerCase() || stage == '') {
        tulisan = value.vpnStage!.replaceAll('_', ' ');
        buttonIcon = 'assets/images/home/connected3x.png';
      } else {
        tulisan = 'unprotected'.tr();
        buttonIcon = 'assets/images/home/switch3x.png';
      }

      return Expanded(
        flex: connected ? 0 : 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<VpnProvider>(
              builder: (context, value, child) {
                var flag = value.vpnConfig!.flag!;
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ServerList())),
                  child: value.vpnConfig != null
                      ? Padding(
                          padding:
                              EdgeInsets.only(top: value.isConnected! ? 16 : 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 24,
                                width: 24,
                                // margin: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: primaryColor),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: flag.endsWith('.png') ||
                                          flag.endsWith('jpg')
                                      ? CachedNetworkImage(
                                          imageUrl: flag,
                                          fit: BoxFit.fill,
                                        )
                                      : SvgPicture.network(
                                          flag,
                                          fit: BoxFit.fill,
                                        ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                value.vpnConfig!.name!,
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: 8),
                              Image.asset('assets/images/right_arrow.png')
                            ],
                          ),
                        )
                      : Row(
                          children: [
                            const Text(
                              'Select server',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 8),
                            Image.asset('assets/images/right_arrow.png')
                          ],
                        ),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: action,
              child: Center(
                child: connected
                    ? Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Image.asset(
                          buttonIcon,
                          scale: 3,
                        ),
                      )
                    : Container(
                        height: 140,
                        width: 140,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: neutral100),
                        child: Image.asset(
                          buttonIcon,
                          scale: 3,
                        ),
                      ),
              ),
            ),
            if (connected)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  tulisan,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            if (connected)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  du.toTimePadHour(),
                  style: TextStyle(color: secondaryColor, fontSize: 12),
                ),
              ),
          ],
        ),
      );
    });
  }
}

class SpeedMeasurementWidget extends StatelessWidget {
  const SpeedMeasurementWidget({
    Key? key,
    required this.measureTextStyle,
  }) : super(key: key);

  final TextStyle measureTextStyle;

  @override
  Widget build(BuildContext context) {
    return Consumer<VpnProvider>(
      builder: (context, snapshot, child) {
        String byteIn = '0,0 kB/s';
        String byteOut = '0,0 kB/s';
        String bIn = '';
        String bOut = '';

        if (snapshot.vpnStatus != null) {
          bIn = snapshot.vpnStatus!.byteIn!.trim();
          byteIn =
              bIn.isEmpty ? '0,0 kB/s' : bIn.substring(bIn.indexOf('-') + 2);
          bOut = snapshot.vpnStatus!.byteOut!.trim();
          byteOut =
              bOut.isEmpty ? '0,0 kB/s' : bOut.substring(bOut.indexOf('-') + 2);
        }
        return Container(
          height: 60,
          decoration: BoxDecoration(
              color: neutral300, borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.fromLTRB(32, 0, 32, 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/home/download3x.png',
                scale: 3,
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Download',
                    style: measureTextStyle,
                  ),
                  Text.rich(TextSpan(
                      text: byteIn.substring(0, byteIn.indexOf(' ')),
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: background),
                      children: [
                        TextSpan(
                            text: byteIn.substring(
                              byteIn.indexOf(' '),
                            ),
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w400))
                      ])),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: VerticalDivider(
                  color: neutral500.withOpacity(0.25),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Ping',
                    style: measureTextStyle,
                  ),
                  Text.rich(TextSpan(
                      text: '0',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: background),
                      children: const [
                        TextSpan(
                            text: ' ms',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w400))
                      ])),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: VerticalDivider(
                  color: neutral500.withOpacity(0.25),
                ),
              ),
              Image.asset(
                'assets/images/home/upload3x.png',
                scale: 3,
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Upload',
                    style: measureTextStyle,
                  ),
                  Text.rich(TextSpan(
                      text: byteOut.substring(0, byteOut.indexOf(' ')),
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: background),
                      children: [
                        TextSpan(
                            text: byteOut.substring(
                              byteOut.indexOf(' '),
                            ),
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w400))
                      ])),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

// class HomeHeader extends StatelessWidget {
//   const HomeHeader({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         SizedBox(
//           width: 63,
//           height: 49,
//           child: Image.asset(
//             'assets/images/home/giftbox3x.png',
//             scale: 3,
//           ),
//         ),
//         Expanded(
//           child: Center(
//             child: Text(
//               '$appname $plan',
//               style: TextStyle(
//                   fontSize: 16, fontWeight: FontWeight.w700, color: background),
//             ),
//           ),
//         ),
//         CustomButton(
//           type: ButtonType.text,
//           text: 'help'.tr(),
//           buttonTextPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//           textStyle: TextStyle(
//               color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
//           toUpperCase: false,
//         )
//       ],
//     );
//   }
// }
