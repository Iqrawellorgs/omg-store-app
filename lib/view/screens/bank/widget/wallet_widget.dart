import 'package:efood_multivendor_restaurant/helper/price_converter.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/theme_controller.dart';

class WalletWidget extends StatelessWidget {
  final String title;
  final double? value;
  const WalletWidget({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xffFFFFFF),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade200.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3)),
              ]),
          height: 115,
          width: 156,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                PriceConverter.convertPrice(value),
                style: TextStyle(
                  fontFamily: "Sen",
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                title,
                style: TextStyle(
                  fontFamily: "Sen",
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Get.find<ThemeController>().darkTheme
                      ? Colors.white
                      : Theme.of(context).disabledColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
            ],
          ),
        ),
      ),

      //     Container(
      //   padding: const EdgeInsets.symmetric(
      //       vertical: Dimensions.paddingSizeLarge,
      //       horizontal: Dimensions.paddingSizeExtraSmall),
      //   decoration: BoxDecoration(
      //     color: Theme.of(context).cardColor,
      //     borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      //     boxShadow: [
      //       BoxShadow(
      //           color: Colors.grey[Get.isDarkMode ? 700 : 300]!,
      //           spreadRadius: 0.5,
      //           blurRadius: 5)
      //     ],
      //   ),
      //   alignment: Alignment.center,
      //   child: Column(children: [
      //     Text(
      //       PriceConverter.convertPrice(value),
      //       textDirection: TextDirection.ltr,
      //       style: robotoBold.copyWith(
      //           fontSize: Dimensions.fontSizeLarge,
      //           color: Theme.of(context).primaryColor),
      //     ),
      //     const SizedBox(height: Dimensions.paddingSizeSmall),
      //     Text(
      //       title,
      //       textAlign: TextAlign.center,
      //       style: robotoRegular.copyWith(
      //           fontSize: Dimensions.fontSizeSmall,
      //           color: Get.find<ThemeController>().darkTheme
      //               ? Colors.white
      //               : Theme.of(context).disabledColor),
      //     ),
      //   ]),
      // )
    );
  }
}
