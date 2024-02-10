import 'package:efood_multivendor_restaurant/controller/theme_controller.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/images.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CountWidget extends StatelessWidget {
  final String title;
  final int? count;
  CountWidget({Key? key, required this.title, required this.count}) : super(key: key);
  ThemeController themeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: Column(children: [
          Text(title,
              style: senRegular.copyWith(
                  fontSize: Dimensions.fontSizeExtraSmall,
                  color: themeController.darkTheme ? Colors.white : Theme.of(context).cardColor)),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(Images.order,
                color: themeController.darkTheme ? Colors.white : Theme.of(context).cardColor,
                height: 12,
                width: 12),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
            Text(count.toString(),
                style: senMedium.copyWith(
                  fontSize: Dimensions.fontSizeExtraLarge,
                  color: themeController.darkTheme ? Colors.white : Theme.of(context).cardColor,
                )),
          ]),
        ]),
      ),
    );
  }
}
