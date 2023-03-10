import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';

import '../../core/resources/environment.dart';
import '../../theme/color.dart';
import '../components/customDivider.dart';

class SharePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _customAppBarWidget(),
          _inviteFriendsWidget(context),
        ],
      ),
    );
  }

  Widget _inviteFriendsWidget(BuildContext context) {
    return Expanded(
      child: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LottieBuilder.asset(
                'assets/animations/share.json',
                height: 200,
                fit: BoxFit.contain,
                width: MediaQuery.of(context).size.width,
              ),
              const ColumnDivider(),
              Text(
                'share_title'.tr(),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                'share_desc'.tr().replaceAll('\$appname', appname),
                style: const TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
              const ColumnDivider(),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10)),
                      backgroundColor: MaterialStateProperty.all(primaryColor),
                      shape: MaterialStateProperty.all(const StadiumBorder()),
                    ),
                    onPressed: _shareClick,
                    child: Text(
                      'share_button'.tr(),
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
              const ColumnDivider(space: 80)
            ],
          ),
        ),
      ),
    );
  }

  Widget _customAppBarWidget() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
              text: "${"invite".tr()} ",
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600)),
          TextSpan(
              text: 'friends'.tr(),
              style: GoogleFonts.poppins(
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }

  void _shareClick() async {
    PackageInfo pinfo = await PackageInfo.fromPlatform();
    Share.share(
      "${"share_message".tr()}\nhttps://play.google.com/store/apps/details?id=${pinfo.packageName}",
    );
  }
}
