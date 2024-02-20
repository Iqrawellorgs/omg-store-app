import 'dart:async';

import 'package:efood_multivendor_restaurant/controller/auth_controller.dart';
import 'package:efood_multivendor_restaurant/controller/localization_controller.dart';
import 'package:efood_multivendor_restaurant/controller/order_controller.dart';
import 'package:efood_multivendor_restaurant/controller/splash_controller.dart';
import 'package:efood_multivendor_restaurant/data/model/body/notification_body.dart';
import 'package:efood_multivendor_restaurant/data/model/response/conversation_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/order_details_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/order_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/profile_model.dart';
import 'package:efood_multivendor_restaurant/helper/date_converter.dart';
import 'package:efood_multivendor_restaurant/helper/price_converter.dart';
import 'package:efood_multivendor_restaurant/helper/route_helper.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/images.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/confirmation_dialog.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_app_bar.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_button.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_image.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_restaurant/view/base/input_dialog.dart';
// import 'package:efood_multivendor_restaurant/view/screens/order/invoice_print_screen';
import 'package:efood_multivendor_restaurant/view/screens/order/widget/cancellation_dialogue.dart';
import 'package:efood_multivendor_restaurant/view/screens/order/widget/order_product_widget.dart';
import 'package:efood_multivendor_restaurant/view/screens/order/widget/slider_button.dart';
import 'package:efood_multivendor_restaurant/view/screens/order/widget/verify_delivery_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../controller/theme_controller.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel orderModel;
  final bool isRunningOrder;
  const OrderDetailsScreen(
      {Key? key, required this.orderModel, required this.isRunningOrder})
      : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen>
    with WidgetsBindingObserver {
  late Timer _timer;

  void _startApiCalling() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      Get.find<OrderController>()
          .setOrderDetails(OrderModel(id: widget.orderModel.id));
    });
  }

  @override
  void initState() {
    super.initState();

    Get.find<OrderController>().setOrderDetails(widget.orderModel);
    if (Get.find<AuthController>().profileModel == null) {
      Get.find<AuthController>().getProfile();
    }

    Get.find<OrderController>().getOrderDetails(widget.orderModel.id);

    _startApiCalling();
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startApiCalling();
    } else if (state == AppLifecycleState.paused) {
      _timer.cancel();
    }
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);

    _timer.cancel();
  }

  ThemeController themeController = Get.find();
  @override
  Widget build(BuildContext context) {
    bool? cancelPermission =
        Get.find<SplashController>().configModel!.canceledByRestaurant;
    late bool selfDelivery;
    if (Get.find<AuthController>().profileModel != null &&
        Get.find<AuthController>().profileModel!.restaurants != null) {
      selfDelivery = Get.find<AuthController>()
              .profileModel!
              .restaurants![0]
              .selfDeliverySystem ==
          1;
    }

    return GetBuilder<OrderController>(builder: (orderController) {
      OrderModel? controllerOrderModer = orderController.orderModel;

      bool restConfModel =
          Get.find<SplashController>().configModel!.orderConfirmationModel !=
              'deliveryman';
      bool showSlider = controllerOrderModer != null
          ? (controllerOrderModer.orderStatus == 'pending' &&
                  (controllerOrderModer.orderType == 'take_away' ||
                      restConfModel ||
                      selfDelivery)) ||
              controllerOrderModer.orderStatus == 'confirmed' ||
              controllerOrderModer.orderStatus == 'processing' ||
              (controllerOrderModer.orderStatus == 'accepted' &&
                  controllerOrderModer.confirmed != null) ||
              (controllerOrderModer.orderStatus == 'handover' &&
                  (selfDelivery ||
                      controllerOrderModer.orderType == 'take_away'))
          : false;
      bool showBottomView = controllerOrderModer != null
          ? showSlider ||
              controllerOrderModer.orderStatus == 'picked_up' ||
              widget.isRunningOrder
          : false;

      double? deliveryCharge = 0;
      double itemsPrice = 0;
      double? discount = 0;
      double? couponDiscount = 0;
      double? dmTips = 0;
      double? tax = 0;
      bool? taxIncluded = false;
      double addOns = 0;
      OrderModel? order = controllerOrderModer;
      Restaurant? restaurant;
      bool subscription = false;
      if (Get.find<AuthController>().profileModel != null) {
        restaurant = Get.find<AuthController>().profileModel!.restaurants![0];
      }

      if (order != null && orderController.orderDetailsModel != null) {
        subscription = order.subscriptionId != null &&
            orderController.subscriptionModel != null;

        if (order.orderType == 'delivery') {
          deliveryCharge = order.deliveryCharge;
          dmTips = order.dmTips;
        }
        discount = order.restaurantDiscountAmount;
        tax = order.totalTaxAmount;
        taxIncluded = order.taxStatus;
        couponDiscount = order.couponDiscountAmount;
        for (OrderDetailsModel orderDetails
            in orderController.orderDetailsModel!) {
          for (AddOn addOn in orderDetails.addOns!) {
            addOns = addOns + (addOn.price! * addOn.quantity!);
          }
          itemsPrice =
              itemsPrice + (orderDetails.price! * orderDetails.quantity!);
        }
      }
      double subTotal = itemsPrice + addOns;
      double total = itemsPrice +
          addOns -
          discount! +
          (taxIncluded! ? 0 : tax!) +
          deliveryCharge! -
          couponDiscount! +
          dmTips!;

      return Scaffold(
        appBar: CustomAppBar(
            title: subscription ? 'subscription_order'.tr : 'order_details'.tr),
        body: (orderController.orderDetailsModel != null &&
                controllerOrderModer != null &&
                restaurant != null)
            ? Column(children: [
                Expanded(
                    child: Scrollbar(
                        child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  child: Center(
                      child: SizedBox(
                          // width: 1170,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                        DateConverter.isBeforeTime(
                                controllerOrderModer.scheduleAt)
                            ? (controllerOrderModer.orderStatus !=
                                        'delivered' &&
                                    controllerOrderModer.orderStatus !=
                                        'failed' &&
                                    controllerOrderModer.orderStatus !=
                                        'canceled' &&
                                    controllerOrderModer.orderStatus !=
                                        'refunded' &&
                                    controllerOrderModer.orderStatus !=
                                        'refund_request_canceled')
                                ? Column(children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                            Images.animateDeliveryMan,
                                            fit: BoxFit.contain)),
                                    const SizedBox(
                                        height: Dimensions.paddingSizeDefault),
                                    Text('food_need_to_delivered_within'.tr,
                                        style: senRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeDefault,
                                            color: themeController.darkTheme
                                                ? Colors.white
                                                : Theme.of(context)
                                                    .disabledColor)),
                                    const SizedBox(
                                        height:
                                            Dimensions.paddingSizeExtraSmall),
                                    Center(
                                      child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              DateConverter.differenceInMinute(
                                                          restaurant
                                                              .deliveryTime,
                                                          controllerOrderModer
                                                              .createdAt,
                                                          controllerOrderModer
                                                              .processingTime,
                                                          controllerOrderModer
                                                              .scheduleAt) <
                                                      5
                                                  ? '1 - 5'
                                                  : '${DateConverter.differenceInMinute(restaurant.deliveryTime, controllerOrderModer.createdAt, controllerOrderModer.processingTime, controllerOrderModer.scheduleAt) - 5} '
                                                      '- ${DateConverter.differenceInMinute(restaurant.deliveryTime, controllerOrderModer.createdAt, controllerOrderModer.processingTime, controllerOrderModer.scheduleAt)}',
                                              style: senBold.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeExtraLarge),
                                            ),
                                            const SizedBox(
                                                width: Dimensions
                                                    .paddingSizeExtraSmall),
                                            Text('Hours',
                                                style: senMedium.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeLarge,
                                                    color: Theme.of(context)
                                                        .primaryColor)),
                                          ]),
                                    ),
                                    const SizedBox(
                                        height:
                                            Dimensions.paddingSizeExtraLarge),
                                  ])
                                : const SizedBox()
                            : const SizedBox(),

                        Row(children: [
                          Text('${'order_id'.tr}:',
                              style: senBold.copyWith(
                                  fontSize: Dimensions.fontSizeDefault)),
                          const SizedBox(
                              width: Dimensions.paddingSizeExtraSmall),
                          Text(order!.id.toString(),
                              style: senBold.copyWith(
                                  fontSize: Dimensions.fontSizeDefault)),
                          const SizedBox(
                              width: Dimensions.paddingSizeExtraSmall),
                          // const Expanded(child: SizedBox()),
                          Spacer(),
                          const Icon(Icons.watch_later, size: 17),
                          const SizedBox(
                              width: Dimensions.paddingSizeExtraSmall),
                          Text(
                            DateConverter.dateTimeStringToDateTime(
                                order.createdAt!),
                            style: senRegular,
                          ),
                        ]),
                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        order.scheduled == 1
                            ? Row(children: [
                                Text('${'scheduled_at'.tr}:',
                                    style: senRegular),
                                const SizedBox(
                                    width: Dimensions.paddingSizeExtraSmall),
                                Text(
                                    DateConverter.dateTimeStringToDateTime(
                                        order.scheduleAt!),
                                    style: senMedium),
                              ])
                            : const SizedBox(),
                        SizedBox(
                            height: order.scheduled == 1
                                ? Dimensions.paddingSizeSmall
                                : 0),

                        Row(children: [
                          Text(order.orderType!.tr, style: senMedium),
                          const Expanded(child: SizedBox()),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeSmall,
                                vertical: Dimensions.paddingSizeExtraSmall),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radiusSmall),
                            ),
                            child: Text(
                              order.paymentMethod == 'cash_on_delivery'
                                  ? 'cash_on_delivery'.tr
                                  : order.paymentMethod == 'wallet'
                                      ? 'wallet_payment'.tr
                                      : 'digital_payment'.tr,
                              style: senRegular.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: Dimensions.fontSizeExtraSmall),
                            ),
                          ),
                        ]),
                        Divider(
                          height: Dimensions.paddingSizeLarge,
                          color: Colors.grey[100],
                          // thickness: 0.0,
                        ),

                        subscription
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    const SizedBox(
                                        height:
                                            Dimensions.paddingSizeExtraSmall),
                                    Row(children: [
                                      Text('${'subscription_date'.tr}:',
                                          style: senRegular),
                                      const SizedBox(
                                          width:
                                              Dimensions.paddingSizeExtraSmall),
                                      Text(
                                        '${DateConverter.convertDateToDate(orderController.subscriptionModel!.startAt!)} '
                                        '- ${DateConverter.convertDateToDate(orderController.subscriptionModel!.endAt!)}',
                                        style: senMedium,
                                      ),
                                    ]),
                                    const SizedBox(
                                        height:
                                            Dimensions.paddingSizeExtraSmall),
                                    Row(children: [
                                      Text('${'subscription_type'.tr}:',
                                          style: senRegular),
                                      const SizedBox(
                                          width:
                                              Dimensions.paddingSizeExtraSmall),
                                      Text(
                                          orderController
                                              .subscriptionModel!.type!.tr,
                                          style: senMedium),
                                    ]),
                                    const SizedBox(
                                        height:
                                            Dimensions.paddingSizeExtraSmall),
                                    Divider(
                                      height: Dimensions.paddingSizeLarge,
                                      color: Colors.grey[100],
                                    ),
                                  ])
                            : const SizedBox(),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: Dimensions.paddingSizeExtraSmall),
                          child: Row(children: [
                            Text('${'item'.tr}:', style: senRegular),
                            const SizedBox(
                                width: Dimensions.paddingSizeExtraSmall),
                            Text(
                              orderController.orderDetailsModel!.length
                                  .toString(),
                              style: senMedium.copyWith(
                                  color: Theme.of(context).primaryColor),
                            ),
                            const Expanded(child: SizedBox()),
                            Container(
                              height: 7,
                              width: 7,
                              decoration: BoxDecoration(
                                  color: (order.orderStatus == 'failed' ||
                                          order.orderStatus == 'canceled' ||
                                          order.orderStatus ==
                                              'refund_request_canceled')
                                      ? Colors.red
                                      : order.orderStatus == 'refund_requested'
                                          ? Colors.yellow
                                          : Colors.green,
                                  shape: BoxShape.circle),
                            ),
                            const SizedBox(
                                width: Dimensions.paddingSizeExtraSmall),
                            Padding(
                              padding: const EdgeInsets.only(right: 3.0),
                              child: Text(
                                order.orderStatus == 'delivered'
                                    ? '${'delivered_at'.tr} ${order.delivered != null ? DateConverter.dateTimeStringToDateTime(order.delivered!) : ''}'
                                    : order.orderStatus!.tr,
                                style: senRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall),
                              ),
                            ),
                          ]),
                        ),
                        Divider(
                          height: Dimensions.paddingSizeLarge,
                          color: Colors.grey[100],
                          // thickness: 0.0,
                        ),
                        order.cutlery != null
                            ? Row(children: [
                                Text('${'cutlery'.tr}: ', style: senRegular),
                                // const Expanded(child: SizedBox()),
                                Text(
                                  order.cutlery! ? 'yes'.tr : 'no'.tr,
                                  style: senRegular,
                                ),
                              ])
                            : const SizedBox(),
                        Divider(
                          height: Dimensions.paddingSizeLarge,
                          color: Colors.grey[100],
                          // thickness: 1,
                        ),

                        order.unavailableItemNote != null
                            ? Row(children: [
                                Text('${'if_item_is_not_available'.tr}: ',
                                    style: senMedium),
                                Text(
                                  order.unavailableItemNote!,
                                  style: senRegular,
                                ),
                              ])
                            : const SizedBox(),
                        order.unavailableItemNote != null
                            ? Divider(
                                height: Dimensions.paddingSizeLarge,
                                color: Colors.grey[100],
                                // thickness: 0.0,
                              )
                            : const SizedBox(),

                        order.deliveryInstruction != null
                            ? Row(children: [
                                Text('${'delivery_instruction'.tr}: ',
                                    style: senMedium),
                                Text(
                                  order.deliveryInstruction!,
                                  style: senRegular,
                                ),
                              ])
                            : const SizedBox(),
                        order.deliveryInstruction != null
                            ? Divider(
                                height: Dimensions.paddingSizeLarge,
                                color: Colors.grey[100],
                                // thickness: 10,
                              )
                            : const SizedBox(),

                        SizedBox(
                            height: order.deliveryInstruction != null
                                ? Dimensions.paddingSizeSmall
                                : 0),

                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        // for (int i = 0;
                        //     i <
                        //         orderController
                        //             .orderDetailsModel!.length;
                        //     i++)
                        //   SizedBox(
                        //     height: 160,
                        //     width: 400,
                        //     child: OrderProductWidget(
                        //         order: order,
                        //         orderDetails: orderController
                        //             .orderDetailsModel![i]),
                        //   ),

                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: orderController.orderDetailsModel!.length,
                          // itemExtent: 180,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  bottom: Dimensions.paddingSizeDefault),
                              child: OrderProductWidget(
                                  order: order,
                                  orderDetails: orderController
                                      .orderDetailsModel![index]),
                            );
                          },
                        ),

                        (order.orderNote != null && order.orderNote!.isNotEmpty)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text('additional_note'.tr,
                                        style: senRegular),
                                    const SizedBox(
                                        height: Dimensions.paddingSizeSmall),
                                    Container(
                                      width: 1170,
                                      padding: const EdgeInsets.all(
                                          Dimensions.paddingSizeSmall),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.radiusSmall),
                                        border: Border.all(
                                            width: 1,
                                            color: Theme.of(context)
                                                .disabledColor),
                                      ),
                                      child: Text(
                                        order.orderNote!,
                                        style: senRegular.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color: Theme.of(context)
                                                .disabledColor),
                                      ),
                                    ),
                                    const SizedBox(
                                        height: Dimensions.paddingSizeLarge),
                                  ])
                            : const SizedBox(),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                        Text('customer_details'.tr, style: senRegular),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Row(children: [
                          ClipOval(
                              child: CustomImage(
                            image: order.customer != null
                                ? '${Get.find<SplashController>().configModel!.baseUrls!.customerImageUrl}/${order.customer!.image}'
                                : '',
                            height: 35,
                            width: 35,
                            fit: BoxFit.cover,
                          )),
                          const SizedBox(width: Dimensions.paddingSizeSmall),
                          Expanded(
                              child: order.deliveryAddress != null
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                          Text(
                                            order.deliveryAddress!
                                                .contactPersonName!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: senBold.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeDefault),
                                          ),
                                          // Text(
                                          //   order.deliveryAddress!.address != null ? order.deliveryAddress!.address! : '', maxLines: 1, overflow: TextOverflow.ellipsis,
                                          //   style: senRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                                          // ),

                                          // Wrap(children: [
                                          //   (order.deliveryAddress
                                          //                   ?.streetNumber !=
                                          //               null &&
                                          //           order
                                          //               .deliveryAddress!
                                          //               .streetNumber!
                                          //               .isNotEmpty)
                                          //       ? Text(
                                          //           '${'street_number'.tr}: ${order.deliveryAddress!.streetNumber!}${(order.deliveryAddress?.house != null && order.deliveryAddress!.house!.isNotEmpty) ? ', ' : ' '}',
                                          //           style: senRegular.copyWith(
                                          //               fontSize: Dimensions
                                          //                   .fontSizeExtraSmall,
                                          //               color: Theme.of(
                                          //                       context)
                                          //                   .disabledColor),
                                          //           maxLines: 1,
                                          //           overflow:
                                          //               TextOverflow.ellipsis,
                                          //         )
                                          //       : const SizedBox(),
                                          //   (order.deliveryAddress?.house !=
                                          //               null &&
                                          //           order.deliveryAddress!
                                          //               .house!.isNotEmpty)
                                          //       ? Text(
                                          //           '${'house'.tr}: ${order.deliveryAddress!.house!}${(order.deliveryAddress!.floor != null && order.deliveryAddress!.floor!.isNotEmpty) ? ', ' : ' '}',
                                          //           style: senRegular.copyWith(
                                          //               fontSize: Dimensions
                                          //                   .fontSizeExtraSmall,
                                          //               color: Theme.of(
                                          //                       context)
                                          //                   .disabledColor),
                                          //           maxLines: 1,
                                          //           overflow:
                                          //               TextOverflow.ellipsis,
                                          //         )
                                          //       : const SizedBox(),
                                          //   (order.deliveryAddress?.floor !=
                                          //               null &&
                                          //           order.deliveryAddress!
                                          //               .floor!.isNotEmpty)
                                          //       ? Text(
                                          //           '${'floor'.tr}: ${order.deliveryAddress!.floor!}',
                                          //           style: senRegular.copyWith(
                                          //               fontSize: Dimensions
                                          //                   .fontSizeExtraSmall,
                                          //               color: Theme.of(
                                          //                       context)
                                          //                   .disabledColor),
                                          //           maxLines: 1,
                                          //           overflow:
                                          //               TextOverflow.ellipsis,
                                          //         )
                                          //       : const SizedBox(),
                                          // ]),
                                        ])
                                  : Text('walking_customer'.tr,
                                      style: senMedium)),
                          (order.orderType == 'take_away' &&
                                  (order.orderStatus == 'pending' ||
                                      order.orderStatus == 'confirmed' ||
                                      order.orderStatus == 'processing'))
                              ? TextButton.icon(
                                  onPressed: () async {
                                    String url =
                                        'https://www.google.com/maps/dir/?api=1&destination=${order.deliveryAddress?.latitude}'
                                        ',${order.deliveryAddress?.longitude}&mode=d';
                                    if (await canLaunchUrlString(url)) {
                                      await launchUrlString(url,
                                          mode: LaunchMode.externalApplication);
                                    } else {
                                      showCustomSnackBar(
                                          'unable_to_launch_google_map'.tr);
                                    }
                                  },
                                  icon: const Icon(Icons.directions),
                                  label: Text('direction'.tr),
                                )
                              : const SizedBox(),
                          const SizedBox(width: Dimensions.paddingSizeSmall),
                          (controllerOrderModer.orderStatus != 'delivered' &&
                                  controllerOrderModer.orderStatus !=
                                      'failed' &&
                                  controllerOrderModer.orderStatus !=
                                      'canceled' &&
                                  controllerOrderModer.orderStatus !=
                                      'refunded')
                              ? TextButton.icon(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.all(0),
                                  ),
                                  onPressed: () async {
                                    if (Get.find<AuthController>()
                                                .profileModel!
                                                .subscription !=
                                            null &&
                                        Get.find<AuthController>()
                                                .profileModel!
                                                .subscription!
                                                .chat ==
                                            0 &&
                                        Get.find<AuthController>()
                                                .profileModel!
                                                .restaurants![0]
                                                .restaurantModel ==
                                            'subscription') {
                                      showCustomSnackBar(
                                          'you_have_no_available_subscription'
                                              .tr);
                                    } else {
                                      _timer.cancel();
                                      await Get.toNamed(
                                          RouteHelper.getChatRoute(
                                        notificationBody: NotificationBody(
                                          orderId:
                                              orderController.orderModel!.id,
                                          customerId: orderController
                                              .orderModel!.customer!.id,
                                        ),
                                        user: User(
                                          id: orderController
                                              .orderModel!.customer!.id,
                                          fName: orderController
                                              .orderModel!.customer!.fName,
                                          lName: orderController
                                              .orderModel!.customer!.lName,
                                          image: orderController
                                              .orderModel!.customer!.image,
                                        ),
                                      ));
                                      _startApiCalling();
                                    }
                                  },
                                  icon: Icon(Icons.chat_bubble_outline,
                                      color: Theme.of(context).primaryColor,
                                      size: 25),
                                  label: Text(
                                    'chat'.tr,
                                    style: senRegular.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                )
                              : const SizedBox(),
                        ]),
                        const SizedBox(height: 12),

                        order.deliveryMan != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('delivery_man'.tr, style: senRegular),
                                  const SizedBox(
                                      height: Dimensions.paddingSizeSmall),
                                  Row(children: [
                                    ClipOval(
                                        child: CustomImage(
                                      image: order.deliveryMan != null
                                          ? '${Get.find<SplashController>().configModel!.baseUrls!.deliveryManImageUrl}/${order.deliveryMan!.image}'
                                          : '',
                                      height: 35,
                                      width: 35,
                                      fit: BoxFit.cover,
                                    )),
                                    const SizedBox(
                                        width: Dimensions.paddingSizeSmall),
                                    Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                          Text(
                                            '${order.deliveryMan!.fName} ${order.deliveryMan!.lName}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: senRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall),
                                          ),
                                          Text(
                                            order.deliveryMan!.email!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: senRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                                color: Theme.of(context)
                                                    .disabledColor),
                                          ),
                                        ])),
                                    (controllerOrderModer.orderStatus !=
                                                'delivered' &&
                                            controllerOrderModer.orderStatus !=
                                                'failed' &&
                                            controllerOrderModer.orderStatus !=
                                                'canceled' &&
                                            controllerOrderModer.orderStatus !=
                                                'refunded')
                                        ? TextButton.icon(
                                            onPressed: () async {
                                              if (await canLaunchUrlString(
                                                  'tel:${order.deliveryMan!.phone ?? ''}')) {
                                                launchUrlString(
                                                    'tel:${order.deliveryMan!.phone ?? ''}',
                                                    mode: LaunchMode
                                                        .externalApplication);
                                              } else {
                                                showCustomSnackBar(
                                                    '${'can_not_launch'.tr} ${order.deliveryMan!.phone ?? ''}');
                                              }
                                            },
                                            icon: Icon(Icons.call,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                size: 20),
                                            label: Text(
                                              'call'.tr,
                                              style: senRegular.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeSmall,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                          )
                                        : const SizedBox(),
                                    (controllerOrderModer.orderStatus !=
                                                'delivered' &&
                                            controllerOrderModer.orderStatus !=
                                                'failed' &&
                                            controllerOrderModer.orderStatus !=
                                                'canceled' &&
                                            controllerOrderModer.orderStatus !=
                                                'refunded')
                                        ? TextButton.icon(
                                            onPressed: () async {
                                              if (Get.find<AuthController>()
                                                          .profileModel!
                                                          .subscription !=
                                                      null &&
                                                  Get.find<AuthController>()
                                                          .profileModel!
                                                          .subscription!
                                                          .chat ==
                                                      0 &&
                                                  Get.find<AuthController>()
                                                          .profileModel!
                                                          .restaurants![0]
                                                          .restaurantModel ==
                                                      'subscription') {
                                                showCustomSnackBar(
                                                    'you_have_no_available_subscription'
                                                        .tr);
                                              } else {
                                                _timer.cancel();
                                                await Get.toNamed(
                                                    RouteHelper.getChatRoute(
                                                  notificationBody:
                                                      NotificationBody(
                                                    orderId: orderController
                                                        .orderModel!.id,
                                                    deliveryManId:
                                                        order.deliveryMan!.id,
                                                  ),
                                                  user: User(
                                                    id: orderController
                                                        .orderModel!
                                                        .deliveryMan!
                                                        .id,
                                                    fName: orderController
                                                        .orderModel!
                                                        .deliveryMan!
                                                        .fName,
                                                    lName: orderController
                                                        .orderModel!
                                                        .deliveryMan!
                                                        .lName,
                                                    image: orderController
                                                        .orderModel!
                                                        .deliveryMan!
                                                        .image,
                                                  ),
                                                ));
                                                _startApiCalling();
                                              }
                                            },
                                            icon: Icon(
                                                Icons.chat_bubble_outline,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                size: 20),
                                            label: Text(
                                              'chat'.tr,
                                              style: senRegular.copyWith(
                                                  fontSize:
                                                      Dimensions.fontSizeSmall,
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                          )
                                        : const SizedBox(),
                                  ]),
                                ],
                              )
                            : const SizedBox(),
                        // const SizedBox(height: Dimensions.paddingSizeLarge),

                        // Total
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Order price'.tr, style: senRegular),
                              Text(PriceConverter.convertPrice(itemsPrice),
                                  style: senRegular,
                                  textDirection: TextDirection.ltr),
                            ]),
                        const SizedBox(height: 10),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('addons'.tr, style: senRegular),
                              Text(
                                '(+) ${PriceConverter.convertPrice(addOns)}',
                                style: senRegular,
                                textDirection: TextDirection.ltr,
                              ),
                            ]),

                        Divider(
                          height: Dimensions.paddingSizeLarge,
                          color: Colors.grey[100],
                          // thickness: 10,
                        ),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  '${'subtotal'.tr} ${taxIncluded ? '(${'tax_included'.tr})' : ''}',
                                  style: senMedium),
                              Text(PriceConverter.convertPrice(subTotal),
                                  style: senMedium,
                                  textDirection: TextDirection.ltr),
                            ]),
                        const SizedBox(height: 10),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('discount'.tr, style: senRegular),
                              Text(
                                  '(-) ${PriceConverter.convertPrice(discount)}',
                                  style: senRegular,
                                  textDirection: TextDirection.ltr),
                            ]),
                        const SizedBox(height: 10),

                        // Row(
                        //   mainAxisAlignment:
                        //       MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text('delivery_man_tips'.tr,
                        //         style: senRegular),
                        //     Text(
                        //         '(+) ${PriceConverter.convertPrice(dmTips)}',
                        //         style: senRegular,
                        //         textDirection: TextDirection.ltr),
                        //   ],
                        // ),
                        // const SizedBox(height: 10),

                        couponDiscount > 0
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                    Text('coupon_discount'.tr,
                                        style: senRegular),
                                    Text(
                                      '(-) ${PriceConverter.convertPrice(couponDiscount)}',
                                      style: senRegular,
                                      textDirection: TextDirection.ltr,
                                    ),
                                  ])
                            : const SizedBox(),
                        SizedBox(height: couponDiscount > 0 ? 10 : 0),

                        !taxIncluded
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                    Text('vat_tax'.tr, style: senRegular),
                                    Text(
                                        '(+) ${PriceConverter.convertPrice(tax)}',
                                        style: senRegular,
                                        textDirection: TextDirection.ltr),
                                  ])
                            : const SizedBox(),
                        SizedBox(height: taxIncluded ? 0 : 10),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('delivery_fee'.tr, style: senRegular),
                              Text(
                                  '(+) ${PriceConverter.convertPrice(deliveryCharge)}',
                                  style: senRegular,
                                  textDirection: TextDirection.ltr),
                            ]),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: Dimensions.paddingSizeSmall),
                          child: Divider(
                            height: Dimensions.paddingSizeLarge,
                            color: Colors.grey[100],

                            // thickness: 0.0,
                          ),
                        ),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('total_amount'.tr,
                                  style: senMedium.copyWith(
                                    fontSize: Dimensions.fontSizeLarge,
                                    color: Theme.of(context).primaryColor,
                                  )),
                              Text(
                                PriceConverter.convertPrice(total),
                                textDirection: TextDirection.ltr,
                                style: senMedium.copyWith(
                                    fontSize: Dimensions.fontSizeLarge,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ]),
                      ]))),
                ))),
                SafeArea(
                  child: showBottomView
                      ? (controllerOrderModer.orderStatus == 'picked_up')
                          ? Container(
                              padding: const EdgeInsets.all(
                                  Dimensions.paddingSizeDefault),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    Dimensions.radiusSmall),
                                border: Border.all(width: 1),
                              ),
                              alignment: Alignment.center,
                              child: Text('food_is_on_the_way'.tr,
                                  style: senMedium),
                            )
                          : showSlider
                              ? (controllerOrderModer.orderStatus ==
                                          'pending' &&
                                      (controllerOrderModer.orderType ==
                                              'take_away' ||
                                          restConfModel ||
                                          selfDelivery) &&
                                      cancelPermission!)
                                  ? Padding(
                                      padding: const EdgeInsets.all(
                                          Dimensions.paddingSizeSmall),
                                      child: Row(children: [
                                        Expanded(
                                            child: TextButton(
                                          onPressed: () {
                                            orderController
                                                .setOrderCancelReason('');
                                            Get.dialog(CancellationDialogue(
                                                orderId: order.id));
                                          },
                                          style: TextButton.styleFrom(
                                            minimumSize: const Size(1170, 40),
                                            padding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.radiusSmall),
                                              side: BorderSide(
                                                  width: 1,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .color!),
                                            ),
                                          ),
                                          child: Text('cancel'.tr,
                                              textAlign: TextAlign.center,
                                              style: senRegular.copyWith(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .color,
                                                fontSize:
                                                    Dimensions.fontSizeLarge,
                                              )),
                                        )),
                                        const SizedBox(
                                            width: Dimensions.paddingSizeSmall),
                                        Expanded(
                                            child: CustomButton(
                                          buttonText: 'confirm'.tr,
                                          height: 40,
                                          onPressed: () {
                                            Get.dialog(
                                                ConfirmationDialog(
                                                  icon: Images.warning,
                                                  title:
                                                      'are_you_sure_to_confirm'
                                                          .tr,
                                                  description:
                                                      'you_want_to_confirm_this_order'
                                                          .tr,
                                                  onYesPressed: () {
                                                    orderController
                                                        .updateOrderStatus(
                                                            controllerOrderModer
                                                                .id,
                                                            'confirmed',
                                                            back: true)
                                                        .then((success) {
                                                      if (success) {
                                                        Get.find<
                                                                AuthController>()
                                                            .getProfile();
                                                        Get.find<
                                                                OrderController>()
                                                            .getCurrentOrders();
                                                      }
                                                    });
                                                  },
                                                ),
                                                barrierDismissible: false);
                                          },
                                        )),
                                      ]),
                                    )
                                  : SliderButton(
                                      action: () {
                                        if (controllerOrderModer.orderStatus ==
                                                'pending' &&
                                            (controllerOrderModer.orderType ==
                                                    'take_away' ||
                                                restConfModel ||
                                                selfDelivery)) {
                                          Get.dialog(
                                              ConfirmationDialog(
                                                icon: Images.warning,
                                                title: 'are_you_sure_to_confirm'
                                                    .tr,
                                                description:
                                                    'you_want_to_confirm_this_order'
                                                        .tr,
                                                onYesPressed: () {
                                                  orderController
                                                      .updateOrderStatus(
                                                          controllerOrderModer
                                                              .id,
                                                          'confirmed',
                                                          back: true)
                                                      .then((success) {
                                                    if (success) {
                                                      Get.find<AuthController>()
                                                          .getProfile();
                                                      Get.find<
                                                              OrderController>()
                                                          .getCurrentOrders();
                                                    }
                                                  });
                                                },
                                                onNoPressed: () {
                                                  if (cancelPermission!) {
                                                    orderController
                                                        .updateOrderStatus(
                                                            controllerOrderModer
                                                                .id,
                                                            'canceled',
                                                            back: true)
                                                        .then((success) {
                                                      if (success) {
                                                        Get.find<
                                                                AuthController>()
                                                            .getProfile();
                                                        Get.find<
                                                                OrderController>()
                                                            .getCurrentOrders();
                                                      }
                                                    });
                                                  } else {
                                                    Get.back();
                                                  }
                                                },
                                              ),
                                              barrierDismissible: false);
                                        } else if (controllerOrderModer
                                                .orderStatus ==
                                            'processing') {
                                          Get.find<OrderController>()
                                              .updateOrderStatus(
                                                  controllerOrderModer.id,
                                                  'handover')
                                              .then((success) {
                                            if (success) {
                                              Get.find<AuthController>()
                                                  .getProfile();
                                              Get.find<OrderController>()
                                                  .getCurrentOrders();
                                            }
                                          });
                                        } else if (controllerOrderModer
                                                    .orderStatus ==
                                                'confirmed' ||
                                            (controllerOrderModer.orderStatus ==
                                                    'accepted' &&
                                                controllerOrderModer
                                                        .confirmed !=
                                                    null)) {
                                          Get.dialog(InputDialog(
                                            icon: Images.warning,
                                            title: 'are_you_sure_to_confirm'.tr,
                                            description:
                                                'enter_processing_time_in_minutes'
                                                    .tr,
                                            onPressed: (String? time) {
                                              if (double.tryParse(time ?? '') ==
                                                  null) {
                                                showCustomSnackBar(
                                                    'Please enter valid time');
                                                return;
                                              }
                                              Get.back();
                                              Get.find<OrderController>()
                                                  .updateOrderStatus(
                                                      controllerOrderModer.id,
                                                      'processing',
                                                      processingTime:
                                                          (double.parse(time!) *
                                                                  60)
                                                              .toString())
                                                  .then((success) {
                                                if (success) {
                                                  Get.find<AuthController>()
                                                      .getProfile();
                                                  Get.find<OrderController>()
                                                      .getCurrentOrders();
                                                }
                                              });
                                            },
                                          ));
                                        } else if ((controllerOrderModer
                                                    .orderStatus ==
                                                'handover' &&
                                            (controllerOrderModer.orderType ==
                                                    'take_away' ||
                                                selfDelivery))) {
                                          if (Get.find<SplashController>()
                                                  .configModel!
                                                  .orderDeliveryVerification! ||
                                              controllerOrderModer
                                                      .paymentMethod ==
                                                  'cash_on_delivery') {
                                            Get.bottomSheet(
                                                VerifyDeliverySheet(
                                                  orderID:
                                                      controllerOrderModer.id,
                                                  verify: Get.find<
                                                          SplashController>()
                                                      .configModel!
                                                      .orderDeliveryVerification,
                                                  orderAmount:
                                                      controllerOrderModer
                                                          .orderAmount,
                                                  cod: controllerOrderModer
                                                          .paymentMethod ==
                                                      'cash_on_delivery',
                                                ),
                                                isScrollControlled: true);
                                          } else {
                                            Get.find<OrderController>()
                                                .updateOrderStatus(
                                                    controllerOrderModer.id,
                                                    'delivered')
                                                .then((success) {
                                              if (success) {
                                                Get.find<AuthController>()
                                                    .getProfile();
                                                Get.find<OrderController>()
                                                    .getCurrentOrders();
                                              }
                                            });
                                          }
                                        }
                                      },
                                      label: Text(
                                        (controllerOrderModer.orderStatus ==
                                                    'pending' &&
                                                (controllerOrderModer
                                                            .orderType ==
                                                        'take_away' ||
                                                    restConfModel ||
                                                    selfDelivery))
                                            ? 'swipe_to_confirm_order'.tr
                                            : (controllerOrderModer
                                                            .orderStatus ==
                                                        'confirmed' ||
                                                    (controllerOrderModer
                                                                .orderStatus ==
                                                            'accepted' &&
                                                        controllerOrderModer
                                                                .confirmed !=
                                                            null))
                                                ? 'swipe_to_cooking'.tr
                                                : (controllerOrderModer
                                                            .orderStatus ==
                                                        'processing')
                                                    ? 'swipe_if_ready_for_handover'
                                                        .tr
                                                    : (controllerOrderModer
                                                                    .orderStatus ==
                                                                'handover' &&
                                                            (controllerOrderModer
                                                                        .orderType ==
                                                                    'take_away' ||
                                                                selfDelivery))
                                                        ? 'swipe_to_deliver_order'
                                                            .tr
                                                        : '',
                                        style: senMedium.copyWith(
                                            fontSize: Dimensions.fontSizeLarge,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                      dismissThresholds: 0.5,
                                      dismissible: false,
                                      shimmer: true,
                                      width: 1170,
                                      height: 60,
                                      buttonSize: 50,
                                      radius: 10,
                                      icon: Center(
                                          child: Icon(
                                        Get.find<LocalizationController>().isLtr
                                            ? Icons.double_arrow_sharp
                                            : Icons.keyboard_arrow_left,
                                        color: Colors.white,
                                        size: 20.0,
                                      )),
                                      isLtr: Get.find<LocalizationController>()
                                          .isLtr,
                                      boxShadow: const BoxShadow(blurRadius: 0),
                                      buttonColor:
                                          Theme.of(context).primaryColor,
                                      backgroundColor: const Color(0xffF4F7FC),
                                      baseColor: Theme.of(context).primaryColor,
                                    )
                              : const SizedBox()
                      : const SizedBox(),
                ),
                (!GetPlatform.isIOS && !GetPlatform.isWeb || true)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.paddingSizeLarge,
                          vertical: Dimensions.paddingSizeExtraSmall,
                        ),
                        child: CustomButton(
                          onPressed: () {
                            Get.dialog(Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusSmall)),
                              insetPadding: const EdgeInsets.all(
                                  Dimensions.paddingSizeSmall),
                              // child: InVoicePrintScreen(
                              //     order: order,
                              //     orderDetails:
                              //         orderController.orderDetailsModel),
                            ));
                          },
                          icon: Icons.local_print_shop,
                          buttonText: 'print_invoice'.tr,
                        ),
                      )
                    : const SizedBox(),
              ])
            : const Center(child: CircularProgressIndicator()),
      );
    });
  }
}
