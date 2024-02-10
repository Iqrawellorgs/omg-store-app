import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:efood_multivendor_restaurant/controller/auth_controller.dart';
import 'package:efood_multivendor_restaurant/controller/restaurant_controller.dart';
import 'package:efood_multivendor_restaurant/controller/splash_controller.dart';
import 'package:efood_multivendor_restaurant/data/model/response/config_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/product_model.dart';
import 'package:efood_multivendor_restaurant/helper/date_converter.dart';
import 'package:efood_multivendor_restaurant/helper/price_converter.dart';
import 'package:efood_multivendor_restaurant/helper/responsive_helper.dart';
import 'package:efood_multivendor_restaurant/helper/route_helper.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_app_bar.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_button.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_image.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_restaurant/view/screens/restaurant/widget/review_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

import '../../../controller/theme_controller.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  ProductDetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  ThemeController themeController = Get.find();
  List<String?> imageList = [];
  int imageIndex = 0;
  @override
  void initState() {
    imageList.add(widget.product.image);
    imageList.addAll(widget.product.images ?? []);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool haveSubscription;
    if (Get.find<AuthController>().profileModel!.restaurants![0].restaurantModel ==
        'subscription') {
      haveSubscription = Get.find<AuthController>().profileModel!.subscription!.review == 1;
    } else {
      haveSubscription = true;
    }
    Get.find<RestaurantController>().setAvailability(widget.product.status == 1);
    Get.find<RestaurantController>().setRecommended(widget.product.recommendedStatus == 1);
    if (Get.find<AuthController>().profileModel!.restaurants![0].reviewsSection!) {
      Get.find<RestaurantController>().getProductReviewList(widget.product.id);
    }
    return Scaffold(
      appBar: CustomAppBar(title: 'food_details'.tr),
      body: SafeArea(
        child: GetBuilder<RestaurantController>(builder: (restController) {
          return Column(children: [
            Expanded(
                child: SingleChildScrollView(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              physics: const BouncingScrollPhysics(),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // ClipRRect(
                  //   borderRadius:
                  //       BorderRadius.circular(Dimensions.radiusSmall),
                  //   child: CustomImage(
                  //     image:
                  //         '${Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}/${widget.product.image}',
                  //     height: 140,
                  //     width: 140,
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  sliderImages(),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      widget.product.name!,
                      style: senBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                      // maxLines: 1,
                      overflow: TextOverflow.clip,
                    ),
                    Text(
                      '${'price'.tr}: ₹${widget.product.price}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: senRegular,
                    ),
                    Row(children: [
                      Expanded(
                          child: Text(
                        '${'discount'.tr}: ${widget.product.discountType == 'percent' ? '' : Get.find<SplashController>().configModel!.currencySymbol}${widget.product.discount} ${widget.product.discountType == 'percent' ? '%' : ''}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: senRegular,
                      )),
                      Get.find<SplashController>().configModel!.toggleVegNonVeg!
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: Dimensions.paddingSizeExtraSmall,
                                  horizontal: Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Text(
                                widget.product.veg == 0 ? 'non_veg'.tr : 'veg'.tr,
                                style: senRegular.copyWith(
                                    fontSize: Dimensions.fontSizeExtraSmall, color: Colors.white),
                              ),
                            )
                          : const SizedBox(),
                    ]),
                  ])),
                ]),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Row(children: [
                  Text('daily_time'.tr,
                      style: senRegular.copyWith(
                          color: themeController.darkTheme
                              ? Colors.white
                              : Theme.of(context).disabledColor)),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  Expanded(
                      child: Text(
                    '${DateConverter.convertStringTimeToTime(widget.product.availableTimeStarts!)}'
                    ' - ${DateConverter.convertStringTimeToTime(widget.product.availableTimeEnds!)}',
                    maxLines: 1,
                    style: senMedium.copyWith(color: Theme.of(context).primaryColor),
                  )),
                ]),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Row(children: [
                  Icon(Icons.star, color: Theme.of(context).primaryColor, size: 20),
                  Text(widget.product.avgRating!.toStringAsFixed(1), style: senRegular),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Text(
                    '(${widget.product.ratingCount} ${'ratings'.tr})',
                    style: senRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: themeController.darkTheme ? Colors.white : Colors.black),
                  ),
                ]),
                SizedBox(height: Dimensions.paddingSizeSmall),
                Row(children: [
                  Expanded(
                    child: Text(
                      'available'.tr,
                      style: senBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                    ),
                  ),
                  FlutterSwitch(
                      width: 60,
                      height: 30,
                      valueFontSize: Dimensions.fontSizeExtraSmall,
                      showOnOff: true,
                      activeColor: Theme.of(context).primaryColor,
                      value: restController.isAvailable,
                      onToggle: (bool isActive) {
                        restController.toggleAvailable(widget.product.id);
                      }),
                ]),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                Row(children: [
                  Expanded(
                    child: Text(
                      'recommended'.tr,
                      style: senBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
                    ),
                  ),
                  FlutterSwitch(
                    width: 60,
                    height: 30,
                    valueFontSize: Dimensions.fontSizeExtraSmall,
                    showOnOff: true,
                    activeColor: Theme.of(context).primaryColor,
                    value: restController.isRecommended,
                    onToggle: (bool isActive) {
                      restController.toggleRecommendedProduct(widget.product.id);
                    },
                  ),
                ]),
                const SizedBox(height: Dimensions.paddingSizeLarge),
                (widget.product.variations != null && widget.product.variations!.isNotEmpty)
                    ? Text('variations'.tr, style: senMedium)
                    : const SizedBox(),
                SizedBox(
                    height:
                        (widget.product.variations != null && widget.product.variations!.isNotEmpty)
                            ? Dimensions.paddingSizeExtraSmall
                            : 0),
                (widget.product.variations != null && widget.product.variations!.isNotEmpty)
                    ? ListView.builder(
                        itemCount: widget.product.variations!.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: Dimensions.paddingSizeExtraSmall),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Expanded(
                                  child: Text('${widget.product.variations![index].name!} - ',
                                      style:
                                          senMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
                                ),
                                Text(
                                    ' ${widget.product.variations![index].type == 'multi' ? 'multiple_select'.tr : 'single_select'.tr}'
                                    '(${widget.product.variations![index].required == 'off' ? 'optional'.tr : 'required'.tr})',
                                    style: senRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: themeController.darkTheme
                                            ? Colors.white
                                            : Theme.of(context).disabledColor)),
                              ]),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                              ListView.builder(
                                  itemCount:
                                      widget.product.variations![index].variationValues!.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.only(left: 20),
                                  shrinkWrap: true,
                                  itemBuilder: (context, i) {
                                    return Text(
                                      '${widget.product.variations![index].variationValues![i].level} - ${widget.product.variations![index].variationValues![i].optionPrice}',
                                      style: senMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                                    );
                                  }),
                            ]),
                          );
                        },
                      )
                    : const SizedBox(),
                SizedBox(
                    height:
                        (widget.product.variations != null && widget.product.variations!.isNotEmpty)
                            ? Dimensions.paddingSizeLarge
                            : 0),
                widget.product.addOns!.isNotEmpty
                    ? Text('addons'.tr, style: senMedium)
                    : const SizedBox(),
                SizedBox(
                    height:
                        widget.product.addOns!.isNotEmpty ? Dimensions.paddingSizeExtraSmall : 0),
                widget.product.addOns!.isNotEmpty
                    ? ListView.builder(
                        itemCount: widget.product.addOns!.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Row(children: [
                            Text('${widget.product.addOns![index].name!}:',
                                style: senRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                            Text(
                              PriceConverter.convertPrice(widget.product.addOns![index].price),
                              textDirection: TextDirection.ltr,
                              style: senMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                            ),
                          ]);
                        },
                      )
                    : const SizedBox(),
                SizedBox(
                    height: widget.product.addOns!.isNotEmpty ? Dimensions.paddingSizeLarge : 0),
                (widget.product.description != null && widget.product.description!.isNotEmpty)
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('description'.tr, style: senMedium),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                          Text(widget.product.description!, style: senRegular),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                        ],
                      )
                    : const SizedBox(),
                widget.product.tags != null && widget.product.tags!.isNotEmpty
                    ? Text('tags'.tr, style: senMedium)
                    : const SizedBox(),
                SizedBox(
                    height: widget.product.tags != null && widget.product.tags!.isNotEmpty
                        ? Dimensions.paddingSizeExtraSmall
                        : 0),
                widget.product.tags != null && widget.product.tags!.isNotEmpty
                    ? ListView.builder(
                        itemCount: widget.product.tags!.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Text(widget.product.tags![index].tag!,
                              style: senRegular.copyWith(fontSize: Dimensions.fontSizeSmall));
                        },
                      )
                    : const SizedBox(),
                SizedBox(
                    height: widget.product.tags != null && widget.product.tags!.isNotEmpty
                        ? Dimensions.paddingSizeLarge
                        : 0),
                Get.find<AuthController>().profileModel!.restaurants![0].reviewsSection!
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('reviews'.tr, style: senMedium),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          haveSubscription
                              ? restController.productReviewList != null
                                  ? restController.productReviewList!.isNotEmpty
                                      ? ListView.builder(
                                          itemCount: restController.productReviewList!.length,
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return ReviewWidget(
                                              review: restController.productReviewList![index],
                                              fromRestaurant: false,
                                              hasDivider: index !=
                                                  restController.productReviewList!.length - 1,
                                            );
                                          },
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                              top: Dimensions.paddingSizeLarge),
                                          child: Center(
                                              child: Text('no_review_found'.tr,
                                                  style: senRegular.copyWith(
                                                      color: themeController.darkTheme
                                                          ? Colors.white
                                                          : Theme.of(context).disabledColor))),
                                        )
                                  : const Padding(
                                      padding: EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                                      child: Center(child: CircularProgressIndicator()),
                                    )
                              : Padding(
                                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                                  child: Center(
                                      child: Text('not_available_subscription_for_reviews'.tr,
                                          style: senRegular.copyWith(
                                              color: Theme.of(context).disabledColor))),
                                ),
                        ],
                      )
                    : const SizedBox(),
              ]),
            )),
            !restController.isLoading
                ? CustomButton(
                    onPressed: () {
                      if (Get.find<AuthController>().profileModel!.restaurants![0].foodSection!) {
                        restController.getProductDetails(widget.product.id!).then((itemDetails) {
                          if (itemDetails != null) {
                            Get.toNamed(RouteHelper.getProductRoute(widget.product));
                          }
                        });
                      } else {
                        showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
                      }
                    },
                    buttonText: 'update_food'.tr,
                    margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  )
                : const Center(child: CircularProgressIndicator()),
          ]);
        }),
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
                  Get.toNamed(RouteHelper.getItemImagesRoute(widget.product, index));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                  child: CustomImage(
                    image:
                        '${Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}/${imageList[index]}',
                    height: 140,
                    width: 140,
                    fit: BoxFit.cover,
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
