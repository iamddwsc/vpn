import 'package:flutter/material.dart';

import '../../../theme/color.dart';

class SettingSelection extends StatelessWidget {
  const SettingSelection({
    super.key,
    required this.type,
    required this.value,
    required this.groupValue,
    required this.onTap,
  });

  final String type;
  final int value;
  final int groupValue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Row(
        children: [
          Text(
            type,
            style: TextStyle(fontWeight: FontWeight.w600, color: background),
          ),
          const Spacer(),
          Radio<int>(
            fillColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return primaryColor;
              }
              return neutral900;
            }),
            value: value,
            groupValue: groupValue,
            onChanged: (value) {
              onTap();
            },
          )
        ],
      ),
    );
  }
}
