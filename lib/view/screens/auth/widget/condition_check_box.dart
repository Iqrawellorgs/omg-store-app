import 'package:efood_multivendor_restaurant/controller/auth_controller.dart';
import 'package:efood_multivendor_restaurant/helper/route_helper.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConditionCheckBox extends StatelessWidget {
  final AuthController authController;
  final bool fromSignUp;
  const ConditionCheckBox({Key? key, required this.authController, this.fromSignUp = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: fromSignUp ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          fromSignUp
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: Checkbox(
                    activeColor: Theme.of(context).primaryColor,
                    value: authController.acceptTerms,
                    onChanged: (bool? isChecked) => authController.toggleTerms(),
                  ),
                )
              : const SizedBox(),
          fromSignUp
              ? const SizedBox(
                  width: 5,
                )
              : const Text('* ', style: senRegular),
          Expanded(
            child: FittedBox(
              child: Row(
                children: [
                  Text("By Continuing, you agree to our",
                      style: senRegular.copyWith(
                          color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall)),
                  InkWell(
                    onTap: () => Get.toNamed(RouteHelper.getHtmlRoute('terms-and-condition')),
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      child: Text("Terms of Service",
                          style: senMedium.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontSize: Dimensions.fontSizeSmall)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]);
  }
}
