import 'package:efood_multivendor_restaurant/controller/auth_controller.dart';
import 'package:efood_multivendor_restaurant/controller/restaurant_controller.dart';
import 'package:efood_multivendor_restaurant/controller/splash_controller.dart';
import 'package:efood_multivendor_restaurant/data/model/response/profile_model.dart';
import 'package:efood_multivendor_restaurant/helper/price_converter.dart';
import 'package:efood_multivendor_restaurant/helper/route_helper.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/images.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_image.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_restaurant/view/screens/restaurant/widget/product_view.dart';
import 'package:efood_multivendor_restaurant/view/screens/restaurant/widget/review_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/theme_controller.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  TabController? _tabController;
  final bool? _review = Get.find<AuthController>().profileModel!.restaurants![0].reviewsSection;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: _review! ? 2 : 1, initialIndex: 0, vsync: this);
    _tabController!.addListener(() {
      Get.find<RestaurantController>().setTabIndex(_tabController!.index);
    });
    Get.find<RestaurantController>().getProductList('1', 'all');
    Get.find<RestaurantController>()
        .getRestaurantReviewList(Get.find<AuthController>().profileModel!.restaurants![0].id);
  }

  ThemeController themeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restController) {
      return GetBuilder<AuthController>(builder: (authController) {
        bool haveSubscription;
        if (authController.profileModel!.restaurants![0].restaurantModel == 'subscription') {
          haveSubscription = authController.profileModel!.subscription!.review == 1;
        } else {
          haveSubscription = true;
        }
        Restaurant? restaurant = authController.profileModel != null
            ? authController.profileModel!.restaurants![0]
            : null;

        return Scaffold(
          backgroundColor: Theme.of(context).cardColor,
          floatingActionButton: restController.tabIndex == 0
              ? FloatingActionButton(
                  heroTag: 'nothing',
                  onPressed: () {
                    if (Get.find<AuthController>().profileModel!.restaurants![0].foodSection!) {
                      if (Get.find<AuthController>().profileModel!.subscriptionOtherData != null &&
                          Get.find<AuthController>()
                                  .profileModel!
                                  .subscriptionOtherData!
                                  .maxProductUpload ==
                              0 &&
                          Get.find<AuthController>()
                                  .profileModel!
                                  .restaurants![0]
                                  .restaurantModel ==
                              'subscription') {
                        showCustomSnackBar('your_food_add_limit_is_over'.tr);
                      } else {
                        if (restaurant != null) {
                          // TODO: add product
                          Get.toNamed(RouteHelper.getProductRoute(null, restaurant));
                        }
                      }
                    } else {
                      showCustomSnackBar('this_feature_is_blocked_by_admin'.tr);
                    }
                  },
                  backgroundColor: Theme.of(context).primaryColor,
                  child:
                      Icon(Icons.add_circle_outline, color: Theme.of(context).cardColor, size: 30),
                )
              : null,
          body: restaurant != null
              ? CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 230,
                      toolbarHeight: 50,
                      pinned: true,
                      floating: false,
                      backgroundColor: Theme.of(context).primaryColor,
                      actions: [
                        IconButton(
                          icon: Container(
                            height: 50,
                            width: 50,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                            child: Image.asset(Images.edit),
                          ),
                          onPressed: () =>
                              Get.toNamed(RouteHelper.getRestaurantSettingsRoute(restaurant)),
                        )
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        background: CustomImage(
                          fit: BoxFit.cover,
                          placeholder: Images.restaurantCover,
                          image:
                              '${restaurant.coverPhoto}', //${Get.find<SplashController>().configModel!.baseUrls!.restaurantCoverPhotoUrl}/
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                        child: Center(
                            child: Container(
                      width: 1170,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: Dimensions.paddingSizeSmall),
                      color: Theme.of(context).cardColor,
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                child: CustomImage(
                                  image: '${restaurant.logo}',
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              const SizedBox(width: Dimensions.paddingSizeSmall),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      restaurant.name!,
                                      style: senBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                                      // maxLines: 1,
                                      overflow: TextOverflow.clip,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      restaurant.address ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: senRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall,
                                          color: themeController.darkTheme
                                              ? Colors.white
                                              : Theme.of(context).disabledColor),
                                    ),
                                    const SizedBox(height: Dimensions.paddingSizeSmall),
                                    Row(
                                      children: [
                                        Icon(Icons.star,
                                            color: Theme.of(context).primaryColor, size: 18),
                                        const SizedBox(width: 5),
                                        Text(
                                          restaurant.avgRating!.toStringAsFixed(1),
                                          style: senRegular.copyWith(
                                              fontSize: Dimensions.fontSizeSmall),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          '(${restaurant.ratingCount} ${'ratings'.tr})',
                                          style: senRegular.copyWith(
                                              fontSize: Dimensions.fontSizeSmall,
                                              color: themeController.darkTheme
                                                  ? Colors.white
                                                  : Colors.black),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          // _restaurant.availableTimeStarts != null ? Row(children: [
                          //   Text('daily_time'.tr, style: robotoRegular.copyWith(
                          //     fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).disabledColor,
                          //   )),
                          //   SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          //   Text(
                          //     '${DateConverter.convertStringTimeToTime(_restaurant.availableTimeStarts)}'
                          //         ' - ${DateConverter.convertStringTimeToTime(_restaurant.availableTimeEnds)}',
                          //     style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Theme.of(context).primaryColor),
                          //   ),
                          // ]) : SizedBox(),
                          // SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                          // Row(children: [
                          //   Icon(Icons.star, color: Theme.of(context).primaryColor, size: 18),
                          //   const SizedBox(width: 5),
                          //   Text(
                          //     restaurant.avgRating!.toStringAsFixed(1),
                          //     style: senRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                          //   ),
                          //   const SizedBox(width: 5),
                          //   Text(
                          //     '(${restaurant.ratingCount} ${'ratings'.tr})',
                          //     style: senRegular.copyWith(
                          //         fontSize: Dimensions.fontSizeSmall,
                          //         color: themeController.darkTheme ? Colors.white : Colors.black),
                          //   ),
                          // ]),
                          // const SizedBox(height: Dimensions.paddingSizeSmall),

                          restaurant.discount != null
                              ? Container(
                                  width: context.width,
                                  margin:
                                      const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                      color: Theme.of(context).primaryColor),
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${restaurant.discount!.discount}% ${'off'.tr}',
                                          style: senMedium.copyWith(
                                              fontSize: Dimensions.fontSizeLarge,
                                              color: themeController.darkTheme
                                                  ? Colors.white
                                                  : Theme.of(context).cardColor),
                                          textDirection: TextDirection.ltr,
                                        ),
                                        Text(
                                          '${'enjoy'.tr} ${restaurant.discount!.discount}% ${'off_on_all_categories'.tr}',
                                          style: senMedium.copyWith(
                                              fontSize: Dimensions.fontSizeSmall,
                                              color: themeController.darkTheme
                                                  ? Colors.white
                                                  : Theme.of(context).cardColor),
                                          textDirection: TextDirection.ltr,
                                        ),
                                        SizedBox(
                                            height: (restaurant.discount!.minPurchase != 0 ||
                                                    restaurant.discount!.maxDiscount != 0)
                                                ? 5
                                                : 0),
                                        restaurant.discount!.minPurchase != 0
                                            ? Text(
                                                '[ ${'minimum_purchase'.tr}: ${PriceConverter.convertPrice(restaurant.discount!.minPurchase)} ]',
                                                style: senRegular.copyWith(
                                                    fontSize: Dimensions.fontSizeExtraSmall,
                                                    color: themeController.darkTheme
                                                        ? Colors.white
                                                        : Theme.of(context).cardColor),
                                                textDirection: TextDirection.ltr,
                                              )
                                            : const SizedBox(),
                                        restaurant.discount!.maxDiscount != 0
                                            ? Text(
                                                '[ ${'maximum_discount'.tr}: ${PriceConverter.convertPrice(restaurant.discount!.maxDiscount)} ]',
                                                style: senRegular.copyWith(
                                                    fontSize: Dimensions.fontSizeExtraSmall,
                                                    color: themeController.darkTheme
                                                        ? Colors.white
                                                        : Theme.of(context).cardColor),
                                                textDirection: TextDirection.ltr,
                                              )
                                            : const SizedBox(),
                                      ]),
                                )
                              : const SizedBox.shrink(),

                          (restaurant.delivery! && restaurant.freeDelivery!)
                              ? Text(
                                  'free_delivery'.tr,
                                  style: senRegular.copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: Theme.of(context).primaryColor),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ))),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: SliverDelegate(
                          child: Center(
                              child: Container(
                        width: 1170,
                        decoration: BoxDecoration(color: Theme.of(context).cardColor),
                        child: TabBar(
                          controller: _tabController,
                          indicatorColor: Theme.of(context).primaryColor,
                          indicatorWeight: 3,
                          labelColor: Theme.of(context).primaryColor,
                          unselectedLabelColor: themeController.darkTheme
                              ? Colors.white
                              : Theme.of(context).disabledColor,
                          unselectedLabelStyle: senRegular.copyWith(
                              color: themeController.darkTheme
                                  ? Colors.white
                                  : Theme.of(context).disabledColor,
                              fontSize: Dimensions.fontSizeSmall),
                          labelStyle: senBold.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).primaryColor),
                          tabs: _review!
                              ? [
                                  Tab(text: 'all_foods'.tr),
                                  Tab(text: 'reviews'.tr),
                                ]
                              : [
                                  Tab(text: 'all_foods'.tr),
                                ],
                        ),
                      ))),
                    ),
                    SliverToBoxAdapter(
                        child: AnimatedBuilder(
                      animation: _tabController!.animation!,
                      builder: (context, child) {
                        if (_tabController!.index == 0) {
                          return ProductView(
                            scrollController: _scrollController,
                            type: restController.type,
                            onVegFilterTap: (String type) {
                              Get.find<RestaurantController>().getProductList('1', type);
                            },
                            restaurant: restaurant,
                          );
                        } else {
                          return haveSubscription
                              ? restController.restaurantReviewList != null
                                  ? restController.restaurantReviewList!.isNotEmpty
                                      ? ListView.builder(
                                          itemCount: restController.restaurantReviewList!.length,
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: Dimensions.paddingSizeLarge),
                                          itemBuilder: (context, index) {
                                            return ReviewWidget(
                                              review: restController.restaurantReviewList![index],
                                              fromRestaurant: true,
                                              hasDivider: index !=
                                                  restController.restaurantReviewList!.length - 1,
                                            );
                                          },
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                              top: Dimensions.paddingSizeLarge),
                                          child: Center(
                                              child: Text('no_review_found'.tr,
                                                  style: senRegular.copyWith(
                                                      color: Theme.of(context).disabledColor))),
                                        )
                                  : const Padding(
                                      padding: EdgeInsets.only(top: Dimensions.paddingSizeLarge),
                                      child: Center(child: CircularProgressIndicator()),
                                    )
                              : Padding(
                                  padding: const EdgeInsets.only(top: 50),
                                  child: Center(
                                      child: Text('you_have_no_available_subscription'.tr,
                                          style: senRegular.copyWith(
                                              color: Theme.of(context).disabledColor))),
                                );
                        }
                      },
                    )),
                  ],
                )
              : const Center(child: CircularProgressIndicator()),
        );
      });
    });
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 || oldDelegate.minExtent != 50 || child != oldDelegate.child;
  }
}
