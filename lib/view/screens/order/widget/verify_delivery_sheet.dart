import 'package:efood_multivendor_restaurant/controller/auth_controller.dart';
import 'package:efood_multivendor_restaurant/controller/order_controller.dart';
import 'package:efood_multivendor_restaurant/helper/price_converter.dart';
import 'package:efood_multivendor_restaurant/helper/route_helper.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/images.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyDeliverySheet extends StatelessWidget {
  final int? orderID;
  final bool? verify;
  final bool cod;
  final double? orderAmount;
  const VerifyDeliverySheet(
      {Key? key,
      required this.orderID,
      required this.verify,
      required this.orderAmount,
      required this.cod})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<OrderController>().setOtp('');
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: GetBuilder<OrderController>(builder: (orderController) {
        return Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            cod
                ? Column(children: [
                    Image.asset(Images.money, height: 100, width: 100),
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                    Text(
                      'collect_money_from_customer'.tr,
                      textAlign: TextAlign.center,
                      style: senMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        '${'order_amount'.tr}:',
                        textAlign: TextAlign.center,
                        style: senBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      Text(
                        PriceConverter.convertPrice(orderAmount),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.ltr,
                        style: senBold.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                            color: Theme.of(context).primaryColor),
                      ),
                    ]),
                    SizedBox(height: verify! ? 20 : 40),
                  ])
                : const SizedBox(),
            verify!
                ? Column(children: [
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                    Text('collect_otp_from_customer'.tr,
                        style: senRegular, textAlign: TextAlign.center),
                    const SizedBox(height: 40),
                    PinCodeTextField(
                      length: 4,
                      appContext: context,
                      keyboardType: TextInputType.number,
                      animationType: AnimationType.slide,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        fieldHeight: 60,
                        fieldWidth: 60,
                        borderWidth: 1,
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                        selectedFillColor: Colors.white,
                        inactiveFillColor: Theme.of(context).disabledColor.withOpacity(0.2),
                        inactiveColor: Theme.of(context).primaryColor.withOpacity(0.2),
                        activeColor: Theme.of(context).primaryColor.withOpacity(0.4),
                        activeFillColor: Theme.of(context).disabledColor.withOpacity(0.2),
                      ),
                      animationDuration: const Duration(milliseconds: 300),
                      backgroundColor: Colors.transparent,
                      enableActiveFill: true,
                      onChanged: (String text) => orderController.setOtp(text),
                      beforeTextPaste: (text) => true,
                    ),
                    const SizedBox(height: 40),
                  ])
                : const SizedBox(),
            (verify! && orderController.otp.length != 4)
                ? const SizedBox()
                : !orderController.isLoading
                    ? CustomButton(
                        buttonText: verify! ? 'verify'.tr : 'ok'.tr,
                        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
                        onPressed: () {
                          Get.find<OrderController>()
                              .updateOrderStatus(orderID, 'delivered')
                              .then((success) {
                            if (success) {
                              Get.find<AuthController>().getProfile();
                              Get.find<OrderController>().getCurrentOrders();
                              Get.offAllNamed(RouteHelper.getInitialRoute());
                            }
                          });
                        },
                      )
                    : const Center(child: CircularProgressIndicator()),
          ]),
        );
      }),
    );
  }
}
