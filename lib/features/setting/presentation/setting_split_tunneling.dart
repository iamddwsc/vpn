import 'package:device_apps/device_apps.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nizvpn/common_widgets/custom_button.dart';
import 'package:nizvpn/theme/color.dart';

import '../../../common_widgets/custom_header.dart';
import '../../../core/utils/preferences.dart';

class SettingSplitTunneling extends StatefulWidget {
  const SettingSplitTunneling({super.key});

  @override
  State<SettingSplitTunneling> createState() => _SettingSplitTunnelingState();
}

class _SettingSplitTunnelingState extends State<SettingSplitTunneling> {
  List<ApplicationWithIcon>? allApps;
  final List<ApplicationWithIcon> whiteApps = [];

  List<Uint8List> allIcons = [];
  List<Uint8List> whiteIcons = [];

  bool renderFlag = true;
  final _keyAllApps = GlobalKey<AnimatedListState>();
  final _keyTrustedApps = GlobalKey<AnimatedListState>();
  bool enableAction = true;

  @override
  void initState() {
    super.initState();
    getInstalledApp();
  }

  void getInstalledApp() async {
    List<ApplicationWithIcon> tempAllApps = [];
    allApps = (await DeviceApps.getInstalledApplications(
            onlyAppsWithLaunchIntent: true,
            includeAppIcons: true,
            includeSystemApps: true))
        .map((e) => e as ApplicationWithIcon)
        .toList();
    allApps!.sort((a, b) => a.appName.compareTo(b.appName));
    List<String> localWhiteList = (await Preferences.init()).whitePackages;
    for (var i in allApps!) {
      if (localWhiteList.contains(i.packageName)) {
        whiteApps.add(i);
        whiteIcons.add(i.icon);
      } else {
        tempAllApps.add(i);
      }
    }
    allApps = tempAllApps;
    allIcons = allApps!.map((e) => e.icon).toList();
    setState(() {
      renderFlag = false;
    });
  }

  void _addItem(
      ApplicationWithIcon app, GlobalKey<AnimatedListState> key) async {
    // print(allApps!
    //     .map((e) => e.appName.compareTo(app.appName))
    //     .toList()
    //     .indexOf(1));
    var p = await Preferences.init();
    int insertIdx;
    if (key == _keyAllApps) {
      insertIdx = allApps!
          .map((e) => e.appName.compareTo(app.appName))
          .toList()
          .indexOf(1);
      if (insertIdx == -1) {
        allApps!.add(app);
        allIcons.add(app.icon);
        insertIdx = allApps!.length - 1;
      } else {
        allApps!.insert(insertIdx, app);
        allIcons.insert(insertIdx, app.icon);
      }

      p.saveWhitePages(p.whitePackages..remove(app.packageName));
    } else {
      insertIdx = 0;
      whiteApps.insert(0, app);
      whiteIcons.insert(0, app.icon);

      p.saveWhitePages(p.whitePackages..add(app.packageName));
      if (whiteApps.length < 2) {
        setState(() {});
      }
    }
    key.currentState!
        .insertItem(insertIdx, duration: const Duration(milliseconds: 500));
    setState(() {
      enableAction = true;
    });
  }

  void _removeItem(int index, GlobalKey<AnimatedListState> key) {
    if (enableAction) {
      setState(() {
        enableAction = false;
      });
      ApplicationWithIcon removedItem;
      Uint8List removedIcon;
      if (key == _keyAllApps) {
        removedItem = allApps![index];
        removedIcon = allIcons[index];
        allApps!.removeAt(index);
        allIcons.removeAt(index);
      } else {
        removedItem = whiteApps[index];
        removedIcon = whiteIcons[index];
        whiteApps.removeAt(index);
        whiteIcons.removeAt(index);
        if (whiteApps.length < 2) {
          setState(() {});
        }
      }
      key.currentState!.removeItem(
          index,
          (context, animation) => AppListItem(
                application: removedItem,
                icon: removedIcon,
                onTap: () {},
                animation: animation,
              ),
          duration: const Duration(milliseconds: 500));
      _addItem(removedItem, key == _keyAllApps ? _keyTrustedApps : _keyAllApps);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: MyCustomHeader(
            title: 'split_tunneling'.tr(),
            rightImageButton: 'assets/images/search_icon3x.png',
            rightButtonAction: () {
              debugPrint('===== right button action');
            },
          )),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Builder(builder: (context) {
              if (renderFlag) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedSize(
                    // alignment: Alignment.center,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,

                    child: SizedBox(
                      height: whiteApps.isNotEmpty ? 17 : 0,
                      child: Text(
                        'trusted_apps'.tr(),
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: gray800),
                      ),
                    ),
                  ),
                  AnimatedList(
                    key: _keyTrustedApps,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    initialItemCount: whiteApps.length,
                    itemBuilder: (context, index, animation) {
                      if (whiteApps.isEmpty) return const SizedBox.shrink();
                      return AppListItem(
                          icon: whiteIcons[index],
                          application: whiteApps[index],
                          onTap: () => _removeItem(index, _keyTrustedApps),
                          animation: animation,
                          isWhiteApp: true);
                    },
                  ),
                  Text(
                    'all_apps'.tr(),
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: gray800),
                  ),
                  AnimatedList(
                      key: _keyAllApps,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      initialItemCount: allApps!.length,
                      itemBuilder: (context, index, animation) {
                        return AppListItem(
                          icon: allIcons[index],
                          application: allApps![index],
                          onTap: () => _removeItem(index, _keyAllApps),
                          animation: animation,
                        );
                      })
                ],
              );
            })),
      ),
    );
  }
}

class AppListItem extends StatelessWidget {
  const AppListItem(
      {Key? key,
      this.application,
      required this.onTap,
      required this.animation,
      required this.icon,
      this.isWhiteApp = false})
      : super(key: key);
  final ApplicationWithIcon? application;
  final Uint8List icon;
  final VoidCallback onTap;
  final Animation<double> animation;
  final bool isWhiteApp;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      child: buildWidget(),
    );
  }

  Row buildWidget() {
    return Row(
      children: [
        Container(
            height: 22,
            width: 22,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(200),
              child: Image.memory(
                icon,
              ),
            )),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                application!.appName,
                style:
                    TextStyle(fontWeight: FontWeight.w600, color: background),
              ),
            ],
          ),
        ),
        // const Spacer(),
        CustomButton(
          type: ButtonType.icon,
          icon: Image.asset(
            isWhiteApp
                ? 'assets/images/setting/remove_3x.png'
                : 'assets/images/setting/add_3x.png',
            scale: 3,
          ),
          onPressed: onTap,
        )
      ],
    );
  }
}
