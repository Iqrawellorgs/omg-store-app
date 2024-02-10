import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/images.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileBgWidget extends StatelessWidget {
  final Widget circularImage;
  final Widget mainWidget;
  final bool backButton;
  const ProfileBgWidget(
      {Key? key, required this.mainWidget, required this.circularImage, required this.backButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        // SizedBox(
        //   width: context.width,
        //   height: 200,
        //   // child: Center(
        //   //   child: Image.asset(Images.profileBg, height: 260, width: 1170, fit: BoxFit.fill),
        //   // ),
        // ),
        // backButton
        //     ? IconButton(
        //         icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).dividerColor, size: 20),
        //         onPressed: () => Get.back(),
        //       )
        //     : const SizedBox(),
        // Container(
        //   // width: 1170,
        //   decoration: BoxDecoration(
        //     borderRadius:
        //         const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge)),
        //     color: Theme.of(context).cardColor,
        //   ),
        // ),
        // Text(
        //   'My Profile'.tr,
        //   textAlign: TextAlign.center,
        //   style: robotoRegular.copyWith(
        //       fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).dividerColor),
        // ),

        circularImage,
      ]),
      Expanded(
        child: mainWidget,
      ),
    ]);
  }
}
