import 'dart:async';
import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nizvpn/core/utils/NizVPN.dart';
import 'package:nizvpn/core/utils/preferences.dart';
import 'package:nizvpn/features/home/utils/int_to_time.dart';

import '../../../theme/color.dart';

const Duration kInitialTime = Duration(seconds: 900);
const int kExtraTime = 5;

class CountDownTimer extends StatefulWidget {
  const CountDownTimer(
      {Key? key,
      required this.onCompleted,
      required this.isConnected,
      this.onUpdate})
      : super(key: key);
  final VoidCallback onCompleted;
  final Function(Duration)? onUpdate;
  final bool isConnected;

  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<CountDownTimer> {
  AnimationController? _controller;
  Timer? _timer;
  int? _elapsed;
  Duration? clockTimer;
  Duration? remainingTime;
  // CountDownController z = CountDownController();

  @override
  void initState() {
    super.initState();
    // AnimationController
    getRemainingTime();
  }

  void getRemainingTime() async {
    var p = await Preferences.init();
    remainingTime = Duration(seconds: p.remainingTimeUse);
  }

  void increaseTime([int extraTime = kExtraTime]) {
    // uncomplete function
    _controller!.duration =
        Duration(seconds: _controller!.duration!.inSeconds + extraTime);
    _controller!.reset();
    _controller!.forward(from: _elapsed! / _controller!.duration!.inSeconds);
    // _elapsed = _elapsed! + extraTime;
  }

  @override
  void dispose() {
    if (_controller != null) _controller!.dispose();
    if (_timer != null) _timer!.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CountDownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isConnected != oldWidget.isConnected &&
        widget.isConnected == true) {
      _controller = AnimationController(vsync: this, duration: remainingTime);
      _controller!.addListener(() => setState(() {}));
      // _controller!.addStatusListener(
      //   (status) {
      //     if (status == AnimationStatus.completed) {
      //       _timer!.cancel();
      //       widget.onCompleted();
      //     }
      //   },
      // );

      // Elapsed Counter
      _elapsed = 0;
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => setState(() {
          if (_elapsed! < _controller!.duration!.inSeconds) {
            _elapsed = _elapsed! + 1;
            widget.onUpdate!(Duration(seconds: _elapsed!));
          } else {
            NVPN.stopVpn();
            _timer!.cancel();
          }
        }),
      );

      // Launch the Controller
      _controller!.forward();
    } else if (widget.isConnected != oldWidget.isConnected &&
        widget.isConnected == false) {
      _timer!.cancel();
      _controller!.dispose();
      _elapsed = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_elapsed != null) {
      clockTimer =
          Duration(seconds: _controller!.duration!.inSeconds - _elapsed!);
    }
    return FutureBuilder<Preferences>(
        future: Preferences.init(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Future.delayed(const Duration(seconds: 0)).then((value) =>
                remainingTime =
                    Duration(seconds: snapshot.data!.remainingTimeUse));
          }
          return Container(
            color: neutral300,
            height: 40,
            padding:
                EdgeInsets.only(left: widget.isConnected ? 6 : 16, right: 16),
            child: Row(children: [
              if (!widget.isConnected)
                Image.asset(
                  'assets/images/home/info3x.png',
                  scale: 3,
                ),
              if (!widget.isConnected)
                const SizedBox(
                  width: 8,
                ),
              if (widget.isConnected)
                AnimatedBuilder(
                    animation: _controller!,
                    builder: (context, child) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Align(
                                alignment: FractionalOffset.center,
                                child: AspectRatio(
                                  aspectRatio: 1.0,
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned.fill(
                                        // bottom: 1,
                                        top: 3,
                                        left: 3,
                                        child: AnimatedBuilder(
                                          animation: _controller!,
                                          builder: (context, child) {
                                            return CustomPaint(
                                                painter: CustomTimerPainter(
                                              animation: _controller!,
                                              backgroundColor: primaryColor100,
                                              color: primaryColor,
                                            ));
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              widget.isConnected
                  ? Text.rich(
                      TextSpan(
                          // text:
                          //     '${clockTimer!.inMinutes.remainder(60).toString()}:${clockTimer!.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                          text: clockTimer!.toTimeNonHour(),
                          style: TextStyle(
                              color: background,
                              fontSize: 12,
                              fontWeight: FontWeight.w700),
                          children: [
                            TextSpan(
                                text: 'connection_time_left'.tr(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400))
                          ]),
                    )
                  : Text(
                      'no_connected_time'.tr(),
                      style: const TextStyle(fontSize: 12),
                    ),
              const Spacer(),
              TextButton(onPressed: () {}, child: const Text('Test ping')),
              GestureDetector(
                onTap: increaseTime,
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/home/plus3x.png',
                      scale: 3,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      'add'.tr().toUpperCase(),
                      style: const TextStyle(
                        color: primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            ]),
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    required this.animation,
    required this.backgroundColor,
    required this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    size = const Size(18, 18);
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter oldDelegate) {
    return animation.value != oldDelegate.animation.value ||
        color != oldDelegate.color ||
        backgroundColor != oldDelegate.backgroundColor;
  }
}
