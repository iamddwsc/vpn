import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nizvpn/core/provider/vpnProvider.dart';
import 'package:nizvpn/core/resources/environment.dart';
import 'package:provider/provider.dart';

class AdsProviderV2 extends ChangeNotifier {
  InterstitialAd? intersAd1;
  InterstitialAd? intersAd2;
  InterstitialAd? intersAd3;

  bool _footerBannerShow = false;
  dynamic _bannerAd;

  set footBannerShow(bool value) {
    _footerBannerShow = value;
    notifyListeners();
  }

  bool get footBannerShow => !showAds ? false : _footerBannerShow;

  get bannerIsAvailable => _bannerAd != null;

  Future<InterstitialAd?> _loadIntersAd(
      String adUnitID, InterstitialAd? intersAd) async {
    await InterstitialAd.load(
        adUnitId: adUnitID,
        request: const AdRequest(httpTimeoutMillis: 8000),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback =
                FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
              intersAd!.dispose();
              _loadIntersAd(adUnitID, intersAd);
            });
            intersAd = ad;
          },
          onAdFailedToLoad: (err) {
            debugPrint('Failed to load an interstitial ad: ${err.message}');
          },
        ));
    return intersAd;
  }

  static void initAds(BuildContext context) async {
    if (!showAds) return;
    AdsProviderV2 adsProviderV2 = AdsProviderV2.instance(context);

    // adsProviderV2.intersAd1 =
    //     adsProviderV2._loadIntersAd(inters1, adsProviderV2.intersAd1);
    adsProviderV2.intersAd2 =
        await adsProviderV2._loadIntersAd(inters2, adsProviderV2.intersAd2);
    // adsProviderV2.intersAd3 =
    //     adsProviderV2._loadIntersAd(inters3, adsProviderV2.intersAd3);
  }

  void showAd(BuildContext context, int adIndex) {
    if (!showAds) return;

    VpnProvider vpnProvider = VpnProvider.instance(context);
    AdsProviderV2 adsProviderV2 = AdsProviderV2.instance(context);
    InterstitialAd? ad = adIndex == 1
        ? adsProviderV2.intersAd1
        : adIndex == 2
            ? adsProviderV2.intersAd2
            : adsProviderV2.intersAd3;
    if (vpnProvider.isPro) return;
    if (ad?.responseInfo != null) {
      ad?.show();
    }
  }

  static Widget adWidget(BuildContext context, {String? bannerId}) {
    if (!showAds) return const SizedBox.shrink();
    VpnProvider vpnProvider = VpnProvider.instance(context);
    if (vpnProvider.isPro) {
      return const SizedBox.shrink();
    } else {
      // return SizedBox.shrink();
      // return AdWidget(
      //   adUnitId: bannerId ?? banner1,
      //   size: adSize ?? AdSize.banner,
      // );
      return Container();
      // return BannerAd(adUnitId: bannerId ?? banner1, adSize: adsize);
    }
  }

  static Widget adbottomSpace() {
    if (!showAds) return const SizedBox.shrink();
    return Consumer<AdsProviderV2>(
      builder: (context, value, child) =>
          value.footBannerShow ? const SizedBox(height: 60) : const SizedBox.shrink(),
    );
  }

  void removeBanner() {
    if (!showAds) return;
    footBannerShow = false;
    _bannerAd.dispose();
    _bannerAd = null;
  }

  static AdsProviderV2 instance(BuildContext context) =>
      Provider.of<AdsProviderV2>(context, listen: false);
}
