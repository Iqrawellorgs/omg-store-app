import 'package:efood_multivendor_restaurant/controller/auth_controller.dart';
import 'package:efood_multivendor_restaurant/controller/bank_controller.dart';
import 'package:efood_multivendor_restaurant/helper/price_converter.dart';
import 'package:efood_multivendor_restaurant/helper/route_helper.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_restaurant/view/screens/bank/widget/wallet_widget.dart';
import 'package:efood_multivendor_restaurant/view/screens/bank/widget/withdraw_request_bottom_sheet.dart';
import 'package:efood_multivendor_restaurant/view/screens/bank/widget/withdraw_widget.dart';
import 'package:efood_multivendor_restaurant/view/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/theme_controller.dart';

class WalletScreen extends StatelessWidget {
  WalletScreen({Key? key}) : super(key: key);
  ThemeController themeController = Get.find();
  @override
  Widget build(BuildContext context) {
    if (Get.find<AuthController>().profileModel == null) {
      Get.find<AuthController>().getProfile();
    }
    Get.find<BankController>().getWithdrawList();
    Get.find<BankController>().getWithdrawMethodList();

    return Scaffold(
      // appBar: CustomAppBar(title: 'wallet'.tr, isBackButtonExist: false),
      body: GetBuilder<AuthController>(builder: (authController) {
        return GetBuilder<BankController>(builder: (bankController) {
          return (authController.profileModel != null && bankController.withdrawList != null)
              ? RefreshIndicator(
                  onRefresh: () async {
                    await Get.find<AuthController>().getProfile();
                    await Get.find<BankController>().getWithdrawList();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(
                        height: 271,
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeLarge,
                          vertical: Dimensions.paddingSizeExtraLarge,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
                          color: Theme.of(context).primaryColor,
                        ),
                        alignment: Alignment.center,
                        child: Column(children: [
                          const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                          // Image.asset(Images.wallet, width: 60, height: 60),
                          // const SizedBox(
                          //     width: Dimensions.paddingSizeLarge),
                          Row(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: GestureDetector(
                                  onTap: () => Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DashboardScreen(pageIndex: 0))),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.arrow_back_ios,
                                        size: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: Dimensions.paddingSizeDefault),
                              Text(
                                'wallet'.tr,
                                style: TextStyle(
                                  fontFamily: "Sen",
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xffFFFFFF),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Text(
                            'wallet_amount'.tr,
                            style: TextStyle(
                              fontFamily: "Sen",
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xffFFFFFF),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                          Text(
                            PriceConverter.convertPrice(authController.profileModel!.balance),
                            style: TextStyle(
                              fontFamily: "Sen",
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              color: Color(0xffFFFFFF),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          InkWell(
                            onTap: () {
                              if (bankController.widthDrawMethods != null &&
                                  bankController.widthDrawMethods!.isNotEmpty) {
                                Get.bottomSheet(const WithdrawRequestBottomSheet(),
                                    isScrollControlled: true);
                              } else {
                                showCustomSnackBar('currently_no_bank_account_added'.tr);
                              }
                            },
                            child: Padding(
                                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Color(0xffFFFFFF),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  width: 100,
                                  height: 37,
                                  child: Center(
                                    child: Text('withdraw'.tr,
                                        style: senRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color: themeController.darkTheme
                                              ? Colors.white
                                              : Theme.of(context).cardColor,
                                        )),
                                  ),
                                  // Icon(Icons.keyboard_arrow_down,
                                  //     color: themeController.darkTheme
                                  //         ? Colors.white
                                  //         : Theme.of(context)
                                  //             .cardColor,
                                  //     size: 20),
                                )),
                          ),
                        ]),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                      Row(children: [
                        WalletWidget(
                            title: 'pending_withdraw'.tr, value: bankController.pendingWithdraw),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        WalletWidget(title: 'withdrawn'.tr, value: bankController.withdrawn),
                      ]),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Row(children: [
                        WalletWidget(
                            title: 'collected_cash_from_customer'.tr,
                            value: authController.profileModel!.cashInHands),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        WalletWidget(
                            title: 'total_earning'.tr,
                            value: authController.profileModel!.totalEarning),
                      ]),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('withdraw_history'.tr, style: senMedium),
                          InkWell(
                            onTap: () => Get.toNamed(RouteHelper.getWithdrawHistoryRoute()),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                              child: Text('view_all'.tr,
                                  style: senMedium.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context).primaryColor,
                                  )),
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      bankController.withdrawList!.isNotEmpty
                          ? ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: bankController.withdrawList!.length > 10
                                  ? 10
                                  : bankController.withdrawList!.length,
                              itemBuilder: (context, index) {
                                return WithdrawWidget(
                                  withdrawModel: bankController.withdrawList![index],
                                  showDivider: index !=
                                      (bankController.withdrawList!.length > 10
                                          ? 9
                                          : bankController.withdrawList!.length - 1),
                                );
                              },
                            )
                          : Center(
                              child: Padding(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                              child: Text('no_withdraw_history_found'.tr),
                            )),
                    ]),
                  ),
                )
              : const Center(child: CircularProgressIndicator());
        });
      }),
    );
  }
}
