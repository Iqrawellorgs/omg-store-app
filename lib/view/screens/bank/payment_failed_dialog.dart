import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/order_controller.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../../util/styles.dart';

class PaymentFailedDialog extends StatelessWidget {
  final String? orderID;
  final double? orderAmount;
  final double? maxCodOrderAmount;
  const PaymentFailedDialog(
      {Key? key,
      required this.orderID,
      required this.maxCodOrderAmount,
      required this.orderAmount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(
          width: 500,
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                child: Image.asset(Images.warning, width: 70, height: 70),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeLarge),
                child: Text(
                  'are_you_agree_with_this_order_fail'.tr,
                  textAlign: TextAlign.center,
                  style: senMedium.copyWith(
                      fontSize: Dimensions.fontSizeExtraLarge,
                      color: Colors.red),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                child: Text(
                  'if_you_do_not_pay'.tr,
                  style: senMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),
              GetBuilder<OrderController>(builder: (orderController) {
                return !orderController.isLoading
                    ? Column(children: [
                        // Get.find<SplashController>().configModel!.cashOnDelivery!
                        //     ? CustomButton(
                        //         buttonText: 'switch_to_cash_on_delivery'.tr,
                        //         onPressed: () {
                        //           if (maxCodOrderAmount == null ||
                        //               orderAmount! < maxCodOrderAmount!) {
                        //             double total = ((orderAmount! / 100) *
                        //                 Get.find<SplashController>()
                        //                     .configModel!
                        //                     .loyaltyPointItemPurchasePoint!);
                        //             orderController.switchToCOD(orderID, points: total);
                        //           } else {
                        //             if (Get.isDialogOpen!) {
                        //               Get.back();
                        //             }
                        //             showCustomSnackBar(
                        //                 '${'you_cant_order_more_then'.tr} ${PriceConverter.convertPrice(maxCodOrderAmount)} ${'in_cash_on_delivery'.tr}');
                        //           }
                        //         },
                        //         radius: Dimensions.radiusSmall,
                        //         height: 40,
                        //       )
                        //     : const SizedBox(),
                        // SizedBox(
                        //     height: Get.find<SplashController>().configModel!.cashOnDelivery!
                        //         ? Dimensions.paddingSizeLarge
                        //         : 0),
                        // // TextButton(
                        // //   onPressed: () {
                        // //     // switch to COD and place order
                        // //     Get.find<OrderController>()
                        // //         .switchToCOD(orderID)
                        // //         .then((success) {
                        // //       if (success) {
                        // //         Get.offAllNamed(RouteHelper.getInitialRoute());
                        // //       }
                        // //     });
                        // //   },
                        // //   style: TextButton.styleFrom(
                        // //     backgroundColor: Theme.of(context)
                        // //         .disabledColor
                        // //         .withOpacity(0.3),
                        // //     minimumSize: const Size(Dimensions.webMaxWidth, 40),
                        // //     padding: EdgeInsets.zero,
                        // //     shape: RoundedRectangleBorder(
                        // //         borderRadius: BorderRadius.circular(
                        // //             Dimensions.radiusSmall)),
                        // //   ),
                        // //   child: Text('Switch to COD'.tr,
                        // //       textAlign: TextAlign.center,
                        // //       style: robotoBold.copyWith(
                        // //           color: Theme.of(context)
                        // //               .textTheme
                        // //               .bodyLarge!
                        // //               .color)),
                        // // ),
                        // // SizedBox(
                        // //     height: Get.find<SplashController>()
                        // //             .configModel!
                        // //             .cashOnDelivery!
                        // //         ? Dimensions.paddingSizeLarge
                        // //         : 0),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            backgroundColor: Theme.of(context)
                                .disabledColor
                                .withOpacity(0.3),
                            minimumSize: const Size(Dimensions.webMaxWidth, 40),
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radiusSmall)),
                          ),
                          child: Text('cancel_order'.tr,
                              textAlign: TextAlign.center,
                              style: senBold.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color)),
                        ),
                      ])
                    : const Center(child: CircularProgressIndicator());
              }),
            ]),
          )),
    );
  }
}
