import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ndialog/ndialog.dart';
import 'package:nizvpn/common_widgets/assets_widget.dart';
import 'package:nizvpn/common_widgets/common_appbar.dart';
import 'package:nizvpn/common_widgets/custom_button.dart';
import 'package:nizvpn/common_widgets/custom_expansiontile.dart';
import 'package:nizvpn/core/https/vpnServerHttp.dart';
import 'package:nizvpn/core/models/vpnConfig.dart';
import 'package:nizvpn/core/utils/NizVPN.dart';
import 'package:nizvpn/features/setting/domain/server_model.dart';
import 'package:nizvpn/features/setting/presentation/connecting.dart';
import 'package:nizvpn/theme/color.dart';
import 'package:nizvpn/ui/screens/subscriptionDetailScreen.dart';
import 'package:nizvpn/ui/utils/global_variable.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../core/models/vpnServer.dart';
import '../../../core/provider/vpnProvider.dart';
import '../../../core/resources/environment.dart';
import '../../../core/utils/preferences.dart';
import '../../home/presentation/home_page.dart';

class ServerList extends StatefulWidget {
  const ServerList({super.key});

  @override
  State<ServerList> createState() => _ServerListState();
}

class _ServerListState extends State<ServerList> {
  int _value = 0;
  List<VpnServer> listItemOpenVPN = [];
  bool _ready = false;
  RefreshController refreshController = RefreshController(initialRefresh: true);
  ScrollController scrollController = ScrollController();

  dynamic specialVpn;

  void _loadData({bool reset = false}) async {
    if (reset) {
      if (mounted) {
        setState(() {
          listItemOpenVPN.clear();
          refreshController.resetNoData();
        });
      }
    }
    var resp = await VpnServerHttp(context).allServer(page: null);
    refreshController.refreshCompleted();
    refreshController.loadComplete();

    if (resp == null || resp.isEmpty) {
      setState(() {
        _ready = true;
      });
      return refreshController.loadNoData();
    }

    if (mounted) {
      setState(() {
        _ready = true;
        listItemOpenVPN.addAll(resp);
      });
    }

    if (showAllCountries) {
      refreshController.loadNoData();
    }
  }

  void checkConnectionType(int i) {
    if (i != _value) {}
  }

  void selectVPNServer(BuildContext context,
      {bool force = false, required VpnServer vpnServer}) async {
    VpnProvider provider = VpnProvider.instance(context);
    // AdsProvider.instance(context).showAd3(context);
    if (vpnServer.status == 1 && !provider.isPro && !force) {
      return NAlertDialog(
        title: Text('not_allowed'.tr()),
        content: Text('not_allowed_desc'.tr()),
        actions: [
          TextButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            )),
            onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => SubscriptionDetailScreen())),
            child: Text('go_premium'.tr()),
          ),
        ],
      ).show(context);
    }
    VpnConfig? resp = await CustomProgressDialog.future(
      context,
      future: VpnServerHttp(context).detailVpn(vpnServer),
      dismissable: false,
      loadingWidget: Center(
        child: Container(
          height: 100,
          width: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: const CircularProgressIndicator(),
        ),
      ),
    );

    if (resp != null) {
      provider.vpnConfig = resp;
      if (provider.isConnected ?? false) NVPN.stopVpn();
      Navigator.of(context).pop();
      // UIProvider.instance(context).sheetController.snapToPosition(
      //     const SnappingPosition.factor(
      //         positionFactor: .13,
      //         grabbingContentOffset: GrabbingContentOffset.bottom));
    } else {
      NAlertDialog(
        title: Text('protocol_not_available_title'.tr()),
        content: Text('protocol_not_available'.tr()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              selectVPNServer(context, vpnServer: vpnServer);
            },
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0)))),
            child: Text('force'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0))),
            ),
            child: Text('understand'.tr()),
          )
        ],
      ).show(context);
    }
  }

  Widget listServerWidget() {
    Map<String?, List<VpnServer>> data = {};
    for (var item in listItemOpenVPN) {
      if (data[item.country] != null) {
        data[item.country]!.add(item);
      } else {
        data[item.country] = [item];
      }
    }
    if (_ready) {
      if (data.isEmpty) {
        return Container(
          height: 300,
          padding: const EdgeInsets.only(right: 16),
          alignment: Alignment.center,
          child: Text('no_server_available'.tr(), textAlign: TextAlign.center),
        );
      } else {
        return _listGroupVpn(data);
      }
    } else {
      return Container(
        height: 300,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      );
    }
  }

  Widget _listGroupVpn(Map<String?, List<VpnServer>> data) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: data.keys.length,
        physics: const NeverScrollableScrollPhysics(),
        // controller: scrollController,
        itemBuilder: (context, index) {
          var item = data[data.keys.toList()[index]]!;
          // bool isSelected = item
          //     .map((e) => e.id)
          //     .contains(VpnProvider.instance(context).vpnConfig?.id ?? 0);
          return ItemServerWidget2(
              data: item,
              onChildClick: (vpnServer) {
                selectVPNServer(context, vpnServer: vpnServer);
              },
              flag: Container(
                height: 24,
                width: 24,
                margin: const EdgeInsets.fromLTRB(0, 10, 16, 10),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: primaryColor),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: item.first.flag!.endsWith('.png') ||
                          item.first.flag!.endsWith('jpg')
                      ? CachedNetworkImage(
                          imageUrl: item.first.flag!,
                          fit: BoxFit.fill,
                        )
                      : SvgPicture.network(
                          item.first.flag!,
                          fit: BoxFit.fill,
                        ),
                ),
              ),
              title: item.first.country,
              description: '${item.length} ${'locations'.tr()}');
        });
  }

  @override
  void dispose() {
    scrollController.dispose();
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isLightMode ? mainColorWhite : mainColorDark,
      appBar: commonAppbar(
        context,
        title: 'virtual_server'.tr(),
        hasNext: true,
        nextIcon: isLightMode ? iconSearch : iconSearchDark,
        nextAction: () {},
      ),
      body: SmartRefresher(
        controller: refreshController,
        // enablePullUp: false,
        // physics: const NeverScrollableScrollPhysics(),
        onRefresh: () {
          _loadData(reset: true);
          refreshController.refreshCompleted();
          setState(() {
            _ready = false;
          });
          debugPrint('===== loaded ${DateTime.now().millisecondsSinceEpoch}');
        },
        onLoading: () {
          _loadData(reset: false);
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                // physics: const AlwaysScrollableScrollPhysics(),
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ItemServerWidget(
                        icon: 'assets/images/spaceship3x.png',
                        title: 'auto'.tr(),
                        description: 'limited_speed'.tr(),
                        tag: 'basic'.tr(),
                        subDescription: 'get_premium'.tr(),
                        radioButton: Radio<int>(
                            value: 0,
                            groupValue: _value,
                            activeColor: primaryColor,
                            onChanged: (value) {
                              setState(() {
                                _value = value!;
                                specialVpn = null;
                              });
                            }),
                        onClick: () => setState(() {
                          _value = 0;
                          specialVpn = null;
                        }),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'special_server'.tr(),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      for (int i = 1; i <= 4; i++)
                        ItemServerWidget(
                          icon: 'assets/images/spaceship3x.png',
                          title: 'auto'.tr(),
                          description: 'limited_speed'.tr(),
                          tag: 'basic'.tr(),
                          subDescription: 'get_premium'.tr(),
                          radioButton: Radio<int>(
                              value: i,
                              groupValue: _value,
                              activeColor: primaryColor,
                              onChanged: (value) {
                                setState(() {
                                  _value = value!;
                                  specialVpn = SpecialVpnServer(title: 'Test');
                                });
                              }),
                          onClick: () => setState(() {
                            _value = i;
                            specialVpn = SpecialVpnServer(title: 'Test');
                          }),
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'all_countries'.tr(),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      Flexible(child: listServerWidget()),
                      const SizedBox(
                        height: 500,
                      )
                    ],
                  ),
                ),
              ),
            ),
            if (specialVpn != null)
              Positioned(
                  bottom: 48,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CustomButton(
                      backgroundColor: primaryColor,
                      boderRadius: BorderRadius.circular(30),
                      toUpperCase: false,
                      customHeight: 54,
                      text: '${'connect_to'.tr()} ${specialVpn.title}',
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.white),
                      onPressed: () async {
                        var vpnProvider =
                            Provider.of<VpnProvider>(context, listen: false);
                        if (vpnProvider.isConnected!) {
                          NVPN.stopVpn();
                          var local = await Preferences.init();
                          local.saveTime(-connectionTimeTotal!.inSeconds);
                        }
                        Future.delayed(const Duration(milliseconds: 100)).then(
                            (value) =>
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ConnectingScreen(
                                          specialVpn: specialVpn,
                                          vpnConfig: vpnProvider.vpnConfig,
                                        ))));
                      },
                    ),
                  ))
          ],
        ),
      ),
    );
  }
}

class ItemServerWidget2 extends StatelessWidget {
  const ItemServerWidget2(
      {super.key,
      this.icon,
      this.flag,
      this.iconScale,
      this.title,
      this.titleStyle,
      this.description,
      this.descriptionStyle,
      this.subDescription,
      this.tag,
      this.radioButton,
      this.onClick,
      this.data,
      required this.onChildClick});

  final List<VpnServer>? data;
  final String? icon;
  final Widget? flag;
  final double? iconScale;
  final String? title;
  final TextStyle? titleStyle;
  final String? description;
  final TextStyle? descriptionStyle;
  final String? subDescription;
  final String? tag;
  final Widget? radioButton;
  final VoidCallback? onClick;
  final Function onChildClick;

  @override
  Widget build(BuildContext context) {
    return ConfigurableExpansionTile(
        onExpansionChanged: (value) {},
        animatedWidgetFollowingHeader: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Image.asset(
            'assets/images/right_arrow.png',
          ),
        ),
        header: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            flag ?? const SizedBox.shrink(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title ?? '',
                      style: titleStyle ??
                          const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 18,
                      width: 43,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: neutral900),
                      child: Center(
                          child: Text(
                        tag ?? 'Free',
                        style: TextStyle(fontSize: 8, color: gray50),
                      )),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${data?.length} ${'locations'.tr()}',
                  style: descriptionStyle ??
                      TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: gray500),
                )
              ],
            ),
          ],
        ),
        children: [
          for (var item in data!) ...[
            InkWell(
              onTap: () => onChildClick(item),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 32,
                        top: 5,
                        bottom: 5,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          flag ??
                              Container(
                                height: 24,
                                width: 24,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: primaryColor),
                                child: Image.asset(
                                  icon!,
                                  scale: iconScale,
                                  color: Colors.white,
                                ),
                              ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    item.name!,
                                    style: titleStyle ??
                                        const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Container(
                                    height: 18,
                                    width: 43,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: neutral900),
                                    child: Center(
                                        child: Text(
                                      item.status == 0 ? 'Free' : 'Pro',
                                      style:
                                          TextStyle(fontSize: 8, color: gray50),
                                    )),
                                  )
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    'Time delay: 100ms',
                                    style: descriptionStyle ??
                                        TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: gray500),
                                  ),
                                  if (subDescription != null) ...[
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    CustomButton(
                                      type: ButtonType.text,
                                      text: subDescription,
                                      textStyle: const TextStyle(
                                          fontSize: 10,
                                          color: primaryColor,
                                          fontWeight: FontWeight.w700),
                                      buttonTextPadding:
                                          const EdgeInsets.all(0),
                                      onPressed: () {
                                        print(DateTime.now()
                                            .millisecondsSinceEpoch);
                                      },
                                    )
                                  ]
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ]);
  }
}

class ItemServerWidget extends StatelessWidget {
  const ItemServerWidget(
      {super.key,
      this.icon,
      this.title,
      this.description,
      this.iconScale = 3,
      this.subDescription,
      this.titleStyle =
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      this.descriptionStyle =
          const TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
      this.tag,
      this.radioButton,
      this.onClick,
      this.flag});

  final String? icon;
  final Widget? flag;
  final double? iconScale;
  final String? title;
  final TextStyle? titleStyle;
  final String? description;
  final TextStyle? descriptionStyle;
  final String? subDescription;
  final String? tag;
  final Widget? radioButton;
  final VoidCallback? onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onClick,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 5,
                bottom: 5,
              ),
              child: Row(
                // mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  flag ??
                      Container(
                        height: 24,
                        width: 24,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: primaryColor),
                        child: Image.asset(
                          icon!,
                          scale: iconScale,
                          color: Colors.white,
                        ),
                      ),
                  const SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title!,
                            style: titleStyle,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          if (tag != null)
                            Container(
                              height: 18,
                              width: 43,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: neutral900),
                              child: Center(
                                  child: Text(
                                tag!,
                                style: TextStyle(fontSize: 8, color: gray50),
                              )),
                            )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            description!,
                            style: descriptionStyle,
                          ),
                          if (subDescription != null) ...[
                            const SizedBox(
                              width: 8,
                            ),
                            CustomButton(
                              type: ButtonType.text,
                              text: subDescription,
                              textStyle: const TextStyle(
                                  fontSize: 10,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w700),
                              buttonTextPadding: const EdgeInsets.all(0),
                              onPressed: () {
                                // print(DateTime.now().millisecondsSinceEpoch);
                              },
                            )
                          ]
                        ],
                      )
                    ],
                  ),
                  const Spacer(),
                  radioButton ?? const SizedBox.shrink()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
