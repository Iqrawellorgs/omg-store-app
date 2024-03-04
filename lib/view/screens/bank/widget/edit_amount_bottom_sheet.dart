import 'dart:developer';

import 'package:efood_multivendor_restaurant/controller/bank_controller.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../util/images.dart';
import '../../../base/custom_button.dart';
import '../../../base/my_text_field.dart';
import '../payment_screen.dart';

class EditAmountBottomSheet extends StatefulWidget {
  final double? balance;

  const EditAmountBottomSheet({Key? key, this.balance}) : super(key: key);

  @override
  State<EditAmountBottomSheet> createState() => _EditAmountBottomSheetState();
}

class _EditAmountBottomSheetState extends State<EditAmountBottomSheet> {
  late TextEditingController _balanceController;
  final FocusNode _amountFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    double balance = widget.balance ?? 0;
    String formattedBalance =
        balance.toStringAsFixed(balance.truncateToDouble() == balance ? 0 : 2);
    _balanceController = TextEditingController(text: formattedBalance);
    Get.find<BankController>().setMethod(isUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusLarge)),
      ),
      child: GetBuilder<BankController>(builder: (bankController) {
        return SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),
            Image.asset(Images.bank, height: 30, width: 30),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),
            MyTextField(
              isEnabled: false,
              fillColor: Color.fromARGB(255, 240, 245, 250),
              isBorderenabled: false,
              hintText: 'enter_amount'.tr,
              controller: _balanceController,
              capitalization: TextCapitalization.words,
              inputType: TextInputType.number,
              focusNode: _amountFocus,
              inputAction: TextInputAction.done,
              isRequired: true,
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            !bankController.isLoading
                ? CustomButton(
                    buttonText: 'withdraw'.tr,
                    onPressed: () {
                      double amount = double.parse(_balanceController.text.trim());
                      if (amount == amount.toInt()) {
                        amount = amount.toInt().toDouble();
                      }

                      Get.to(() => PaymentScreen(
                            id: bankController.widthDrawMethods![bankController.methodIndex!].id ??
                                0,
                            balance: amount,
                          ));
                    },
                  )
                : const Center(child: CircularProgressIndicator()),
          ]),
        );
      }),
    );
  }
}
