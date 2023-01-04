import 'package:flutter/material.dart';
import 'package:nizvpn/theme/color.dart';

class SignalLevel extends StatelessWidget {
  const SignalLevel({super.key, required this.level})
      : assert(level < 4, 'Signal level cannot greater than 3!');

  final int level;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(
            3,
            (index) => Container(
                  height: 6,
                  width: 6,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: level == 1 && index == level - 1
                          ? stateError
                          : level == 2 && index < level
                              ? stateWarning
                              : level == 3
                                  ? secondaryColor
                                  : neutral500),
                )).toList()
      ],
    );
  }
}
