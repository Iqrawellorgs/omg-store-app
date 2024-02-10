// ignore_for_file: prefer_const_constructors

import 'package:efood_multivendor_restaurant/address_screen.dart';
import 'package:efood_multivendor_restaurant/controller/auth_controller.dart';
import 'package:efood_multivendor_restaurant/controller/bank_controller.dart';
import 'package:efood_multivendor_restaurant/helper/price_converter.dart';
import 'package:efood_multivendor_restaurant/helper/route_helper.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/images.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/confirmation_dialog.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_app_bar.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_restaurant/view/screens/bank/widget/withdraw_request_bottom_sheet.dart';
import 'package:efood_multivendor_restaurant/view/screens/menu/widget/portion_widget.dart';
import 'package:efood_multivendor_restaurant/view/screens/order/order_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewMenuScreen extends StatelessWidget {
  const NewMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Get.find<AuthController>().profileModel == null) {
      Get.find<AuthController>().getProfile();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: CustomAppBar(
        title: "My Profile",
        titleColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: GetBuilder<AuthController>(builder: (authController) {
          return GetBuilder<BankController>(builder: (bankController) {
            return Column(
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height * 0.21,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: Dimensions.paddingSizeLarge,
                      right: Dimensions.paddingSizeLarge,
                      top: Dimensions.paddingSizeDefault,
                      bottom: Dimensions.paddingSizeDefault,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Available Balance",
                          style: TextStyle(
                              fontFamily: "Sen",
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          PriceConverter.convertPrice(authController.profileModel!.balance),
                          style: const TextStyle(
                              fontFamily: "Sen",
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: Dimensions.paddingSizeDefault),
                        GestureDetector(
                          onTap: () {
                            if (bankController.widthDrawMethods != null &&
                                bankController.widthDrawMethods!.isNotEmpty) {
                              Get.bottomSheet(
                                const WithdrawRequestBottomSheet(),
                                isScrollControlled: true,
                              );
                            } else {
                              showCustomSnackBar('currently_no_bank_account_added'.tr);
                            }
                          },
                          child: Container(
                            width: 100,
                            height: 37,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                              border: Border.all(
                                color: Colors.white,
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Withdraw",
                                style: const TextStyle(
                                  fontFamily: "Sen",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  height: 17 / 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            const SizedBox(height: Dimensions.paddingSizeDefault),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeExtraLarge),
                                  child: Text(
                                    'General',
                                    style: senBold.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        color: Theme.of(context).primaryColor.withOpacity(0.5)),
                                  ),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeDefault),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF6F8FA),
                                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black12, spreadRadius: 1, blurRadius: 5)
                                    ],
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeLarge,
                                    vertical: Dimensions.paddingSizeDefault,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeExtraLarge),
                                  child: Column(
                                    children: [
                                      PortionWidget(
                                        icon: Images.profileIcon,
                                        title: 'Edit Profile'.tr,
                                        route: RouteHelper.getProfileRoute(),
                                      ),
                                      PortionWidget(
                                        icon: Images.addressIcon,
                                        title: 'My Address'.tr,
                                        // route: RouteHelper.getProfileRoute(),
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => const AddressScreen(),
                                          ));
                                        },
                                      ),
                                      // PortionWidget(
                                      //   icon: Images.addFood,
                                      //   title: 'add_food'.tr,
                                      //   route: RouteHelper.getProductRoute(null),
                                      // ),

                                      // PortionWidget(
                                      //     icon: Images.addon,
                                      //     title: 'addons'.tr,
                                      //     route: RouteHelper.getAddonsRoute()),
                                      // PortionWidget(
                                      //     icon: Images.categories,
                                      //     title: 'categories'.tr,
                                      //     route: RouteHelper.getCategoriesRoute()),

                                      // PortionWidget(
                                      //     icon: Images.language,
                                      //     title: 'language'.tr,
                                      //     route: RouteHelper.getLanguageRoute('menu')),
                                      // PortionWidget(
                                      //     icon: Images.expense,
                                      //     title: 'expense_report'.tr,
                                      //     route: RouteHelper.getExpenseRoute()),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: Dimensions.paddingSizeDefault),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeExtraLarge),
                                  child: Text(
                                    'History',
                                    style: senBold.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        color: Theme.of(context).primaryColor.withOpacity(0.5)),
                                  ),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeDefault),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF6F8FA),
                                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black12, spreadRadius: 1, blurRadius: 5)
                                    ],
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeLarge,
                                    vertical: Dimensions.paddingSizeDefault,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeExtraLarge),
                                  child: Column(
                                    children: [
                                      PortionWidget(
                                        icon: Images.addFood,
                                        title: 'Order History'.tr,
                                        route: RouteHelper.getOrderHistoryRoute(),
                                        // onTap: () {
                                        //   Navigator.of(context).push(MaterialPageRoute(
                                        //     builder: (context) => const OrderHistoryScreen(),
                                        //   ));
                                        // },
                                      ),
                                      PortionWidget(
                                          icon: Images.policy,
                                          title: 'Expense report'.tr,
                                          route: RouteHelper.getAddonsRoute()),

                                      // PortionWidget(
                                      //     icon: Images.expense,
                                      //     title: 'expense_report'.tr,
                                      //     route: RouteHelper.getExpenseRoute()),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: Dimensions.paddingSizeDefault),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeExtraLarge),
                                  child: Text(
                                    'Store',
                                    style: senBold.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        color: Theme.of(context).primaryColor.withOpacity(0.5)),
                                  ),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeDefault),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF6F8FA),
                                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black12, spreadRadius: 1, blurRadius: 5)
                                    ],
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeLarge,
                                    vertical: Dimensions.paddingSizeDefault,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeExtraLarge),
                                  child: Column(
                                    children: [
                                      PortionWidget(
                                        icon: Images.addFood,
                                        title: 'add_food'.tr,
                                        route: RouteHelper.getProductRoute(null),
                                      ),
                                      PortionWidget(
                                          icon: Images.addon,
                                          title: 'addons'.tr,
                                          route: RouteHelper.getAddonsRoute()),
                                      PortionWidget(
                                          icon: Images.categories,
                                          title: 'categories'.tr,
                                          route: RouteHelper.getCategoriesRoute()),
                                      PortionWidget(
                                        icon: Images.campaign,
                                        title: 'Campaigns'.tr,
                                        route: RouteHelper.getCampaignRoute(),
                                      ),

                                      PortionWidget(
                                          icon: Images.coupon,
                                          title: 'Coupons'.tr,
                                          route: RouteHelper.getCouponRoute()),
                                      // PortionWidget(
                                      //     icon: Images.expense,
                                      //     title: 'expense_report'.tr,
                                      //     route: RouteHelper.getExpenseRoute()),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: Dimensions.paddingSizeLarge),
                            // Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Padding(
                            //       padding: const EdgeInsets.symmetric(
                            //           horizontal: Dimensions.paddingSizeExtraLarge),
                            //       child: Text(
                            //         'Promotional Activity',
                            //         style: robotoBold.copyWith(
                            //             fontSize: Dimensions.fontSizeDefault,
                            //             color: Theme.of(context).primaryColor.withOpacity(0.5)),
                            //       ),
                            //     ),
                            //     const SizedBox(height: Dimensions.paddingSizeDefault),
                            //     Container(
                            //       decoration: BoxDecoration(
                            //         color: const Color(0xFFF6F8FA),
                            //         borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            //         boxShadow: const [
                            //           BoxShadow(
                            //               color: Colors.black12, spreadRadius: 1, blurRadius: 5)
                            //         ],
                            //       ),
                            //       padding: const EdgeInsets.symmetric(
                            //         horizontal: Dimensions.paddingSizeLarge,
                            //         vertical: Dimensions.paddingSizeDefault,
                            //       ),
                            //       margin: const EdgeInsets.symmetric(
                            //           horizontal: Dimensions.paddingSizeExtraLarge),
                            //       child: Column(
                            //         children: [
                            //           PortionWidget(
                            //             icon: Images.campaign,
                            //             title: 'Campaigns'.tr,
                            //             route: RouteHelper.getCampaignRoute(),
                            //           ),

                            //           PortionWidget(
                            //               icon: Images.coupon,
                            //               title: 'Coupons'.tr,
                            //               route: RouteHelper.getCouponRoute()),
                            //           // PortionWidget(
                            //           //     icon: Images.language,
                            //           //     title: 'language'.tr,
                            //           //     route: RouteHelper.getLanguageRoute('menu')),
                            //         ],
                            //       ),
                            //     )
                            //   ],
                            // ),
                            const SizedBox(height: Dimensions.paddingSizeLarge),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeExtraLarge),
                                  child: Text(
                                    'Terms and Conditions',
                                    style: senBold.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        color: Theme.of(context).primaryColor.withOpacity(0.5)),
                                  ),
                                ),
                                const SizedBox(height: Dimensions.paddingSizeDefault),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF6F8FA),
                                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black12, spreadRadius: 1, blurRadius: 5)
                                    ],
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeLarge,
                                    vertical: Dimensions.paddingSizeDefault,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeExtraLarge),
                                  child: Column(
                                    children: [
                                      PortionWidget(
                                          icon: Images.policy,
                                          title: 'privacy_policy'.tr,
                                          route: RouteHelper.getPrivacyRoute()),
                                      PortionWidget(
                                          icon: Images.terms,
                                          title: 'terms_condition'.tr,
                                          route: RouteHelper.getTermsRoute()),
                                      PortionWidget(
                                          icon: Images.faqIcon,
                                          title: "FAQ's".tr,
                                          route: RouteHelper.getPrivacyRoute()),
                                      // PortionWidget(
                                      //   icon: Images.chat,
                                      //   title: 'conversation'.tr,
                                      //   route: RouteHelper.getConversationListRoute(),
                                      //   // isNotSubscribe: (Get.find<AuthController>()
                                      //   //             .profileModel!
                                      //   //             .restaurants![0]
                                      //   //             .restaurantModel ==
                                      //   //         'subscription' &&
                                      //   //     Get.find<AuthController>().profileModel!.subscription != null &&
                                      //   //     Get.find<AuthController>().profileModel!.subscription!.chat == 0),
                                      // ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: Dimensions.paddingSizeLarge),
                            Container(
                              //  padding: const EdgeInsets.symmetric(
                              //     horizontal: Dimensions.paddingSizeExtraLarge),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6F8FA),
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeLarge,
                                vertical: Dimensions.paddingSizeDefault,
                              ),
                              margin: const EdgeInsets.only(
                                left: Dimensions.paddingSizeExtraLarge,
                                right: Dimensions.paddingSizeExtraLarge,
                                bottom: Dimensions.paddingSizeExtraLarge,
                              ),
                              child: PortionWidget(
                                icon: Images.logOut,
                                title: 'logout'.tr,
                                route: '',
                                onTap: () {
                                  // Get.back();
                                  if (Get.find<AuthController>().isLoggedIn()) {
                                    Get.dialog(
                                        ConfirmationDialog(
                                            icon: Images.support,
                                            description: 'are_you_sure_to_logout'.tr,
                                            isLogOut: true,
                                            onYesPressed: () {
                                              Get.find<AuthController>().clearSharedData();
                                              Get.offAllNamed(RouteHelper.getSignInRoute());
                                            }),
                                        useSafeArea: false);
                                  } else {
                                    Get.find<AuthController>().clearSharedData();
                                    Get.toNamed(RouteHelper.getSignInRoute());
                                  }
                                },
                              ),
                            ),
                          ],
                        )))
              ],
            );
          });
        }),
      ),
    );
  }
}
