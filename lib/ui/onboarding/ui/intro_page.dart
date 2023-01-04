import 'package:flutter/material.dart';
import 'package:nizvpn/ui/onboarding/helper.dart';

import '../model/page_view_model.dart';
import 'intro_content.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({
    Key? key,
    required this.page,
    this.scrollController,
    required this.isTopSafeArea,
    required this.isBottomSafeArea,
  }) : super(key: key);
  final PageViewModel page;
  final ScrollController? scrollController;
  final bool isTopSafeArea;
  final bool isBottomSafeArea;

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Widget _buildStack() {
    final content = IntroContent(page: widget.page, isFullScreen: true);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        if (widget.page.image != null) widget.page.image!,
        Positioned.fill(
          child: Column(
            children: [
              ...[
                Spacer(flex: widget.page.decoration.imageFlex),
                Expanded(
                  flex: widget.page.decoration.bodyFlex,
                  child: widget.page.useScrollView
                      ? SingleChildScrollView(
                          controller: widget.scrollController,
                          physics: const BouncingScrollPhysics(),
                          child: content,
                        )
                      : content,
                ),
              ].asReversed(widget.page.reverse),
              const SafeArea(top: false, child: SizedBox(height: 60.0)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFlex(BuildContext context) {
    return Container(
      color: widget.page.decoration.pageColor,
      padding: const EdgeInsets.only(bottom: 145),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.page.image != null)
            Align(
              alignment: widget.page.decoration.imageAlignment,
              child: widget.page.image,
            ),
          Align(
            alignment: widget.page.decoration.bodyAlignment,
            child: widget.page.useScrollView
                ? SingleChildScrollView(
                    controller: widget.scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: IntroContent(page: widget.page),
                  )
                : IntroContent(page: widget.page),
          ),
          // const SizedBox(
          //   height: 32,
          // )
        ].asReversed(widget.page.reverse),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (widget.page.decoration.fullScreen) {
      return _buildStack();
    }
    return SafeArea(
      top: widget.isTopSafeArea,
      bottom: widget.isBottomSafeArea,
      child: _buildFlex(context),
    );
  }
}
