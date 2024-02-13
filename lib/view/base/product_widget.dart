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
import 'package:efood_multivendor_restaurant/util/images.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/confirmation_dialog.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_image.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_restaurant/view/base/discount_tag.dart';
import 'package:efood_multivendor_restaurant/view/base/not_available_widget.dart';
import 'package:efood_multivendor_restaurant/view/base/rating_bar.dart';
import 'package:efood_multivendor_restaurant/view/screens/restaurant/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/theme_controller.dart';

class ProductWidget extends StatefulWidget {
  final Product product;
  final int index;
  final int length;
  final bool inRestaurant;
  final bool isCampaign;
  ProductWidget(
      {Key? key,
      required this.product,
      required this.index,
      required this.length,
      this.inRestaurant = false,
      this.isCampaign = false})
      : super(key: key);

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
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
    BaseUrls? baseUrls = Get.find<SplashController>().configModel!.baseUrls;
    bool desktop = ResponsiveHelper.isDesktop(context);
    double? discount;
    String? discountType;
    bool isAvailable;
    discount = (widget.product.restaurantDiscount == 0 || widget.isCampaign)
        ? widget.product.discount
        : widget.product.restaurantDiscount;
    discountType = (widget.product.restaurantDiscount == 0 || widget.isCampaign)
        ? widget.product.discountType
        : 'percent';
    isAvailable = DateConverter.isAvailable(
            widget.product.availableTimeStarts, widget.product.availableTimeEnds) &&
        DateConverter.isAvailable(
            widget.product.restaurantOpeningTime, widget.product.restaurantClosingTime);

    return InkWell(
      onTap: () => Get.toNamed(RouteHelper.getProductDetailsRoute(widget.product),
          arguments: ProductDetailsScreen(product: widget.product)),
      child: Container(
        padding: ResponsiveHelper.isDesktop(context)
            ? const EdgeInsets.all(Dimensions.paddingSizeSmall)
            : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          color: ResponsiveHelper.isDesktop(context) ? Theme.of(context).cardColor : null,
          boxShadow: ResponsiveHelper.isDesktop(context)
              ? [
                  BoxShadow(
                    color: Colors.grey[Get.isDarkMode ? 700 : 300]!,
                    spreadRadius: 1,
                    blurRadius: 5,
                  )
                ]
              : null,
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(vertical: desktop ? 0 : Dimensions.paddingSizeExtraSmall),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // (widget.product.image != null && widget.product.image!.isNotEmpty)
              //     ? Stack(children: [
              //         ClipRRect(
              //           borderRadius:
              //               BorderRadius.circular(Dimensions.radiusSmall),
              //           child: CustomImage(
              //             image:
              //                 '${widget.isCampaign ? baseUrls!.campaignImageUrl : baseUrls!.productImageUrl}/${widget.product.image}',
              //             height: desktop ? 120 : 120,
              //             width: desktop ? 120 : 120,
              //             fit: BoxFit.cover,
              //           ),
              //         ),
              //         isAvailable
              //             ? const SizedBox()
              //             : const NotAvailableWidget(isRestaurant: false),
              //       ])
              //     : const SizedBox(),
              sliderImages(
                baseUrls!,
                desktop,
                isAvailable,
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      (discount! > 0 || false)
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                // borderRadius: const BorderRadius.horizontal(
                                //     right: Radius.circular(
                                //         Dimensions.radiusSmall)),
                              ),
                              child: Text(
                                discount! > 0
                                    ? '${discountType == 'percent' ? '' : Get.find<SplashController>().configModel!.currencySymbol}$discount${discountType == 'percent' ? '%' : ''} ${'off'.tr}'
                                    : 'free_delivery'.tr,
                                style: senMedium.copyWith(
                                  color: Colors.white,
                                  fontSize: (ResponsiveHelper.isMobile(context) ? 8 : 12),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : const SizedBox(),
                      // DiscountTag(
                      //   discount: discount,
                      //   discountType: discountType,
                      //   freeDelivery: false,
                      // ),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      Text(
                        widget.product.name!,
                        style: senBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                        maxLines: desktop ? 2 : null,
                        overflow: TextOverflow.clip,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      RatingBar(
                        rating: widget.product.avgRating,
                        size: desktop ? 15 : 15,
                        ratingCount: widget.product.ratingCount,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      Row(children: [
                        Text(
                          PriceConverter.convertPrice(widget.product.price,
                              discount: discount, discountType: discountType),
                          style: senBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                          textDirection: TextDirection.ltr,
                        ),
                        SizedBox(width: discount! > 0 ? Dimensions.paddingSizeExtraSmall : 0),
                        discount > 0
                            ? Text(
                                PriceConverter.convertPrice(widget.product.price),
                                textDirection: TextDirection.ltr,
                                style: senMedium.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: themeController.darkTheme
                                      ? Colors.white
                                      : Theme.of(context).disabledColor,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              )
                            : const SizedBox(),
                        (widget.product.image != null && widget.product.image!.isNotEmpty)
                            ? const SizedBox()
                            : Text(
                                '(${discount > 0 ? '$discount${discountType == 'percent' ? '%' : Get.find<SplashController>().configModel!.currencySymbol}${'off'.tr}' : 'free_delivery'.tr})',
                                style: senMedium.copyWith(
                                    color: themeController.darkTheme
                                        ? Colors.white
                                        : Theme.of(context).primaryColor,
                                    fontSize: ResponsiveHelper.isMobile(context) ? 8 : 12),
                                textAlign: TextAlign.center,
                              ),
                      ]),
                    ]),
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      if (Get.find<AuthController>().profileModel!.restaurants![0].foodSection!) {
                        Get.dialog(ConfirmationDialog(
                          icon: Images.warning,
                          description: 'are_you_sure_want_to_delete_this_product'.tr,
                          onYesPressed: () =>
                              Get.find<RestaurantController>().deleteProduct(widget.product.id),
                        ));
                      } else {
                        showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
                      }
                    },
                    icon: const Icon(Icons.delete_forever, color: Colors.red),
                  ),
                  IconButton(
                    onPressed: () {
                      if (Get.find<AuthController>().profileModel!.restaurants![0].foodSection!) {
                        Get.find<RestaurantController>()
                            .getProductDetails(widget.product.id!)
                            .then((itemDetails) {
                          if (itemDetails != null) {
                            itemDetails.variations = widget.product.variations;
                            Get.toNamed(RouteHelper.getProductRoute(itemDetails));
                          }
                        });
                      } else {
                        showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
                      }
                    },
                    icon: const Icon(Icons.edit, color: Colors.blue),
                  ),
                ],
              ),
            ]),
          )),
          // desktop
          //     ? const SizedBox()
          //     : Padding(
          //         padding: EdgeInsets.only(left: desktop ? 130 : 0),
          //         child: Divider(
          //             color: widget.index == widget.length - 1
          //                 ? Colors.transparent
          //                 : Theme.of(context).disabledColor),
          //       ),
        ]),
      ),
    );
  }

  Widget sliderImages(BaseUrls baseUrl, bool isDeskTop, bool isAvailable) {
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
                onTap: widget.isCampaign
                    ? null
                    : () {
                        if (!widget.isCampaign) {
                          Get.toNamed(RouteHelper.getItemImagesRoute(widget.product, index));
                        }
                      },
                child: Stack(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    child: CustomImage(
                      image:
                          '${widget.isCampaign ? baseUrl!.campaignImageUrl : baseUrl!.productImageUrl}/${imageList[index]}',
                      height: isDeskTop ? 120 : 120,
                      width: isDeskTop ? 120 : 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  isAvailable ? const SizedBox() : const NotAvailableWidget(isRestaurant: false),
                ]),
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
