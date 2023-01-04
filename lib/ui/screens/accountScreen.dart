import 'package:flutter/material.dart';
import 'package:nizvpn/common_widgets/assets_widget.dart';
import 'package:nizvpn/common_widgets/common_appbar.dart';
import 'package:nizvpn/common_widgets/loading_cupertino.dart';
import 'package:nizvpn/constants/string_constants.dart';
import 'package:nizvpn/theme/color.dart';
import 'package:nizvpn/ui/auth/auth_utils.dart';
import 'package:nizvpn/ui/utils/global_function.dart';
import 'package:nizvpn/ui/utils/global_variable.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final double btnWidth = 174;
  final double btnHeight = 54;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isLightMode ? mainColorWhite : mainColorDark,
      appBar: commonAppbar(context, noBack: true),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: ClipOval(
              child: (isSignedInApp && currentUserAvatar != strEmpty)
                  ? Image.network(
                      currentUserAvatar,
                      width: 100,
                      height: 100,
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          avatarDefault,
                    )
                  : avatarDefault,
            ),
          ),
          Container(
            margin:
                const EdgeInsets.symmetric(horizontal: baseSpace, vertical: 8),
            child: Text(
              isSignedInApp ? currentUserEmail : strWelcomGuest,
              style: isLightMode ? styleAppBarTitle : styleAppBarTitleDark,
            ),
          ),
          Container(
            color: Colors.transparent,
            width: btnWidth,
            height: btnHeight,
            child: Stack(children: [
              Container(
                color: Colors.transparent,
                width: btnWidth,
                height: btnHeight,
                child: ElevatedButton(
                  onPressed: () async {
                    if (isSignedInApp) {
                      isInProgressSignOutApp = true;
                      setState(() {});
                      await signOutApp();
                    } else {
                      await gotoSignIn(context);
                    }
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    foregroundColor: Colors.white,
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  child: Text(
                    isSignedInApp ? strSignOut : strSignIn,
                    style: styleTextBtnActive,
                  ),
                ),
              ),
              if (isInProgressSignOutApp) loadingCupertino(size: 20),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Account',
                  style: TextStyle(
                    color: background,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      'UPGRADE',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      child: Text(
                        'Basic',
                        style: TextStyle(
                          color: gray800,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Devices',
                  style: TextStyle(
                      color: background,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  '1/6',
                  style: TextStyle(
                      color: gray800,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Help center',
                  style: TextStyle(
                      color: background,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  '',
                  style: TextStyle(
                      color: gray800,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rate us',
                  style: TextStyle(
                      color: background,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  '',
                  style: TextStyle(
                      color: gray800,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'About',
                  style: TextStyle(
                      color: background,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  '',
                  style: TextStyle(
                      color: gray800,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
