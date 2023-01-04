import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  Preferences(this.shared);
  final SharedPreferences shared;

  String? get vpnToken => shared.getString('token');
  String? get protocol => shared.getString('protocol');
  bool get privacyPolicy => shared.getBool('privacy-policy') ?? false;
  bool get firstOpen => shared.getBool('first_open') ?? false;
  bool get subscribed => shared.getBool('subscribed') ?? false;
  int get remainingTimeUse => shared.getInt('remaining_time_use') ?? 0;
  List<String> get trustedWifi => shared.getStringList('trustedWifi') ?? [];
  List<String> get getDNS => shared.getStringList('listDns') ?? [];
  int get appearance => shared.getInt('appearance') ?? 0;

  List<String> get whitePackages =>
      shared.getStringList('white_packages') ?? [];

  Locale? get locale => shared.getString('lang_code') == null
      ? null
      : Locale(shared.getString('lang_code') ?? 'en',
          shared.getString('country_code'));

  Future saveTime(int time) {
    return shared.setInt('remaining_time_use', remainingTimeUse + time);
  }

  Future saveLocale(Locale locale) async {
    shared.setString('lang_code', locale.languageCode);
    if (locale.countryCode != null) {
      shared.setString('country_code', locale.countryCode!);
    }
  }

  Future saveFirstOpen() {
    return shared.setBool('first_open', true);
  }

  Future saveSubscription() {
    return shared.setBool('subscribed', true);
  }

  Future saveVpnToken(String token) {
    return shared.setString('token', token);
  }

  Future saveProtocol(String protocol) {
    return shared.setString('protocol', protocol);
  }

  Future acceptPrivacyPolicy() {
    return shared.setBool('privacy-policy', true);
  }

  Future saveWhitePages(List<String> list) {
    return shared.setStringList('white_packages', list);
  }

  Future saveListTrustedWifi(List<String> list) {
    return shared.setStringList('trustedWifi', list);
  }

  Future saveDNS(String dns) {
    return shared.setStringList('listDns', getDNS..add(dns));
  }

  Future removeDNS(String dns) {
    return shared.setStringList('listDns', getDNS..remove(dns));
  }

  Future setAppearance(int num) {
    return shared.setInt('appearance', num);
  }

  bool get isAuth => shared.getBool('isAuth') ?? false;
  Future saveAuth(bool isAuth) {
    return shared.setBool('isAuth', isAuth);
  }

  String? get getUserUid => shared.getString('userUid');
  Future saveUserUid(String uId) {
    return shared.setString('userUid', uId);
  }

  String? get getUserEmail => shared.getString('userEmail');
  Future saveUserEmail(String email) {
    return shared.setString('userEmail', email);
  }

  String? get getUserAvatar => shared.getString('userAvatar');
  Future saveUserAvatar(String url) {
    return shared.setString('userAvatar', url);
  }

  static Future<Preferences> init() =>
      SharedPreferences.getInstance().then((value) => Preferences(value));
}
