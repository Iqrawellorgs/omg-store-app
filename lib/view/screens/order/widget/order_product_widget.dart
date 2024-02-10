import 'package:carousel_slider/carousel_slider.dart';
import 'package:efood_multivendor_restaurant/controller/splash_controller.dart';
import 'package:efood_multivendor_restaurant/data/model/response/order_details_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/order_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/product_model.dart';
import 'package:efood_multivendor_restaurant/helper/price_converter.dart';
import 'package:efood_multivendor_restaurant/helper/responsive_helper.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_image.dart';
import 'package:efood_multivendor_restaurant/view/screens/chat/widget/image_dialog.dart';
import 'package:efood_multivendor_restaurant/view/screens/image_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/theme_controller.dart';
import '../../../../helper/route_helper.dart';

class OrderProductWidget extends StatefulWidget {
  final OrderModel? order;
  final OrderDetailsModel orderDetails;
  const OrderProductWidget({Key? key, required this.order, required this.orderDetails})
      : super(key: key);

  @override
  State<OrderProductWidget> createState() => _OrderProductWidgetState();
}

class _OrderProductWidgetState extends State<OrderProductWidget> {
  List<String?> imageList = [];
  int imageIndex = 0;
  @override
  void initState() {
    if (widget.orderDetails.foodDetails!.image != null &&
        widget.orderDetails.foodDetails!.image!.isNotEmpty) {
      imageList.add(widget.orderDetails.foodDetails!.image);
    }
    imageList.addAll(widget.orderDetails.foodDetails?.images ?? []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String addOnText = '';
    for (var addOn in widget.orderDetails.addOns!) {
      addOnText = '$addOnText${(addOnText.isEmpty) ? '' : ', '} ${addOn.name}(${addOn.quantity})';
    }

    String variationText = '';
    if (widget.orderDetails.variation!.isNotEmpty) {
      for (Variation variation in widget.orderDetails.variation ?? []) {
        // variationText =
        // '${variationText!}${variationText.isNotEmpty ? ', ' : ''}';
        for (VariationOption value in variation.variationValues!) {
          variationText +=
              '${variationText.endsWith(', ') ? '' : variation.variationValues?.indexOf(value) == 0 && widget.orderDetails.variation?.indexOf(variation) == 0 ? '' : ', '}${value.level}';
        }
        // variationText = variationText!;
      }
      List texts = variationText.split('');
      if (texts.length > 2 && (texts[texts.length - 2]) == ',') {
        texts.removeLast();
        texts.removeLast();
        variationText = texts.join('');
      }
      print('variationText: $variationText');
    } else if (widget.orderDetails.oldVariation!.isNotEmpty) {
      variationText = widget.orderDetails.oldVariation?[0].type ?? '';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          // height: 160,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // (widget.orderDetails.foodDetails!.image != null &&
                      //         widget
                      //             .orderDetails.foodDetails!.image!.isNotEmpty)
                      //     ? InkWell(
                      //         onTap: () {
                      //           Get.to(() => ImageViewerScreen(
                      //               imageUrl:
                      //                   '${widget.orderDetails.itemCampaignId != null ? Get.find<SplashController>().configModel!.baseUrls!.campaignImageUrl : Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}/'
                      //                   '${widget.orderDetails.foodDetails!.image}'));
                      //         },
                      //         child: ClipRRect(
                      //           borderRadius: BorderRadius.circular(
                      //               Dimensions.radiusSmall),
                      //           child: CustomImage(
                      //             height: 120,
                      //             width: 120,
                      //             fit: BoxFit.cover,
                      //             image:
                      //                 '${widget.orderDetails.itemCampaignId != null ? Get.find<SplashController>().configModel!.baseUrls!.campaignImageUrl : Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}/'
                      //                 '${widget.orderDetails.foodDetails!.image}',
                      //           ),
                      //         ),
                      //       )
                      //     : const SizedBox(),
                      sliderImages(),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            widget.orderDetails.foodDetails!.name!,
                            style: senBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                            // maxLines: 2,
                            overflow: TextOverflow.clip,
                          ),
                          Row(children: [
                            Text('${'quantity'.tr}:',
                                style: senRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                            Text(
                              widget.orderDetails.quantity.toString(),
                              style: senMedium.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: Dimensions.fontSizeSmall),
                            ),
                          ]),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                          Row(children: [
                            FittedBox(
                                child: Text(
                              PriceConverter.convertPrice(widget.orderDetails.price),
                              style: senMedium,
                              textDirection: TextDirection.ltr,
                            )),
                            Get.find<SplashController>().configModel!.toggleVegNonVeg!
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: Dimensions.paddingSizeExtraSmall,
                                        horizontal: Dimensions.paddingSizeSmall),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                                    ),
                                    child: Text(
                                      widget.orderDetails.foodDetails!.veg == 0
                                          ? 'non_veg'.tr
                                          : 'veg'.tr,
                                      style: senRegular.copyWith(
                                          fontSize: Dimensions.fontSizeExtraSmall,
                                          color: Theme.of(context).primaryColor),
                                    ),
                                  )
                                : const SizedBox(),
                          ]),
                          (widget.orderDetails.foodDetails?.variations != null &&
                                      widget.orderDetails.foodDetails!.variations!.isNotEmpty ||
                                  addOnText.isNotEmpty)
                              ? Padding(
                                  padding:
                                      const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                                  child: Text(
                                      "$variationText${(variationText != '' && addOnText != '') ? ', ' : ''}$addOnText",
                                      style: senRegular.copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        overflow: TextOverflow.clip,
                                        color: Get.find<ThemeController>().darkTheme
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                                )
                              : const SizedBox(),
                        ]),
                      ),
                    ]),
                if (widget.orderDetails.specialNote != null &&
                    widget.orderDetails.specialNote!.isNotEmpty) ...[
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          'Special Instructions: ${widget.orderDetails.specialNote ?? ""}',
                          style: senMedium.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              fontWeight: FontWeight.w300,
                              color: Theme.of(context).disabledColor),
                        ),
                      ),
                    ],
                  )
                ],
                // addOnText.isNotEmpty
                //     ? Padding(
                //         padding: const EdgeInsets.only(
                //             top: Dimensions.paddingSizeExtraSmall),
                //         child: Row(children: [
                //           const SizedBox(width: 60),
                //           Text('${'addons'.tr}: ',
                //               style: robotoMedium.copyWith(
                //                   fontSize: Dimensions.fontSizeSmall)),
                //           Flexible(
                //               child: Text(addOnText,
                //                   style: robotoRegular.copyWith(
                //                     fontSize: Dimensions.fontSizeSmall,
                //                     color: Theme.of(context).disabledColor,
                //                   ))),
                //         ]),
                //       )
                //     : const SizedBox(),
                const Divider(height: Dimensions.paddingSizeLarge),
                const SizedBox(height: Dimensions.paddingSizeSmall),
              ]),
        ),
      ),
    );
  }

  Widget sliderImages() {
    return Column(
      children: [
        SizedBox(
          width: ResponsiveHelper.isMobile(context) ? 130 : 140,
          height: ResponsiveHelper.isMobile(context) ? 130 : 140,
          child: CarouselSlider.builder(
            options: CarouselOptions(
              autoPlay: false,
              viewportFraction: 1,
              initialPage: 0,
              // autoPlayInterval: const Duration(seconds: 7),
              onPageChanged: (index, reason) {
                setState(() {
                  imageIndex = index;
                });
              },
            ),
            itemCount: imageList.length,
            itemBuilder: (context, index, _) {
              return InkWell(
                onTap: () {
                  Get.to(() => ImageViewerScreen(
                      imageUrl:
                          '${widget.orderDetails.itemCampaignId != null ? Get.find<SplashController>().configModel!.baseUrls!.campaignImageUrl : Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}/'
                          '${imageList[index]}'));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: CustomImage(
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                    image:
                        '${widget.orderDetails.itemCampaignId != null ? Get.find<SplashController>().configModel!.baseUrls!.campaignImageUrl : Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}/'
                        '${imageList[index]}',
                  ),
                ),
              );
            },
          ),
        ),
        // const SizedBox(height: Dimensions.paddingSizeSmall),
        if (imageList.length > 1) ...[
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              for (int i = 0; i < imageList.length; i++)
                Container(
                  height: 5,
                  width: 5,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: imageIndex == i
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).disabledColor,
                  ),
                ),
            ],
          ),
        ]
      ],
    );
  }
}
