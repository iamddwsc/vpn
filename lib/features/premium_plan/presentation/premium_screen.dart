import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:nizvpn/features/premium_plan/model/subscription_model.dart';
import 'package:nizvpn/features/premium_plan/presentation/thank_screen.dart';
import 'package:nizvpn/theme/color.dart';

import '../../../common_widgets/custom_button.dart';
import '../../../common_widgets/custom_header.dart';

class PremiumPlan extends StatefulWidget {
  const PremiumPlan({super.key});

  @override
  State<PremiumPlan> createState() => _PremiumPlanState();
}

class _PremiumPlanState extends State<PremiumPlan> {
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    List<SubscriptionModel> list = [
      SubscriptionModel(type: '1-Year', price: 99.99),
      SubscriptionModel(type: '6-Months', price: 49.99),
      SubscriptionModel(type: '1-Month', price: 12.99),
    ];
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size(double.infinity, kToolbarHeight),
          child: MyCustomHeader(
            title: 'MasterVPN Premium',
            hasBackButton: false,
            leftWidget: SizedBox.shrink(),
            rightWidget: SizedBox.shrink(),
          )),
      body: SingleChildScrollView(
        // width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 22),
              child: Text(
                'go_premium_desc1'.tr(),
                textAlign: TextAlign.center,
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: PlanItem(
                    type: list[index].type!,
                    price: list[index].price!,
                    isBestValue: index == 0,
                    save: index == 0
                        ? (100 - (99.99 / (12 * 12.99)) * 100)
                            .round()
                            .toString()
                        : null,
                    isSelected: _selectedIndex == index,
                  ),
                );
              },
            ),
            // const Spacer(),
            if (_selectedIndex != -1)
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
                  child: CustomButton(
                    customHeight: 54,
                    text: 'continue'.tr(),
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.white),
                    backgroundColor: primaryColor,
                    boderRadius: BorderRadius.circular(30),
                    toUpperCase: false,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ThankScreen()));
                    },
                  )),
            //  PlanItem(
            //   type: '6-Months',
            //   price: 49.99,
            //   // save: (100 - (99.99 / (12 * 12.99)) * 100).round().toString(),
            // ),
            // Container(
            //   margin: const EdgeInsets.symmetric(horizontal: 16),
            //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            //   decoration: BoxDecoration(
            //       border: Border.all(color: background),
            //       borderRadius: BorderRadius.circular(20)),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Row(
            //         children: [
            //           Text(
            //             '6-Months'.tr(),
            //             style: TextStyle(
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.w700,
            //                 color: background),
            //           ),
            //           const Spacer(),
            //           Container(
            //               height: 24,
            //               width: 24,
            //               decoration: BoxDecoration(
            //                   shape: BoxShape.circle, color: primaryColor),
            //               child: Image.asset(
            //                 'assets/images/premium/done_icon3x.png',
            //                 scale: 3,
            //                 // color: Colors.white,
            //               ))
            //         ],
            //       ),
            //       Text(
            //         '\$ 49,99',
            //         style: TextStyle(fontSize: 16, color: gray900),
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(
            //   height: 16,
            // ),
            // Container(
            //   margin: const EdgeInsets.symmetric(horizontal: 16),
            //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            //   decoration: BoxDecoration(
            //       border: Border.all(color: background),
            //       borderRadius: BorderRadius.circular(20)),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Row(
            //         children: [
            //           Text(
            //             '1-Months'.tr(),
            //             style: TextStyle(
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.w700,
            //                 color: background),
            //           ),
            //           const Spacer(),
            //           Container(
            //               height: 24,
            //               width: 24,
            //               decoration: BoxDecoration(
            //                   shape: BoxShape.circle, color: primaryColor),
            //               child: Image.asset(
            //                 'assets/images/premium/done_icon3x.png',
            //                 scale: 3,
            //                 // color: Colors.white,
            //               ))
            //         ],
            //       ),
            //       Text(
            //         '\$ 12,99',
            //         style: TextStyle(fontSize: 16, color: gray900),
            //       ),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

class PlanItem extends StatelessWidget {
  const PlanItem(
      {Key? key,
      required this.type,
      required this.price,
      this.save,
      this.isBestValue = false,
      this.isSelected = false})
      : super(key: key);

  final String type;
  final double price;
  final String? save;
  final bool isBestValue;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      type.tr(),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: primaryColor),
                    ),
                    // const Spacer(),

                    Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                            border: isSelected
                                ? null
                                : Border.all(color: neutral900, width: 2),
                            shape: BoxShape.circle,
                            color:
                                isSelected ? primaryColor : Colors.transparent),
                        child: isSelected
                            ? Image.asset(
                                'assets/images/premium/done_icon3x.png',
                                scale: 3,
                                // color: Colors.white,
                              )
                            : const SizedBox.shrink())
                  ],
                ),
                Text(
                  '\$ $price',
                  style: TextStyle(fontSize: 16, color: gray900),
                ),
                const SizedBox(
                  height: 5,
                ),
                if (save != null)
                  Container(
                    decoration: BoxDecoration(
                        color: stateError,
                        borderRadius: BorderRadius.circular(10)),
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                    child: Text(
                      'Save $save%',
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
          isBestValue
              ? Container(
                  padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
                  decoration: const BoxDecoration(
                      // border: Border.all(color: primaryColor),
                      color: primaryColor,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(19))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Best value!',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            'Yearly subscription - biggest savings',
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ],
                      ),
                      // const Spacer(),
                      Image.asset(
                        'assets/images/premium/best_price3x.png',
                        scale: 3,
                      )
                    ],
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
