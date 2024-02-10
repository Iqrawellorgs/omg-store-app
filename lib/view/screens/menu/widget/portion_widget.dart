import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/theme_controller.dart';

class PortionWidget extends StatelessWidget {
  final String icon;
  final String title;
  final bool hideDivider;
  final String? route;
  final String? suffix;
  final Function()? onTap;
  PortionWidget({
    Key? key,
    required this.icon,
    required this.title,
    this.route,
    this.hideDivider = true,
    this.suffix,
    this.onTap,
  }) : super(key: key);
  final ThemeController themeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () => Get.toNamed(route!),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: Column(children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Image.asset(
                  icon,
                  height: 16,
                  width: 16,
                  color: themeController.darkTheme ? Colors.white : Theme.of(context).disabledColor,
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Expanded(
                  child: Text(title,
                      style: senRegular.copyWith(fontSize: Dimensions.fontSizeDefault))),
              suffix != null
                  ? Container(
                      decoration: BoxDecoration(
                        color: themeController.darkTheme
                            ? Colors.yellow
                            : Theme.of(context).colorScheme.error,
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.paddingSizeExtraSmall,
                          horizontal: Dimensions.paddingSizeSmall),
                      child: Text(suffix!,
                          style: senRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).cardColor)),
                    )
                  : const SizedBox(),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              const Icon(Icons.arrow_forward_ios, size: 15, color: Colors.grey),
            ],
          ),
          hideDivider ? const SizedBox() : const Divider()
        ]),
      ),
    );
  }
}
