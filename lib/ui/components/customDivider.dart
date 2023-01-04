import 'package:flutter/material.dart';

class RowDivider extends StatelessWidget {
  const RowDivider({Key? key, this.space}) : super(key: key);
  final double? space;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: space ?? 10,
    );
  }
}

class ColumnDivider extends StatelessWidget {
  const ColumnDivider({Key? key, this.space}) : super(key: key);
  final double? space;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: space ?? 10,
    );
  }
}
