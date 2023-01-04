import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/resources/environment.dart';
import '../../core/utils/preferences.dart';
import '../../main.dart';
import '../../theme/color.dart';
import '../components/customCard.dart';
import '../components/customDivider.dart';

class PrivacyPolicyIntroScreen extends StatefulWidget {
  const PrivacyPolicyIntroScreen({Key? key, this.rootState}) : super(key: key);
  final RootState? rootState;

  @override
  _PrivacyPolicyIntroScreenState createState() =>
      _PrivacyPolicyIntroScreenState();
}

class _PrivacyPolicyIntroScreenState extends State<PrivacyPolicyIntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: CustomCard(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('privacypolicy_title'.tr(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  children: [
                    Text('privacypolicy_subtitle'
                        .tr()
                        .replaceAll('\$appname', appname)),
                    const ColumnDivider(),
                    Text('privacypolicy_h2'.tr(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const ColumnDivider(space: 5),
                    _privacyPointWidget('privacypolicy_title1'.tr(),
                        'privacypolicy_desc1'.tr()),
                    const ColumnDivider(),
                    _privacyPointWidget('privacypolicy_title2'.tr(),
                        'privacypolicy_desc2'.tr()),
                    const ColumnDivider(),
                    _privacyPointWidget('privacypolicy_title3'.tr(),
                        'privacypolicy_desc3'.tr()),
                    const ColumnDivider(),
                    Text('privacypolicy_footer'.tr(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12))
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(primaryColor),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                    ),
                  ),
                  onPressed: _accAndContinueClick,
                  child: Text(
                    'accept_continue'.tr(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      // bottomNavigationBar: AdsProvider.adbottomSpace(),
    );
  }

  void _accAndContinueClick() {
    Preferences.init().then((value) {
      widget.rootState!.setState(() {
        value.acceptPrivacyPolicy();
      });
    });
  }

  Widget _privacyPointWidget(String title, String message) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 3),
          decoration:
              const BoxDecoration(color: primaryColor, shape: BoxShape.circle),
          width: 15,
          height: 15,
        ),
        const RowDivider(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(message),
            ],
          ),
        )
      ],
    );
  }
}
