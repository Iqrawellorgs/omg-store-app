import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool isBackButtonExist;
  final Function? onBackPressed;
  final Widget? menuWidget;
  final Color? backgroundColor;
  final bool isCenterTitle;
  final Color? titleColor;
  const CustomAppBar(
      {Key? key,
      this.title,
      this.onBackPressed,
      this.isBackButtonExist = true,
      this.menuWidget,
      this.backgroundColor,
      this.isCenterTitle = false,
      this.titleColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: backgroundColor ?? Theme.of(context).cardColor,
      title: Text(
        title!,
        style: TextStyle(
          fontFamily: "Sen",
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: titleColor,
        ),
      ),
      //  Text(
      //   title!,
      //   style: robotoRegular.copyWith(
      //     fontSize: Dimensions.fontSizeLarge,
      // color: Theme.of(context).textTheme.bodyLarge!.color,
      //   ),
      // ),
      centerTitle: isCenterTitle,
      leading: isBackButtonExist
          ? Container(
              margin: const EdgeInsets.only(left: 15),
              padding: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 236, 240, 244),
              ),
              child: Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () => onBackPressed != null ? onBackPressed!() : Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
              ),
            )
          : const SizedBox(),
      // backgroundColor: Theme.of(context).cardColor,
      // surfaceTintColor: Colors.transparent,
      elevation: 0,
      actions: menuWidget != null ? [menuWidget!] : null,
    );
  }

  @override
  Size get preferredSize => Size(1170, GetPlatform.isDesktop ? 70 : 50);
}
