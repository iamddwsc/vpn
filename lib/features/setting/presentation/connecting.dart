import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nizvpn/common_widgets/custom_button.dart';
import 'package:nizvpn/core/models/vpnConfig.dart';
import 'package:nizvpn/core/provider/vpnProvider.dart';
import 'package:nizvpn/core/utils/NizVPN.dart';
import 'package:nizvpn/theme/color.dart';
import 'package:provider/provider.dart';

class ConnectingScreen extends StatefulWidget {
  const ConnectingScreen({super.key, this.specialVpn, this.vpnConfig});

  final dynamic specialVpn;
  final VpnConfig? vpnConfig;

  @override
  State<ConnectingScreen> createState() => _ConnectingScreenState();
}

class _ConnectingScreenState extends State<ConnectingScreen> {
  @override
  void initState() {
    super.initState();
    NVPN.startVpn(widget.vpnConfig!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<VpnProvider>(
        builder: (context, value, _) {
          if (value.isConnected!) {
            Future.delayed(const Duration(seconds: 0)).then((value) {
              Navigator.popUntil(
                context,
                ModalRoute.withName('/'),
              );
            });
          }
          return Center(
            child: Column(
              children: [
                const Expanded(
                    flex: 2,
                    child: Center(
                      child: SizedBox(
                          height: 66.67,
                          width: 66.67,
                          child: CircularProgressIndicator.adaptive()),
                    )),
                Expanded(
                    child: Column(
                  children: [
                    Text(
                      '${'connecting_to'.tr()} ${widget.specialVpn.title}',
                    ),
                    CustomButton(
                      text: 'cancel'.tr(),
                      type: ButtonType.text,
                      textStyle: TextStyle(
                          color: background,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                      buttonTextPadding: const EdgeInsets.all(8),
                      onPressed: () {
                        NVPN.stopVpn();
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ))
              ],
            ),
          );
        },
      ),
    );
  }
}
