import 'package:dart_ping/dart_ping.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nizvpn/common_widgets/custom_button.dart';
import 'package:nizvpn/core/utils/preferences.dart';
import 'package:nizvpn/theme/color.dart';

import '../../../common_widgets/custom_header.dart';
import '../common_widget/setting_selection.dart';

class SettingDNS extends StatefulWidget {
  const SettingDNS({super.key});

  @override
  State<SettingDNS> createState() => _SettingDNSState();
}

class _SettingDNSState extends State<SettingDNS> {
  int _selected = 1;
  List<String> listDns = [];
  Future<List<String>>? listDnss;
  bool displayAdd = false;

  @override
  void initState() {
    super.initState();
    _retreiveDns();
  }

  void _retreiveDns([bool isInit = true]) async {
    listDnss = Preferences.init().then((value) => value.getDNS);
    isInit ? null : setState(() {});
  }

  void _deleteDns(String dns) async {
    Preferences.init().then((value) => value.removeDNS(dns));
    _retreiveDns();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size(double.infinity, kToolbarHeight),
            child: MyCustomHeader(
              title: 'dns'.tr(),
            )),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 0, 16),
          child: Column(
            children: [
              SettingSelection(
                type: 'default'.tr(),
                value: 1,
                groupValue: _selected,
                onTap: () {
                  setState(() {
                    _selected = 1;
                  });
                },
              ),
              SettingSelection(
                type: 'custom'.tr(),
                value: 2,
                groupValue: _selected,
                onTap: () {
                  setState(() {
                    _selected = 2;
                  });
                },
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: FutureBuilder<List<String>>(
                  future: listDnss,
                  builder: (context, snapshot) {
                    if (_selected == 2) {
                      if (snapshot.data!.isEmpty) {
                        return DnsInput(retreiveDns: _retreiveDns);
                      } else {
                        var data = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/setting/dns_icon3x.png',
                                            scale: 3,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                              child: Text(
                                            data[index],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12,
                                                color: background),
                                          )),
                                          CustomButton(
                                            type: ButtonType.icon,
                                            icon: Image.asset(
                                              'assets/images/setting/remove_3x.png',
                                              scale: 3,
                                            ),
                                            onPressed: () =>
                                                _deleteDns(data[index]),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 16),
                                        child: Divider(
                                          color: neutral500,
                                          height: 1,
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            ),
                            if (displayAdd)
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: DnsInput(retreiveDns: _retreiveDns),
                              ),
                            if (!displayAdd)
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: CustomButton(
                                  type: ButtonType.text,
                                  text: 'dns_add_more'.tr(),
                                  textStyle: TextStyle(
                                      fontSize: 12,
                                      color: background,
                                      fontWeight: FontWeight.w700),
                                  buttonTextPadding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  onPressed: () => setState(() {
                                    displayAdd = true;
                                  }),
                                ),
                              )
                          ],
                        );
                      }
                    }
                    return const SizedBox.shrink();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DnsItem extends StatelessWidget {
  const DnsItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DnsInput extends StatefulWidget {
  const DnsInput({super.key, required this.retreiveDns});

  final Function retreiveDns;

  @override
  State<DnsInput> createState() => _DnsInputState();
}

class _DnsInputState extends State<DnsInput> {
  late TextEditingController controller;
  String? errorMessage;
  bool _valid = true;
  bool _enableAction = true;
  bool duplicateDns = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  void _checkDns(String dns) async {
    setState(() {
      _enableAction = false;
    });
    if ('.'.allMatches(dns).length == 3) {
      final ping = Ping(dns, count: 4);
      // Begin ping process and listen for output
      ping.stream.listen((event) {
        if (event.error != null) {
          errorMessage = event.error?.error.message;
        } else if (event.response != null) {
          errorMessage = null;
        }
      }).onDone(() async {
        await ping.stop();
        _enableAction = true;
        if (errorMessage == null) {
          _valid = true;
          var p = await Preferences.init();
          if (!p.getDNS.contains(dns)) {
            p.saveDNS(dns);
            widget.retreiveDns(false);
          } else {
            _valid = false;
            duplicateDns = true;
          }
        } else {
          _valid = false;
        }
        setState(() {});
      });
    } else {
      Future.delayed(
          const Duration(milliseconds: 500),
          () => setState(() {
                _enableAction = true;
                _valid = false;
              }));
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 24),
      child: Column(
        children: [
          TextField(
            style: const TextStyle(fontSize: 14),
            controller: controller,
            cursorColor: background,
            decoration: InputDecoration(
                isDense: true,
                hintText: 'dns_hint'.tr(),
                hintStyle: TextStyle(fontSize: 12, color: gray500),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: background),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(10.0))),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: background),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(10.0)))),
            onChanged: (text) {
              if (!_valid) {
                setState(() {
                  _valid = true;
                });
              }
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IgnorePointer(
                ignoring: !_enableAction,
                child: CustomButton(
                  type: ButtonType.text,
                  text: _enableAction
                      ? _valid
                          ? 'dns_add_server'.tr()
                          : duplicateDns
                              ? 'dns_duplicate'.tr()
                              : 'dns_error'.tr()
                      : 'checking'.tr(),
                  textStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: _enableAction
                          ? _valid
                              ? FontWeight.w700
                              : FontWeight.w400
                          : FontWeight.w700,
                      color: _enableAction
                          ? _valid
                              ? background
                              : stateError
                          : gray500),
                  buttonTextPadding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                  onPressed: () => _checkDns(controller.text),
                ),
              ),
              CustomButton(
                type: ButtonType.text,
                text: 'cancel'.tr(),
                textStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: stateError),
                buttonTextPadding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                onPressed: () => setState(() {
                  // _selected = 1;
                  controller.text = '';
                  errorMessage = null;
                  _valid = true;
                  _enableAction = true;
                }),
              )
            ],
          )
        ],
      ),
    );
  }
}
