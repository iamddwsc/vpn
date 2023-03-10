import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vpn/flutter_vpn.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
// import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:nizvpn/common_functions/connectVPNClick.dart';
import 'package:nizvpn/ui/screens/selectVpnScreen.dart';
import 'package:provider/provider.dart';

import '../../core/provider/vpnProvider.dart';
import '../../core/resources/environment.dart';
import '../../core/resources/nerdVpnIcons.dart';
import '../../core/resources/warna.dart';
import '../../core/utils/NizVPN.dart';
import '../../theme/color.dart';
import '../components/customDivider.dart';
import '../components/customImage.dart';
import '../screens/subscriptionDetailScreen.dart';

class BerandaPage extends StatefulWidget {
  @override
  _BerandaPageState createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  @override
  void didChangeDependencies() {
    VpnProvider.refreshInfoVPN(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _customAppBarWidget(),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: _body(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ColumnDivider(space: 20),
        _topMessageWidget(),
        const ColumnDivider(space: 20),
        SizedBox(height: 200, child: _connectButtonWidget()),
        const ColumnDivider(space: 20),
        _currentLocationWidget(),
        Platform.isAndroid ? _connectionInfo() : const SizedBox(),
        const ColumnDivider(space: 90),
      ],
    );
  }

  Widget _connectionInfo() {
    return Container(
      height: 100,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Consumer<VpnProvider>(
        builder: (context, snapshot, child) {
          String byteIn = '0,0 kB - 0,0 kB/s';
          String byteOut = '0,0 kB - 0,0 kB/s';

          if (snapshot.vpnStatus != null) {
            byteIn = snapshot.vpnStatus!.byteIn!.trim().isEmpty
                ? '0,0 kB - 0,0 kB/s'
                : snapshot.vpnStatus!.byteIn!.trim();
            byteOut = snapshot.vpnStatus!.byteOut!.trim().isEmpty
                ? '0,0 kB - 0,0 kB/s'
                : snapshot.vpnStatus!.byteOut!.trim();
          }
          return Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'download'.tr(),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      byteIn,
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'upload'.tr(),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      byteOut,
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _currentLocationWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'current_location'.tr(),
            style: const TextStyle(fontSize: 12),
          ),
          const ColumnDivider(
            space: 5,
          ),
          Consumer<VpnProvider>(
            builder: (context, value, child) => SizedBox(
              height: 50,
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: grey)))),
                onPressed: _changeLocationClick,
                child: Row(
                  children: [
                    value.vpnConfig?.flag == null
                        ? const SizedBox.shrink()
                        : SizedBox(
                            height: 30,
                            width: 30,
                            child: (value.vpnConfig!.flag!
                                    .toLowerCase()
                                    .startsWith('http')
                                ? CustomImage(
                                    url: value.vpnConfig!.flag,
                                    fit: BoxFit.scaleDown,
                                  )
                                : Image.asset(
                                    'assets/icons/flags/${value.vpnConfig!.flag}.png',
                                    height: 30,
                                    width: 30,
                                  )),
                          ),
                    const RowDivider(),
                    Expanded(
                        child:
                            Text(value.vpnConfig?.name ?? 'Select server...')),
                    Consumer<VpnProvider>(
                      builder: (context, value, child) =>
                          Text(value.vpnConfig?.protocol?.toUpperCase() ?? ''),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _connectButtonWidget() {
    return Consumer<VpnProvider>(
      builder: (context, value, child) {
        Color buttonColor = greyLittleWhite;
        // Color focusColor = greyLittleWhite;

        String stage = (value.vpnStage ?? NVPN.vpnDisconnected).toLowerCase();
        if (stage == NVPN.vpnConnected.toLowerCase()) {
          buttonColor = primaryColor;
        } else if (stage != NVPN.vpnDisconnected.toLowerCase() || stage == '') {
          buttonColor = Colors.orange;
        } else {
          buttonColor = greyLittleWhite;
        }
        return Center(
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black.withOpacity(.1),
                ),
              ],
              shape: BoxShape.circle,
            ),
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(buttonColor),
                shape: MaterialStateProperty.all(const CircleBorder()),
              ),
              onPressed: () => connectVPNClickGlobal(
                  context, value), //_connectVPNClick(value),
              child: const Icon(
                NerdVPNIcon.power,
                size: 130,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _topMessageWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Consumer<VpnProvider>(
        builder: (context, value, child) {
          String tulisan = 'unprotected'.tr();
          Color color = Colors.red;

          String stage = (value.vpnStage ?? NVPN.vpnDisconnected).toLowerCase();
          if (stage == NVPN.vpnConnected.toLowerCase()) {
            tulisan = 'protected'.tr();
            color = Colors.green;
          } else if (stage != NVPN.vpnDisconnected.toLowerCase()) {
            tulisan = value.vpnStage!.replaceAll('_', ' ');
            color = Colors.orange;
          } else {
            tulisan = 'unprotected'.tr();
            color = Colors.red;
          }
          return GestureDetector(
            onTap: () => FlutterVpn.disconnect(),
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: "${"welcome".tr()},\n",
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                TextSpan(
                    text: "${"your_connection".tr()} ",
                    style:
                        GoogleFonts.poppins(fontSize: 15, color: Colors.black)),
                TextSpan(
                    text: tulisan.toUpperCase(),
                    style: GoogleFonts.poppins(fontSize: 15, color: color)),
              ]),
            ),
          );
        },
      ),
    );
  }

  Widget _customAppBarWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                  text: '$appname ',
                  style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600)),
              TextSpan(
                  text: 'VPN',
                  style: GoogleFonts.poppins(
                      color: primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600)),
            ]),
          ),
          Consumer<VpnProvider>(
            builder: (context, value, child) {
              if (value.isPro) {
                return Positioned(
                  right: 0,
                  child: CupertinoButton(
                    padding: const EdgeInsets.only(),
                    onPressed: () {},
                    child: Row(
                      children: [
                        LottieBuilder.asset(
                          'assets/animations/crown.json',
                          height: 50,
                          width: 50,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Positioned(
                right: 0,
                child: CupertinoButton(
                  padding: const EdgeInsets.only(),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SubscriptionDetailScreen()));
                  },
                  child: Row(
                    children: [
                      LottieBuilder.asset(
                        'assets/animations/crown_grey.json',
                        height: 50,
                        width: 50,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  // void _connectVPNClick(VpnProvider vpnProvider) async {
  //   if (vpnProvider.vpnStage != NVPN.vpnDisconnected &&
  //       (vpnProvider.vpnStage?.length ?? 0) > 0) {
  //     if (vpnProvider.vpnStage == NVPN.vpnConnected) {
  //       var resp = await NAlertDialog(
  //         dialogStyle: DialogStyle(
  //             titleDivider: true, contentPadding: const EdgeInsets.only()),
  //         title: Text("${"disconnect".tr()}?"),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: [
  //             const SizedBox(
  //               width: 300,
  //               height: 250,
  //               // child: AdsProvider.adWidget(context,
  //               //     bannerId: banner2, adSize: BannerSize.MEDIUM_RECTANGLE)
  //             ),
  //             Padding(
  //               padding:
  //                   const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
  //               child: Text('disconnect_question'.tr()),
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             style: ButtonStyle(
  //                 shape: MaterialStateProperty.all(RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(0)))),
  //             onPressed: () {
  //               Navigator.pop(context, true);
  //             },
  //             child: Text('disconnect'.tr()),
  //           ),
  //           TextButton(
  //             style: ButtonStyle(
  //                 shape: MaterialStateProperty.all(RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(0)))),
  //             onPressed: () {
  //               Navigator.pop(context, false);
  //             },
  //             child: Text('cancel'.tr()),
  //           ),
  //         ],
  //       ).show(context);

  //       // AdsProvider.instance(context).showAd2(context);
  //       // AdsProviderV2.instance(context).showAd(context, 2);
  //       if (resp != null && resp as bool) {
  //         NVPN.stopVpn();
  //       }
  //     } else {
  //       NVPN.stopVpn();
  //     }
  //   } else {
  //     if (vpnProvider.vpnConfig != null) {
  //       if (vpnProvider.vpnConfig!.status == 1 && !vpnProvider.isPro) {
  //         return VpnProvider.renewSubs(context);
  //       }
  //       if (vpnProvider.vpnConfig!.config == null &&
  //           vpnProvider.vpnConfig!.slug != null) {
  //         await CustomProgressDialog.future(
  //           context,
  //           future: vpnProvider.setConfig(context, vpnProvider.vpnConfig!.slug,
  //               vpnProvider.vpnConfig!.protocol),
  //           dismissable: false,
  //           loadingWidget: Center(
  //             child: Container(
  //               height: 100,
  //               width: 100,
  //               alignment: Alignment.center,
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(20),
  //               ),
  //               child: const CircularProgressIndicator(),
  //             ),
  //           ),
  //         );
  //         return _connectVPNClick(vpnProvider);
  //       }
  //     } else {
  //       return NAlertDialog(
  //         title: Text('unknown_server'.tr()),
  //         content: Text('select_a_server'.tr()),
  //         actions: [
  //           TextButton(
  //             onPressed: () => UIProvider.instance(context)
  //                 .sheetController
  //                 .snapToPosition(const SnappingPosition.factor(
  //                     positionFactor: .8,
  //                     grabbingContentOffset: GrabbingContentOffset.bottom)),
  //             style: ButtonStyle(
  //                 shape: MaterialStateProperty.all(RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(0)))),
  //             child: Text('choose_server'.tr()),
  //           )
  //         ],
  //       ).show(context);
  //     }

  //     Future.delayed(const Duration(seconds: 5)).then((value) async {
  //       if ((await Preferences.init()).shared.getBool('show_dialog') ?? false) {
  //         return;
  //       }
  //       if (Random().nextBool()) {
  //         NAlertDialog(
  //           title: Text('rating_title'.tr()),
  //           content: Text('rating_description'.tr()),
  //           actions: [
  //             TextButton(
  //                 onPressed: () => Navigator.pop(context),
  //                 child: Text('rating_done'.tr())),
  //             TextButton(
  //               child: Text('rating_goto'.tr()),
  //               onPressed: () {
  //                 InAppReview.instance.openStoreListing();
  //                 Navigator.pop(context);
  //               },
  //             ),
  //           ],
  //         ).show(context).then((value) async {
  //           Preferences.init().then((value) {
  //             value.shared.setBool('show_dialog', true);
  //           });
  //         });
  //       }
  //     });

  //     // AdsProvider.instance(context).showAd1(context);
  //     // AdsProviderV2.instance(context).showAd(context, 2);
  //     await NVPN.startVpn(vpnProvider.vpnConfig!);
  //   }
  // }

  final ScrollController _scrollController = ScrollController();
  void _changeLocationClick() async {
    // UIProvider.instance(context).sheetController.snapToPosition(
    //     const SnappingPosition.factor(
    //         positionFactor: .8,
    //         grabbingContentOffset: GrabbingContentOffset.bottom));
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          Material(child: SelectVpnScreen(scrollController: _scrollController)),
    ));
  }
}
