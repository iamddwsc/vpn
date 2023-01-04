import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lottie/lottie.dart';
import 'package:nizvpn/core/provider/purchaseProvider.dart';
import 'package:provider/provider.dart';

import '../../core/provider/vpnProvider.dart';
import '../../core/resources/warna.dart';
import '../../theme/color.dart';
import '../components/customDivider.dart';

class SubscriptionDetailScreen extends StatefulWidget {
  @override
  _SubscriptionDetailScreenState createState() =>
      _SubscriptionDetailScreenState();
}

class _SubscriptionDetailScreenState extends State<SubscriptionDetailScreen> {
  String? _selectedId;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((val) {
      PurchaseProvider value = PurchaseProvider.instance(context);
      if (value.subscriptionProducts != null &&
          value.subscriptionProducts!.isNotEmpty) {
        setState(() {
          _selectedId = 'one_month_subs';
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VpnProvider>(
      builder: (context, value, child) {
        if (value.isPro) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(LineIcons.windowClose),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LottieBuilder.asset(
                      'assets/animations/crown.json',
                      height: 150,
                      width: 150,
                      fit: BoxFit.contain,
                    ),
                    const ColumnDivider(),
                    Text(
                      'great'.tr(),
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'premium_purchased'.tr(),
                      style: const TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return _subscribeBody(context);
        }
      },
    );
  }

  Widget _subscribeBody(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Opacity(
              opacity: .7,
              child: LottieBuilder.asset(
                'assets/animations/topright_wave.json',
                height: 300,
                width: 400,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Transform.scale(
              scale: 2,
              alignment: Alignment.bottomCenter,
              child: LottieBuilder.asset(
                'assets/animations/background.json',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: Container()),
                    const CloseButton(
                      color: Colors.white,
                    ),
                    const RowDivider(),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(
                          top: 20, left: 20, right: 20, bottom: 80),
                      children: [
                        LottieBuilder.asset(
                          'assets/animations/crown.json',
                          height: 150,
                          width: 150,
                          fit: BoxFit.contain,
                        ),
                        ShaderMask(
                          shaderCallback: (bounds) {
                            return const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [primaryColor, accentColor],
                            ).createShader(bounds);
                          },
                          child: Text(
                            'subscribe_title'.tr(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const ColumnDivider(space: 5),
                        Text(
                          'subscription_detail'.tr(),
                          style:
                              const TextStyle(fontSize: 15, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        const ColumnDivider(space: 5),
                        _listPremium(),
                        const ColumnDivider(space: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width - 40,
        height: 50,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: _selectedId != null
                  ? primaryColor.withOpacity(.3)
                  : Colors.grey.withOpacity(.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: TextButton(
          style: ButtonStyle(
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 20)),
              backgroundColor: MaterialStateProperty.all(
                  _selectedId == null ? Colors.grey : accentColor),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              )),
          onPressed: _selectedId != null ? _subscribeClick : null,
          child: Text(
            'subscribe'.tr(),
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
      // bottomNavigationBar: AdsProvider.adbottomSpace(),
    );
  }

  Widget _listPremium() {
    return Consumer<PurchaseProvider>(
      builder: (context, value, child) {
        if (value.subscriptionProducts != null &&
            (value.subscriptionProducts?.length ?? 0) > 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: value.subscriptionProducts!.map(
              (e) {
                String harga =
                    "${e.currency!} ${e.price!.contains(".") ? e.price!.split(".").first : e.price!}";
                String label = '';
                switch (e.productId) {
                  case 'one_year_subs':
                    label = 'Yearly';
                    break;
                  case 'one_month_subs':
                    label = 'Monthly';
                    break;
                  case 'one_week_subs':
                    label = 'Weekly';
                    break;
                }
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: _selectedId == e.productId
                            ? accentColor
                            : Colors.transparent,
                        width: 2),
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedId = e.productId;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.black),
                                ),
                                const RowDivider(space: 5),
                                e.productId == 'one_month_subs'
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        decoration: BoxDecoration(
                                            color: accentColor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Text(
                                          'most_popular'.tr(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ),
                          Text(
                            harga,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black),
                          ),
                          const RowDivider(),
                          SizedBox(
                            height: 30,
                            width: 30,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: _selectedId == e.productId
                                  ? const Icon(LineIcons.check,
                                      color: accentColor)
                                  : const SizedBox.shrink(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          );
        } else {
          return Container(
            height: 200,
            alignment: Alignment.center,
            child: Text(
              'not_available'.tr(),
              textAlign: TextAlign.center,
            ),
          );
        }
      },
    );
  }

  void _subscribeClick() async {
    PurchaseProvider purchaseProvider = PurchaseProvider.instance(context);
    await purchaseProvider.subscribe(_selectedId!);
  }
}

class CustomInfoWidget extends StatelessWidget {
  const CustomInfoWidget(
      {Key? key, this.leftTop, this.leftBottom, this.rightTop, this.child})
      : super(key: key);
  final double? leftTop;
  final double? leftBottom;
  final double? rightTop;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 40,
      decoration: BoxDecoration(
        color: greyMuchWhite,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(leftBottom ?? 0),
          topRight: Radius.circular(rightTop ?? 0),
          topLeft: Radius.circular(leftTop ?? 0),
        ),
      ),
      child: child,
    );
  }
}
