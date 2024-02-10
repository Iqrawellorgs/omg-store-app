import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/theme_controller.dart';

class BottomNavItem extends StatelessWidget {
  final IconData iconData;
  final Function? onTap;
  final bool isSelected;
  const BottomNavItem(
      {Key? key, required this.iconData, this.onTap, this.isSelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: IconButton(
        icon: Icon(iconData,
            color: isSelected
                ? Theme.of(context).primaryColor
                : Get.find<ThemeController>().darkTheme
                    ? Colors.white
                    : Colors.grey,
            size: 25),
        onPressed: onTap as void Function()?,
      ),
    );
  }
}
