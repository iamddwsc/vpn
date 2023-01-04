import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

import '../models/dnsConfig.dart';
import '../models/vpnConfig.dart';
import '../models/vpnStatus.dart';
import '../resources/environment.dart';

class NVPN {
  ///Channel to native
  static const String _eventChannelVpnStage = 'id.nizwar.nvpn/vpnstage';
  static const String _eventChannelVpnStatus = 'id.nizwar.nvpn/vpnstatus';
  static const String _methodChannelVpnControl = 'id.nizwar.nvpn/vpncontrol';

  ///Snapshot of VPN Connection Stage
  static Stream<String?> vpnStageSnapshot() =>
      const EventChannel(_eventChannelVpnStage).receiveBroadcastStream().cast();

  ///Snapshot of VPN Connection Status
  static Stream<VpnStatus?> vpnStatusSnapshot() =>
      const EventChannel(_eventChannelVpnStatus)
          .receiveBroadcastStream()
          .map((event) => VpnStatus.fromJson(
              jsonDecode(event as String) as Map<String, dynamic>))
          .cast();

  ///For IOS
  static Future<dynamic> initialize() {
    return const MethodChannel(_methodChannelVpnControl)
        .invokeMethod('initialize', {
      'providerBundleIdentifier': vpnExtensionIdentifier,
      'localizedDescription': '$appname VPN Config',
    });
  }

  ///Start VPN easily
  static Future<void> startVpn(VpnConfig vpnConfig,
      {DnsConfig? dns, List<String>? bypassPackages}) async {
    if (Platform.isIOS) await initialize();
    return const MethodChannel(_methodChannelVpnControl).invokeMethod(
      'start',
      {
        'config': '''${vpnConfig.config}
        client-cert-not-required 
        #plugin /usr/lib/openvpn/openvpn-plugin-auth-pam.so login ''',
        'country': vpnConfig.name,
        'username': vpnConfig.username ?? (defaultVpnUsername),
        'password': vpnConfig.password ?? (defaultVpnPassword),
        'dns1': dns?.dns1,
        'dns2': dns?.dns2,
        'bypass_packages': bypassPackages ?? [],
      },
    );
  }

  ///Stop vpn
  static Future<void> stopVpn() =>
      const MethodChannel(_methodChannelVpnControl).invokeMethod('stop');

  ///Open VPN Settings
  static Future<void> openKillSwitch() =>
      const MethodChannel(_methodChannelVpnControl).invokeMethod('kill_switch');

  ///Trigger native to get stage connection
  static Future<void> refreshStage() =>
      const MethodChannel(_methodChannelVpnControl).invokeMethod('refresh');

  ///Get latest stage
  static Future<String> stage() => const MethodChannel(_methodChannelVpnControl)
      .invokeMethod('stage')
      .then((value) => value != null ? value as String : vpnDisconnected);

  ///Check if vpn is connected
  static Future<bool> isConnected() =>
      stage().then((value) => value.toLowerCase() == 'connected');

  ///Check if vpn is connected
  static Future sendToBackground() =>
      const MethodChannel(_methodChannelVpnControl)
          .invokeMethod('sendToBackground');

  ///All Stages of connection
  static const String vpnConnected = 'connected';
  static const String vpnDisconnected = 'disconnected';
  static const String vpnWaitConnection = 'wait_connection';
  static const String vpnAuthenticating = 'authenticating';
  static const String vpnReconnect = 'reconnect';
  static const String vpnNoConnection = 'no_connection';
  static const String vpnConnecting = 'connecting';
  static const String vpnPrepare = 'prepare';
  static const String vpnDenied = 'denied';
}
