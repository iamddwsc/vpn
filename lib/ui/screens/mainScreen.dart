import 'package:flutter/material.dart';
import 'package:nizvpn/features/premium_plan/presentation/premium_screen.dart';
import 'package:nizvpn/features/setting/presentation/setting_page.dart';
import 'package:nizvpn/ui/screens/accountScreen.dart';
import 'package:nizvpn/ui/utils/global_variable.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

import '../../core/provider/uiProvider.dart';
import '../../features/home/presentation/home_page.dart';
import '../../theme/color.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double selectServerOpacity = 0;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      // AdsProvider.initAds(context);
      // MobileAds.instance.initialize();
      // AdsProviderV2.initAds(context);
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  var screens = [
    const HomeScreen(),
    // SharePage(),
    const PremiumPlan(),
    // PengaturanPage(),
    const SettingPage(),
    // HomeScreen()
    // BerandaPage()
    // PengaturanPage(),
    // WhiteListScreen()
    AccountScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (UIProvider.instance(context).sheetController.currentPosition >
            300) {
          UIProvider.instance(context).sheetController.snapToPosition(
              const SnappingPosition.factor(
                  positionFactor: .13,
                  grabbingContentOffset: GrabbingContentOffset.bottom));
          return false;
        }
        MainScreenProvider provider = MainScreenProvider.instance(context);
        if (provider.pageIndex > 0) {
          provider.pageIndex--;
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
          // extendBodyBehindAppBar: true,
          // bottomNavigationBar: Consumer<VpnProvider>(
          //   builder: (context, value, child) =>
          //       value.isPro ? SizedBox.shrink() : child!,
          //   child: SafeArea(
          //     child: SizedBox(
          //       height: 60,
          //       // child: AdsProvider.adWidget(context),
          //     ),
          //   ),
          // ),
          // body: SnappingSheet(
          //   controller: UIProvider.instance(context).sheetController,
          //   onSheetMoved: (position) {
          //     double _val = (100 / 600) * (position.pixels / 600);
          //     if (_val > 1) return;
          //     if (_val < 0.5) _val = 0;
          //     if (_val > 1) _val = 1;
          //     setState(() {
          //       selectServerOpacity = _val;
          //     });
          //   },
          //   initialSnappingPosition: SnappingPosition.factor(
          //     positionFactor: 0.16,
          //     snappingCurve: Curves.easeOutExpo,
          //     snappingDuration: Duration(seconds: 1),
          //     grabbingContentOffset: GrabbingContentOffset.bottom,
          //   ),
          //   snappingPositions: [
          //     SnappingPosition.factor(
          //       positionFactor: 0.16,
          //       snappingCurve: Curves.easeOutExpo,
          //       snappingDuration: Duration(seconds: 1),
          //       grabbingContentOffset: GrabbingContentOffset.bottom,
          //     ),
          //     SnappingPosition.factor(
          //       positionFactor: .8,
          //       snappingCurve: Curves.bounceOut,
          //       snappingDuration: Duration(seconds: 1),
          //       grabbingContentOffset: GrabbingContentOffset.bottom,
          //     ),
          //   ],
          //   grabbingHeight: 100,
          //   sheetBelow: SnappingSheetContent(
          //     child: Container(
          //       child: SelectVpnScreen(scrollController: _scrollController),
          //       decoration: BoxDecoration(
          //         boxShadow: [
          //           BoxShadow(
          //               color: Colors.black.withOpacity(.1),
          //               offset: Offset(0, -1),
          //               blurRadius: 10)
          //         ],
          //         color: Colors.white,
          //         borderRadius: BorderRadius.only(
          //           topRight: Radius.circular(20),
          //           topLeft: Radius.circular(20),
          //         ),
          //       ),
          //     ),
          //   ),
          //   grabbing: _customBottomNavBar(),
          //   child: Stack(
          //     children: [
          //       Positioned(
          //         bottom: 30,
          //         child: BottomImageCityWidget(),
          //       ),
          //       Column(
          //         children: [
          //           Expanded(
          //             child: Consumer<MainScreenProvider>(
          //               builder: (context, value, child) => [
          //                 // BerandaPage(),
          //                 HomeScreen(),
          //                 SharePage(),
          //                 PengaturanPage(),
          //               ][value.pageIndex],
          //             ),
          //           ),
          //           // AdsProvider.adbottomSpace()
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          // body: Stack(children: [
          //   Positioned.fill(
          //     child: Column(
          //       children: [
          //         Expanded(
          //           child: Consumer<MainScreenProvider>(
          //             builder: (context, value, child) => [
          //               // BerandaPage(),
          //               HomeScreen(),
          //               SharePage(),
          //               PengaturanPage(),
          //               // HomeScreen()
          //               BerandaPage()
          //             ][value.pageIndex],
          //           ),
          //         ),
          //         // AdsProvider.adbottomSpace()
          //       ],
          //     ),
          //   )
          // ]),
          backgroundColor: isLightMode ? mainColorWhite : mainColorDark,
          body: Consumer<MainScreenProvider>(builder: (context, value, _) {
            return IndexedStack(
              index: value._curIndex,
              children: screens,
            );
          }),
          bottomNavigationBar: _customBottomNavBarV2()),
    );
  }

  Widget _customBottomNavBarV2() {
    return Container(
      height: 72,
      color: neutral100,
      child: Consumer<MainScreenProvider>(
        builder: (context, value, child) => SizedBox(
          height: 50,
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: primaryColor,
                    padding: const EdgeInsets.only(),
                    shape: const CircleBorder(),
                  ),
                  // child: Icon(
                  //   NerdVPNIcon.home,
                  //   color: value.pageIndex == 0
                  //       ? Theme.of(context).primaryColor
                  //       : grey,
                  // ),
                  child: Image.asset(
                    'assets/images/bottomNav/home_icon3x.png',
                    scale: 3,
                    color: value.pageIndex == 0
                        ? Theme.of(context).primaryColor
                        : neutral500,
                  ),
                  onPressed: () {
                    value.pageIndex = 0;
                  },
                ),
              ),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: primaryColor,
                    padding: const EdgeInsets.only(),
                    shape: const CircleBorder(),
                  ),
                  // child: Icon(
                  //   NerdVPNIcon.gift,
                  //   color: value.pageIndex == 1
                  //       ? Theme.of(context).primaryColor
                  //       : grey,
                  // ),
                  child: Image.asset(
                    'assets/images/bottomNav/premium_icon3x.png',
                    scale: 3,
                    color: value.pageIndex == 1
                        ? Theme.of(context).primaryColor
                        : neutral500,
                  ),
                  onPressed: () {
                    value.pageIndex = 1;
                  },
                ),
              ),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: primaryColor,
                    padding: const EdgeInsets.only(),
                    shape: const CircleBorder(),
                  ),
                  child: Image.asset(
                    'assets/images/bottomNav/setting_icon3x.png',
                    scale: 3,
                    color: value.pageIndex == 2
                        ? Theme.of(context).primaryColor
                        : neutral500,
                  ),
                  onPressed: () {
                    value.pageIndex = 2;
                  },
                ),
              ),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: primaryColor,
                    padding: const EdgeInsets.only(),
                    shape: const CircleBorder(),
                  ),
                  child: Image.asset(
                    'assets/images/bottomNav/profile_icon3x.png',
                    scale: 3,
                    color: value.pageIndex == 3
                        ? Theme.of(context).primaryColor
                        : neutral500,
                  ),
                  onPressed: () {
                    value.pageIndex = 3;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _customBottomNavBar() {
  //   return CustomCard(
  //     margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //     radius: 20,
  //     backgroundColor: Colors.white.withOpacity(1),
  //     child: Stack(
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(10),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Center(
  //                 child: Container(
  //                   margin: const EdgeInsets.only(bottom: 5),
  //                   width: 50,
  //                   height: 2,
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(10),
  //                     color: Colors.grey.shade300,
  //                   ),
  //                 ),
  //               ),
  //               Consumer<MainScreenProvider>(
  //                 builder: (context, value, child) => SizedBox(
  //                   height: 50,
  //                   child: Row(
  //                     children: [
  //                       Expanded(
  //                         child: TextButton(
  //                           style: TextButton.styleFrom(
  //                             foregroundColor: primaryColor,
  //                             padding: const EdgeInsets.only(),
  //                             shape: const CircleBorder(),
  //                           ),
  //                           child: Icon(
  //                             NerdVPNIcon.home,
  //                             color: value.pageIndex == 0
  //                                 ? Theme.of(context).primaryColor
  //                                 : grey,
  //                           ),
  //                           onPressed: () {
  //                             value.pageIndex = 0;
  //                           },
  //                         ),
  //                       ),
  //                       Expanded(
  //                         child: TextButton(
  //                           style: TextButton.styleFrom(
  //                             foregroundColor: primaryColor,
  //                             padding: const EdgeInsets.only(),
  //                             shape: const CircleBorder(),
  //                           ),
  //                           child: Icon(
  //                             NerdVPNIcon.gift,
  //                             color: value.pageIndex == 1
  //                                 ? Theme.of(context).primaryColor
  //                                 : grey,
  //                           ),
  //                           onPressed: () {
  //                             value.pageIndex = 1;
  //                           },
  //                         ),
  //                       ),
  //                       Expanded(
  //                         child: TextButton(
  //                           style: TextButton.styleFrom(
  //                             foregroundColor: primaryColor,
  //                             padding: const EdgeInsets.only(),
  //                             shape: const CircleBorder(),
  //                           ),
  //                           child: Icon(
  //                             NerdVPNIcon.settings,
  //                             color: value.pageIndex == 2
  //                                 ? Theme.of(context).primaryColor
  //                                 : grey,
  //                           ),
  //                           onPressed: () {
  //                             value.pageIndex = 2;
  //                           },
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

class MainScreenProvider extends ChangeNotifier {
  int _curIndex = 0;

  int get pageIndex => _curIndex;
  set pageIndex(int value) {
    _curIndex = value;
    notifyListeners();
  }

  static MainScreenProvider instance(BuildContext context) =>
      Provider.of(context, listen: false);
}
