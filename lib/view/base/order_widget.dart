import 'package:efood_multivendor_restaurant/controller/theme_controller.dart';
import 'package:efood_multivendor_restaurant/data/model/response/order_model.dart';
import 'package:efood_multivendor_restaurant/helper/date_converter.dart';
import 'package:efood_multivendor_restaurant/helper/route_helper.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/screens/order/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderWidget extends StatelessWidget {
  final OrderModel orderModel;
  final bool hasDivider;
  final bool isRunning;
  final bool showStatus;
  OrderWidget(
      {Key? key,
      required this.orderModel,
      required this.hasDivider,
      required this.isRunning,
      this.showStatus = false})
      : super(key: key);
  ThemeController themeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(RouteHelper.getOrderDetailsRoute(orderModel.id),
          arguments: OrderDetailsScreen(
            orderModel: orderModel,
            isRunningOrder: isRunning,
          )),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${'order_id'.tr}: #${orderModel.id}', style: senMedium),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              Row(children: [
                Text(
                  DateConverter.dateTimeStringToDateTime(orderModel.createdAt!),
                  style: senRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: themeController.darkTheme
                          ? Colors.white
                          : Theme.of(context).disabledColor),
                ),
                Container(
                  height: 10,
                  width: 1,
                  color: themeController.darkTheme ? Colors.white : Theme.of(context).disabledColor,
                  margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                ),
                Text(
                  orderModel.orderType!.tr,
                  style: senRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                ),
              ]),
            ])),
            showStatus
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.paddingSizeSmall,
                        vertical: Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      orderModel.orderStatus!.tr,
                      style: senMedium.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall,
                          color: Theme.of(context).primaryColor),
                    ),
                  )
                : Text(
                    '${orderModel.detailsCount} ${orderModel.detailsCount! < 2 ? 'item'.tr : 'items'.tr}',
                    style: senRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: themeController.darkTheme
                            ? Colors.white
                            : Theme.of(context).disabledColor),
                  ),
            showStatus
                ? const SizedBox()
                : Icon(Icons.keyboard_arrow_right, size: 30, color: Theme.of(context).primaryColor),
          ]),
        ),
        hasDivider ? Divider(color: Colors.grey[100]) : const SizedBox(),
      ]),
    );
  }
}
