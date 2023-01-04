import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard(
      {Key? key,
      this.margin,
      this.padding,
      this.shadow,
      this.backgroundColor,
      this.child,
      this.radius})
      : super(key: key);
  final Widget? child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BoxShadow? shadow;
  final Color? backgroundColor;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(radius ?? 10),
        boxShadow: [
          shadow ??
              BoxShadow(
                blurRadius: 15,
                color: Colors.black.withOpacity(.1),
                offset: const Offset(0, 5),
              ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 10),
        child: Material(
          color: Colors.transparent,
          child: Padding(
              padding: padding ?? const EdgeInsets.only(),
              child: child ?? const SizedBox.shrink()),
        ),
      ),
    );
  }
}
