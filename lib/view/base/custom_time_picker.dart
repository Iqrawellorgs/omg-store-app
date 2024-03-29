import 'package:efood_multivendor_restaurant/controller/splash_controller.dart';
import 'package:efood_multivendor_restaurant/helper/date_converter.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/theme_controller.dart';

class CustomTimePicker extends StatefulWidget {
  final String title;
  final String? time;
  final Function(String?) onTimeChanged;
  const CustomTimePicker(
      {Key? key, required this.title, required this.time, required this.onTimeChanged})
      : super(key: key);

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  String? _myTime;

  @override
  void initState() {
    super.initState();

    _myTime = widget.time;
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        widget.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: senRegular.copyWith(
            fontSize: Dimensions.fontSizeSmall,
            color: Get.find<ThemeController>().darkTheme
                ? Colors.white
                : Theme.of(context).dividerColor),
      ),
      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
      InkWell(
        onTap: () async {
          TimeOfDay? time = await showTimePicker(
            initialEntryMode: TimePickerEntryMode.input,
            context: context,
            initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
            builder: (BuildContext context, Widget? child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  alwaysUse24HourFormat:
                      Get.find<SplashController>().configModel!.timeformat == '24',
                ),
                child: child!,
              );
            },
          );
          if (time != null) {
            setState(() {
              _myTime = DateConverter.convertTimeToTime(
                  DateTime(DateTime.now().year, 1, 1, time.hour, time.minute));
            });
            widget.onTimeChanged(_myTime);
          }
        },
        child: Container(
          height: 50,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[Get.isDarkMode ? 800 : 200]!,
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Row(
            children: [
              Text(
                _myTime != null ? DateConverter.convertStringTimeToTime(_myTime!) : 'pick_time'.tr,
                style: senRegular.copyWith(fontSize: _myTime != null ? 16 : 14),
                maxLines: 1,
              ),
              const Expanded(child: SizedBox()),
              const Icon(Icons.access_time, size: 20),
            ],
          ),
        ),
      ),
    ]);
  }
}
