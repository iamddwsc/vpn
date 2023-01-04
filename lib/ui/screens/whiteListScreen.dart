import 'package:device_apps/device_apps.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../../core/utils/preferences.dart';
import '../components/customDivider.dart';

class WhiteListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(LineIcons.angleLeft),
            onPressed: () => Navigator.pop(context)),
        elevation: 0,
        title: Text('whitelist_page'.tr()),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: FutureBuilder<List<Application>>(
                    initialData: const [],
                    future: DeviceApps.getInstalledApplications(
                        includeAppIcons: true,
                        includeSystemApps: true,
                        onlyAppsWithLaunchIntent: true),
                    builder: (contextPkg, snapshotPkg) {
                      if (snapshotPkg.connectionState ==
                          ConnectionState.waiting) {
                        return Container(
                          height: 300,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        );
                      }
                      if (snapshotPkg.hasData && snapshotPkg.data!.isNotEmpty) {
                        return _preferenceFuture(snapshotPkg);
                      } else {
                        return Container(
                          alignment: Alignment.center,
                          height: 300,
                          child: Text('no_app_detected'.tr()),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // bottomNavigationBar: AdsProvider.adbottomSpace(),
    );
  }

  FutureBuilder<Preferences> _preferenceFuture(
      AsyncSnapshot<List<Application>> snapshotPkg) {
    return FutureBuilder<Preferences>(
      future: Preferences.init(),
      builder: (contextPref, snapshotPref) {
        if (snapshotPref.hasData) {
          snapshotPkg.data!.sort((a, b) => a.appName.compareTo(b.appName));
          return Column(
            children: snapshotPkg.data!
                .map(
                  (e) => AppListItem(
                    application: e as ApplicationWithIcon?,
                    initialValue: snapshotPref.data!.whitePackages
                        .contains(e.packageName),
                  ),
                )
                .toList()
                .cast(),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class AppListItem extends StatefulWidget {
  const AppListItem({
    Key? key,
    this.application,
    this.initialValue = false,
  }) : super(key: key);

  final ApplicationWithIcon? application;
  final bool initialValue;

  @override
  _AppListItemState createState() => _AppListItemState();
}

class _AppListItemState extends State<AppListItem> {
  bool _whited = false;

  @override
  void initState() {
    _whited = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SwitchListTile(
          value: _whited,
          title: Row(
            children: [
              Image.memory(
                widget.application!.icon,
                height: 50,
                width: 50,
              ),
              const RowDivider(),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(widget.application!.appName),
                  Text(
                    widget.application!.packageName,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              )),
            ],
          ),
          onChanged: status,
        ),
        const Divider(),
      ],
    );
  }

  Future status(bool value) {
    return Preferences.init().then((shared) async {
      if (value) {
        await shared.saveWhitePages(
            shared.whitePackages..add(widget.application!.packageName));
      } else {
        await shared.saveWhitePages(shared.whitePackages
          ..removeWhere(
              (element) => element == widget.application!.packageName));
      }
      setState(() {
        _whited = value;
      });
    });
  }
}
