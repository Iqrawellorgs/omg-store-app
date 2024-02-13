import 'package:efood_multivendor_restaurant/controller/bank_controller.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_app_bar.dart';
import 'package:efood_multivendor_restaurant/view/screens/bank/widget/withdraw_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithdrawHistoryScreen extends StatelessWidget {
  const WithdrawHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('withdraw_history'.tr),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GetBuilder<BankController>(builder: (bankController) {
            return Wrap(
              children: List<Widget>.generate(
                Get.find<BankController>().statusList.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ChoiceChip(
                    // padding: const EdgeInsets.symmetric(horizontal: 10),
                    // labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                    shape: StadiumBorder(side: BorderSide(color: Colors.transparent)),
                    showCheckmark: false,
                    label: Text(
                      Get.find<BankController>().statusList[index].toLowerCase().tr,
                      style: senRegular.copyWith(
                          color: Get.find<BankController>().selectedStatusIndex == index
                              ? Colors.white
                              : Colors.black),
                    ),
                    selectedColor: Theme.of(context).primaryColor,
                    selected: Get.find<BankController>().selectedStatusIndex == index,
                    onSelected: (bool selected) {
                      if (selected) {
                        Get.find<BankController>().selectedStatusIndex = index;
                        Get.find<BankController>().filterWithdrawList(index);
                      }
                    },
                  ),
                ),
              ),
            );
          }),
          Expanded(
            child: GetBuilder<BankController>(builder: (bankController) {
              return bankController.withdrawList!.isNotEmpty
                  ? ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: bankController.withdrawList!.length,
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      itemBuilder: (context, index) {
                        return WithdrawWidget(
                          withdrawModel: bankController.withdrawList![index],
                          showDivider: index != bankController.withdrawList!.length - 1,
                        );
                      },
                    )
                  : Center(child: Text('no_withdraw_history_found'.tr));
            }),
          ),
        ],
      ),
    );
  }
}
