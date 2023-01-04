import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingWidget extends StatelessWidget {
  const RatingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'rate_us'.tr(),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          RatingBar.builder(
            initialRating: 0,
            minRating: 0,
            allowHalfRating: false,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4),
            itemBuilder: (context, _) => Image.asset(
              'assets/images/home/star3x.png',
              scale: 3,
            ),
            onRatingUpdate: (rating) {
              debugPrint('===== $rating');
            },
            itemSize: 16,
          ),
        ],
      ),
    );
  }
}
