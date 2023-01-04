import 'package:flutter/material.dart';
import 'package:nizvpn/common_widgets/assets_widget.dart';
import 'package:nizvpn/common_widgets/custom_button.dart';
import 'package:nizvpn/constants/string_constants.dart';
import 'package:nizvpn/theme/color.dart';
import 'package:nizvpn/ui/utils/global_function.dart';
import 'package:nizvpn/ui/utils/global_variable.dart';

class SubcriptionScreen extends StatelessWidget {
  const SubcriptionScreen({super.key, required this.onDone});

  final VoidCallback? onDone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: LayoutBuilder(
        builder: (p0, p1) {
          // print(p1.maxHeight);
          if (p1.maxHeight < 700) {
            return SingleChildScrollView(
              child: SubcriptionReponsiveWidget(
                  onDone: onDone, isLongScreen: false),
            );
          } else {
            return SubcriptionReponsiveWidget(
                onDone: onDone, isLongScreen: true);
          }
        },
      ),
    );
  }
}

Widget _buildFeature(
    {required String imagePath, required String title, double? height}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20.0),
    child: Row(
      // mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          imagePath,
          scale: height! < 750 ? 1 : 0.9,
        ),
        const SizedBox(
          width: 12,
        ),
        Text(
          title,
          style: TextStyle(
              fontSize: dynamicSize(height, 14), fontWeight: FontWeight.w600),
        )
      ],
    ),
  );
}

class SubcriptionReponsiveWidget extends StatelessWidget {
  const SubcriptionReponsiveWidget(
      {super.key, this.onDone, required this.isLongScreen});

  final VoidCallback? onDone;
  final bool isLongScreen;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    // return Scaffold(
    // backgroundColor: isLightMode ? mainColorWhite : mainColorDark,
    // appBar: commonAppbar(context, noBack: true),
    return Container(
      padding: const EdgeInsets.only(top: kToolbarHeight),
      color: isLightMode ? mainColorWhite : mainColorDark,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: isLongScreen ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(left: baseSpace),
                child: imgLogoSmall,
              ),
              Container(
                margin: const EdgeInsets.only(left: 8, right: baseSpace),
                color: Colors.transparent,
                child: Text(
                  strAppFullName,
                  style:
                      isLightMode ? styleAppNameSmall : styleAppNameSmallDark,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(
                horizontal: baseSpace, vertical: baseSpace),
            child: Text(
              'Update to PAPA Premium to get all\nthese great features',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: dynamicSize(height, 12, factor: 800),
                  fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(height: 41),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _buildFeature(
                imagePath: 'assets/images/subcription/worldwide.png',
                title: 'Faster worldwide location',
                height: height),
            _buildFeature(
                imagePath: 'assets/images/subcription/rocket.png',
                title: 'Increase connection speed',
                height: height),
            _buildFeature(
                imagePath: 'assets/images/subcription/no_ads.png',
                title: 'No ads',
                height: height),
          ]),
          if (isLongScreen)
            const Spacer()
          else
            SizedBox(
              height: height * 0.1,
            ),
          const Flexible(child: SizedBox.shrink()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomButton(
              customHeight: 54,
              text: 'Subcribe with 7-day trial',
              textStyle: TextStyle(
                  fontSize: dynamicSize(height, 14),
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
              backgroundColor: primaryColor,
              boderRadius: BorderRadius.circular(30),
              toUpperCase: false,
              onPressed: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 16),
            child: Text(
              'Pay \$0 to day, then \$12,99/mo after free trial. Cancel anytime',
              style: TextStyle(
                  fontSize: dynamicSize(height, 10),
                  fontWeight: FontWeight.w400,
                  color: miniTextBlack),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomButton(
              customHeight: 50,
              text: 'Continue free with ads',
              textStyle: TextStyle(
                  fontSize: dynamicSize(height, 14),
                  fontWeight: FontWeight.w700,
                  color: background),
              backgroundColor: Colors.transparent,
              borderColor: background,
              boderWidth: 1,
              boderRadius: BorderRadius.circular(30),
              hasBorder: true,
              toUpperCase: false,
              onPressed: onDone,
            ),
          ),
          if (isLongScreen)
            const Spacer()
          else
            SizedBox(
              height: height * 0.06,
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text.rich(TextSpan(
                text: 'By using this app, you agree to the ',
                style: TextStyle(
                    fontSize: dynamicSize(height, 10, factor: 800),
                    fontWeight: FontWeight.w400),
                children: const [
                  TextSpan(
                      text: 'Terms of Service ',
                      style: TextStyle(
                          color: primaryColor,
                          decoration: TextDecoration.underline)),
                  TextSpan(text: 'and acknowledge the '),
                  TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                          color: primaryColor,
                          decoration: TextDecoration.underline)),
                  TextSpan(
                      text:
                          '. You will start a monthly subscription plan and be charged 12,99 \$ at the end of your trial unless you cancel it before it ends. Upon purchasing a subscription, any unused portion of a free trial period will be forfeited. Your subscription will auto-renew and you will be billed 12,99 \$ each month until you '),
                  TextSpan(
                      text: 'cancel',
                      style: TextStyle(
                          color: primaryColor,
                          decoration: TextDecoration.underline)),
                  TextSpan(
                      text:
                          ' by turning off auto-renewal before the end of the then-current subscription period.')
                ])),
          ),
          SizedBox(
            height: height < 750 ? 30 : 40,
          )
        ],
        // ),
      ),
    );
  }
}
