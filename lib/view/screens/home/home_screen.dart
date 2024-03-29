import 'package:efood_multivendor_restaurant/controller/auth_controller.dart';
import 'package:efood_multivendor_restaurant/controller/notification_controller.dart';
import 'package:efood_multivendor_restaurant/controller/order_controller.dart';
import 'package:efood_multivendor_restaurant/controller/theme_controller.dart';
import 'package:efood_multivendor_restaurant/data/model/response/order_model.dart';
import 'package:efood_multivendor_restaurant/helper/price_converter.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/images.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/confirmation_dialog.dart';
import 'package:efood_multivendor_restaurant/view/base/order_shimmer.dart';
import 'package:efood_multivendor_restaurant/view/base/order_widget.dart';
import 'package:efood_multivendor_restaurant/view/screens/home/widget/order_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  Future<void> _loadData() async {
    await Get.find<AuthController>().getProfile();
    await Get.find<OrderController>().getCurrentOrders();
    await Get.find<NotificationController>().getNotificationList();
  }

  ThemeController themeController = Get.find();
  @override
  Widget build(BuildContext context) {
    _loadData();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).cardColor,
        // leading: Padding(
        //   padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        //   child: Image.asset(Images.logo, height: 30, width: 30),
        // ),
        titleSpacing: 0,
        elevation: 0,
        /*title: Text(AppConstants.APP_NAME, maxLines: 1, overflow: TextOverflow.ellipsis, style: robotoMedium.copyWith(
          color: Theme.of(context).textTheme.bodyLarge.color, fontSize: Dimensions.FONT_SIZE_DEFAULT,
        )),*/
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Images.logo, height: 23),
            const SizedBox(width: 10),
            Image.asset(Images.logoName, height: 23),
          ],
        ),
        // actions: [
        //   IconButton(
        //     icon: GetBuilder<NotificationController>(
        //         builder: (notificationController) {
        //       bool hasNewNotification = false;
        //       if (notificationController.notificationList != null) {
        //         hasNewNotification =
        //             notificationController.notificationList!.length !=
        //                 notificationController.getSeenNotificationCount();
        //       }
        //       return Stack(children: [
        //         Icon(Icons.notifications,
        //             size: 25,
        //             color: Theme.of(context).textTheme.bodyLarge!.color),
        //         hasNewNotification
        //             ? Positioned(
        //                 top: 0,
        //                 right: 0,
        //                 child: Container(
        //                   height: 10,
        //                   width: 10,
        //                   decoration: BoxDecoration(
        //                     color: Theme.of(context).primaryColor,
        //                     shape: BoxShape.circle,
        //                     border: Border.all(
        //                         width: 1, color: Theme.of(context).cardColor),
        //                   ),
        //                 ))
        //             : const SizedBox(),
        //       ]);
        //     }),
        //     onPressed: () => Get.toNamed(RouteHelper.getNotificationRoute()),
        //   )
        // ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadData();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(children: [
            GetBuilder<AuthController>(builder: (authController) {
              return Column(children: [
                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                    color: Theme.of(context).cardColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[Get.isDarkMode ? 700 : 200]!,
                        spreadRadius: 1,
                        blurRadius: 5,
                      )
                    ],
                  ),
                  child: Row(children: [
                    Expanded(
                        child: Text(
                      'restaurant_temporarily_closed'.tr,
                      style: senMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
                    authController.profileModel != null
                        ? Switch(
                            value: authController.profileModel!.restaurants![0].active!,
                            activeColor: Colors.green,
                            inactiveThumbColor: Colors.red,
                            inactiveTrackColor: Colors.red[100],
                            trackOutlineColor: const MaterialStatePropertyAll(
                              Colors.transparent,
                            ),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            onChanged: (bool isActive) {
                              Get.dialog(ConfirmationDialog(
                                icon: Images.warning,
                                description: isActive
                                    ? 'are_you_sure_to_open_restaurant'.tr
                                    : 'are_you_sure_to_close_restaurant'.tr,
                                onYesPressed: () {
                                  Get.back();
                                  authController.toggleRestaurantClosedStatus();
                                },
                              ));
                            },
                          )
                        : Shimmer(
                            duration: const Duration(seconds: 2),
                            child: Container(height: 30, width: 50, color: Colors.grey[300])),
                  ]),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xffFFFFFF),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade200.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3)),
                          ]),
                      height: context.height * 0.15,
                      width: context.width * 0.43,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            authController.profileModel != null
                                ? PriceConverter.convertPrice(
                                    authController.profileModel!.thisWeekEarning)
                                : '0',
                            style: const TextStyle(
                              fontFamily: "Sen",
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff32343E),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'this_week'.tr,
                            style: const TextStyle(
                              fontFamily: "Sen",
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff838799),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xffFFFFFF),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade200.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3)),
                          ]),
                      height: context.height * 0.15,
                      width: context.width * 0.43,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            authController.profileModel != null
                                ? PriceConverter.convertPrice(
                                    authController.profileModel!.thisMonthEarning)
                                : '0',
                            style: const TextStyle(
                              fontFamily: "Sen",
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff32343E),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'this_month'.tr,
                            style: const TextStyle(
                              fontFamily: "Sen",
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff838799),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),
                Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0xffFFFFFF),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade200.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3)),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'today'.tr,
                          style: const TextStyle(
                            fontFamily: "Sen",
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff32343E),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        Text(
                          authController.profileModel != null
                              ? PriceConverter.convertPrice(
                                  authController.profileModel!.todaysEarning)
                              : '0',
                          style: const TextStyle(
                            fontFamily: "Sen",
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff32343E),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: Dimensions.paddingSizeDefault,
                ),

                Image.asset(
                  'assets/image/produce_monthly.png',
                  // height: 100,
                  width: context.width,
                  height: context.height * 0.25,
                )
                // Container(
                //   padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                //     color: Theme.of(context).primaryColor,
                //   ),
                //   child: Column(children: [
                //     Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                //       Image.asset(Images.wallet, width: 60, height: 60),
                //       const SizedBox(width: Dimensions.paddingSizeLarge),
                //       Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text(
                //               'today'.tr,
                //               style: robotoMedium.copyWith(
                //                   fontSize: Dimensions.fontSizeSmall,
                //                   color: themeController.darkTheme
                //                       ? Colors.white
                //                       : Theme.of(context).cardColor),
                //             ),
                //             const SizedBox(height: Dimensions.paddingSizeSmall),
                //             Text(
                //               authController.profileModel != null
                //                   ? PriceConverter.convertPrice(authController
                //                       .profileModel!.todaysEarning)
                //                   : '0',
                //               style: robotoBold.copyWith(
                //                   fontSize: 24,
                //                   color: themeController.darkTheme
                //                       ? Colors.white
                //                       : Theme.of(context).cardColor),
                //               textDirection: TextDirection.ltr,
                //             ),
                //           ]),
                //     ]),
                //     const SizedBox(height: 30),
                //     Row(children: [
                //       Expanded(
                //           child: Column(children: [
                //         Text(
                //           'this_week'.tr,
                //           style: robotoMedium.copyWith(
                //               fontSize: Dimensions.fontSizeSmall,
                //               color: themeController.darkTheme
                //                   ? Colors.white
                //                   : Theme.of(context).cardColor),
                //         ),
                //         const SizedBox(height: Dimensions.paddingSizeSmall),
                //         Text(
                //           authController.profileModel != null
                //               ? PriceConverter.convertPrice(
                //                   authController.profileModel!.thisWeekEarning)
                //               : '0',
                //           style: robotoMedium.copyWith(
                //               fontSize: Dimensions.fontSizeExtraLarge,
                //               color: themeController.darkTheme
                //                   ? Colors.white
                //                   : Theme.of(context).cardColor),
                //           textDirection: TextDirection.ltr,
                //         ),
                //       ])),
                //       Container(
                //           height: 30,
                //           width: 1,
                //           color: themeController.darkTheme
                //               ? Colors.white
                //               : Theme.of(context).cardColor),
                //       Expanded(
                //           child: Column(children: [
                //         Text(
                //           'this_month'.tr,
                //           style: robotoMedium.copyWith(
                //               fontSize: Dimensions.fontSizeSmall,
                //               color: themeController.darkTheme
                //                   ? Colors.white
                //                   : Theme.of(context).cardColor),
                //         ),
                //         const SizedBox(height: Dimensions.paddingSizeSmall),
                //         Text(
                //           authController.profileModel != null
                //               ? PriceConverter.convertPrice(
                //                   authController.profileModel!.thisMonthEarning)
                //               : '0',
                //           style: robotoMedium.copyWith(
                //               fontSize: Dimensions.fontSizeExtraLarge,
                //               color: themeController.darkTheme
                //                   ? Colors.white
                //                   : Theme.of(context).cardColor),
                //           textDirection: TextDirection.ltr,
                //         ),
                //       ])),
                //     ]),
                //   ]),
                // ),
              ]);
            }),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            GetBuilder<OrderController>(builder: (orderController) {
              List<OrderModel> orderList = [];
              if (orderController.runningOrders != null) {
                orderList = orderController.runningOrders![orderController.orderIndex].orderList;
              }

              return Column(
                children: [
                  orderController.runningOrders != null
                      ? SizedBox(
                          height: 40,
                          // decoration: BoxDecoration(
                          //   border: Border.all(color: Theme.of(context).disabledColor, width: 1),
                          //   borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          // ),
                          child: ListView.builder(
                            clipBehavior: Clip.none,
                            scrollDirection: Axis.horizontal,
                            itemCount: orderController.runningOrders!.length,
                            itemBuilder: (context, index) {
                              return OrderButton(
                                title: orderController.runningOrders![index].status.tr,
                                index: index,
                                orderController: orderController,
                                fromHistory: false,
                              );
                            },
                          ),
                        )
                      : const SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      orderController.runningOrders != null
                          ? InkWell(
                              onTap: () => orderController.toggleCampaignOnly(),
                              child: Row(children: [
                                Checkbox(
                                  activeColor: Theme.of(context).primaryColor,
                                  value: orderController.campaignOnly,
                                  onChanged: (isActive) => orderController.toggleCampaignOnly(),
                                ),
                                Text(
                                  'campaign_order'.tr,
                                  style: senRegular.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: themeController.darkTheme
                                          ? Colors.white
                                          : Theme.of(context).disabledColor),
                                ),
                              ]),
                            )
                          : const SizedBox(),
                      // orderController.runningOrders != null
                      //     ? InkWell(
                      //         onTap: () => orderController.toggleSubscriptionOnly(),
                      //         child: Row(children: [
                      //           Checkbox(
                      //             activeColor: Theme.of(context).primaryColor,
                      //             value: orderController.subscriptionOnly,
                      //             onChanged: (isActive) =>
                      //                 orderController.toggleSubscriptionOnly(),
                      //           ),
                      //           Text(
                      //             'subscription_order'.tr,
                      //             style: robotoRegular.copyWith(
                      //                 fontSize: Dimensions.fontSizeSmall,
                      //                 color: themeController.darkTheme
                      //                     ? Colors.white
                      //                     : Theme.of(context).disabledColor),
                      //           ),
                      //         ]),
                      //       )
                      //     : const SizedBox(),
                    ],
                  ),
                  orderController.runningOrders != null
                      ? orderList.isNotEmpty
                          ? ListView.builder(
                              padding: const EdgeInsets.only(bottom: 10),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: orderList.length,
                              itemBuilder: (context, index) {
                                return OrderWidget(
                                  orderModel: orderList[index],
                                  hasDivider: index != orderList.length - 1,
                                  isRunning: true,
                                );
                              },
                            )
                          : Padding(
                              padding: const EdgeInsets.only(top: 50),
                              child: Center(child: Text('no_order_found'.tr)),
                            )
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return OrderShimmer(isEnabled: orderController.runningOrders == null);
                          },
                        ),
                ],
              );
            }),
          ]),
        ),
      ),
    );
  }
}
