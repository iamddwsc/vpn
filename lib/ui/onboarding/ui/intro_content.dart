import 'package:flutter/material.dart';

import '../model/page_view_model.dart';

class IntroContent extends StatelessWidget {
  const IntroContent({Key? key, required this.page, this.isFullScreen = false})
      : super(key: key);
  final PageViewModel page;
  final bool isFullScreen;

  Widget _buildWidget(Widget? widget, String? text, TextStyle style) {
    return widget ?? Text(text!, style: style, textAlign: TextAlign.center);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: page.decoration.contentMargin,
      decoration: isFullScreen
          ? page.decoration.boxDecoration ??
              BoxDecoration(
                color: page.decoration.pageColor,
                borderRadius: BorderRadius.circular(8.0),
              )
          : null,
      child: Column(
        children: [
          Padding(
            padding: page.decoration.titlePadding,
            child: _buildWidget(
              page.titleWidget,
              page.title,
              page.decoration.titleTextStyle,
            ),
          ),
          Container(
            padding: page.decoration.bodyPadding,
            child: _buildWidget(
              page.bodyWidget,
              page.body,
              page.decoration.bodyTextStyle,
            ),
          ),
          if (page.footer != null)
            Padding(
              padding: page.decoration.footerPadding,
              child: page.footer,
            ),
        ],
      ),
    );
  }
}
