import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nizvpn/ui/utils/global_variable.dart';

Widget loadingCupertino({double size = 16}) {
  return Center(
    child: Theme(
      data: ThemeData(
        cupertinoOverrideTheme: CupertinoThemeData(
          brightness: isLightMode ? Brightness.light : Brightness.dark,
        ),
      ),
      child: CupertinoActivityIndicator(
        radius: size,
      ),
    ),
  );
}
