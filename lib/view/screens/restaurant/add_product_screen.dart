// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:efood_multivendor_restaurant/controller/addon_controller.dart';
import 'package:efood_multivendor_restaurant/controller/restaurant_controller.dart';
import 'package:efood_multivendor_restaurant/controller/splash_controller.dart';
import 'package:efood_multivendor_restaurant/data/model/body/variation_model_body.dart';
import 'package:efood_multivendor_restaurant/data/model/response/config_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/product_model.dart';
import 'package:efood_multivendor_restaurant/data/model/response/profile_model.dart';
import 'package:efood_multivendor_restaurant/helper/custom_print.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/images.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_app_bar.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_button.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_image.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_time_picker.dart';
import 'package:efood_multivendor_restaurant/view/base/my_text_field.dart';
import 'package:efood_multivendor_restaurant/view/screens/restaurant/widget/variation_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../controller/theme_controller.dart';

class AddProductScreen extends StatefulWidget {
  final Product? product;
  final Restaurant restaurant;
  const AddProductScreen({Key? key, required this.product, required this.restaurant})
      : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  List<Translation> translations = [];

  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  TextEditingController _c = TextEditingController();
  final FocusNode _priceNode = FocusNode();
  final FocusNode _discountNode = FocusNode();
  late bool _update;
  Product? _product;
  ThemeController themeController = Get.find();
  //ctrl from namescreen
  final List<TextEditingController> _nameControllerList = [];
  final List<TextEditingController> _descriptionControllerList = [];
  final List<FocusNode> _nameFocusList = [];
  final List<FocusNode> _descriptionFocusList = [];
  final List<Language>? _languageList = Get.find<SplashController>().configModel!.language;
  @override
  void initState() {
    super.initState();
    Get.find<RestaurantController>().initRestaurantData(widget.restaurant);
//initfrom addname

    if (widget.product != null) {
      for (int index = 0; index < _languageList!.length; index++) {
        _nameControllerList.add(TextEditingController(
            /*text: widget.product!.translations![widget.product!.translations!.length-2].value,*/
            ));
        _descriptionControllerList.add(TextEditingController(
            /*text: widget.product!.translations![widget.product!.translations!.length-1].value,*/
            ));
        _nameFocusList.add(FocusNode());
        _descriptionFocusList.add(FocusNode());
        for (var translation in widget.product!.translations!) {
          if (_languageList![index].key == translation.locale && translation.key == 'name') {
            _nameControllerList[index] = TextEditingController(text: translation.value);
          } else if (_languageList![index].key == translation.locale &&
              translation.key == 'description') {
            _descriptionControllerList[index] = TextEditingController(text: translation.value);
          }
        }
      }
    } else {
      for (var language in _languageList!) {
        _nameControllerList.add(TextEditingController());
        _descriptionControllerList.add(TextEditingController());
        _nameFocusList.add(FocusNode());
        _descriptionFocusList.add(FocusNode());
        customPrint(language);
      }
    }
//
    //clear old selection
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Get.find<RestaurantController>().clearOldImages();
    });

    _product = widget.product;
    _update = widget.product != null;
    Get.find<RestaurantController>().initializeTags();
    Get.find<RestaurantController>().getAttributeList(widget.product);
    if (_update) {
      if (_product!.tags != null && _product!.tags!.isNotEmpty) {
        for (var tag in _product!.tags!) {
          Get.find<RestaurantController>().setTag(tag.tag, isUpdate: false);
        }
      }
      _priceController.text = _product!.price.toString();
      _discountController.text = _product!.discount.toString();
      Get.find<RestaurantController>()
          .setDiscountTypeIndex(_product!.discountType == 'percent' ? 0 : 1, false);
      // Get.find<RestaurantController>().setVeg(_product!.veg == 1, false);
      Get.find<RestaurantController>().setExistingVariation(_product!.variations);
    } else {
      Get.find<RestaurantController>().setEmptyVariationList();
      _product = Product();
      Get.find<RestaurantController>().pickImage(false, true);
      // Get.find<RestaurantController>().setVeg(false, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.product != null ? 'update_food'.tr : 'add_food'.tr),
      body: SafeArea(
        child: GetBuilder<RestaurantController>(builder: (restController) {
          return restController.categoryList != null
              ? Column(children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: _languageList!.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  // Text(_languageList![index].value!, style: robotoBold),
                                  const SizedBox(height: Dimensions.paddingSizeSmall),
                                  MyTextField(
                                    hintText: '${'food_name'.tr} *',
                                    controller: _nameControllerList[index],
                                    capitalization: TextCapitalization.words,
                                    focusNode: _nameFocusList[index],
                                    nextFocus: _descriptionFocusList[index],
                                  ),
                                  const SizedBox(height: Dimensions.paddingSizeLarge),
                                ],
                              );
                            },
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${"Primary Image"} *',
                                    style: senRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: Theme.of(context).disabledColor),
                                  ),
                                  SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                  Text(
                                    '(${'max_size_2_mb'.tr})',
                                    style: senRegular.copyWith(
                                        fontSize: Dimensions.fontSizeExtraSmall,
                                        color: Theme.of(context).colorScheme.error),
                                  ),
                                  Row(
                                    children: [
                                      Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(Dimensions.radiusSmall),
                                            child: restController.pickedLogo != null
                                                ? GetPlatform.isWeb
                                                    ? Image.network(
                                                        restController.pickedLogo!.path,
                                                        width: 150,
                                                        height: 120,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.file(
                                                        File(restController.pickedLogo!.path),
                                                        width: 150,
                                                        height: 120,
                                                        fit: BoxFit.cover,
                                                      )
                                                : FadeInImage.assetNetwork(
                                                    placeholder: Images.placeholder,
                                                    image:
                                                        // '_product!.image ?? '',
                                                        '${Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}/${_product!.image ?? ''}',
                                                    height: 120,
                                                    width: 150,
                                                    fit: BoxFit.cover,
                                                    imageErrorBuilder: (c, o, s) => Container(
                                                      width: 150,
                                                      height: 122,
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(
                                                            Dimensions.paddingSizeSmall),
                                                        // border: Border.all(
                                                        //   color: Theme.of(context).primaryColor,
                                                        //   width: 2,
                                                        // ),
                                                      ),
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                            Dimensions.paddingSizeDefault),
                                                        decoration: BoxDecoration(
                                                          // border: Border.all(
                                                          //     width: 2,
                                                          //     color:
                                                          //         Theme.of(context).primaryColor),
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: Icon(
                                                          Icons.add_a_photo,
                                                          size: 35,
                                                          color: Theme.of(context).disabledColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            top: 0,
                                            left: 0,
                                            child: InkWell(
                                              onTap: () => restController.pickImage(true, false),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  // color: Colors.black.withOpacity(0.3),
                                                  borderRadius: BorderRadius.circular(
                                                      Dimensions.paddingSizeSmall),
                                                  border: Border.all(
                                                      width: 2,
                                                      color: Theme.of(context).primaryColor),
                                                ),
                                                // child: Container(
                                                //   margin: EdgeInsets.all(25),
                                                //   decoration: BoxDecoration(
                                                //     border:
                                                //         Border.all(width: 2, color: Colors.white),
                                                //     shape: BoxShape.circle,
                                                //   ),
                                                //   child:
                                                //       Icon(Icons.camera_alt, color: Colors.white),
                                                // ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            'Secondary Image *'.tr,
                                            style: senRegular.copyWith(
                                                fontSize: Dimensions.fontSizeSmall,
                                                color: Theme.of(context).disabledColor),
                                          ),
                                          SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                          Text(
                                            '(${'max_size_2_mb'.tr})',
                                            style: senRegular.copyWith(
                                                fontSize: Dimensions.fontSizeExtraSmall,
                                                color: Theme.of(context).errorColor),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: Dimensions.paddingSizeDefault),
                                      InkWell(
                                        onTap: () {
                                          if ((restController.savedImages.length +
                                                  restController.rawImages.length) <
                                              6) {
                                            restController.pickImages();
                                          } else {
                                            showCustomSnackBar('maximum_image_limit_is_6'.tr);
                                          }
                                        },
                                        child: Icon(Icons.add_circle_outline,
                                            color: Theme.of(context).primaryColor),
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if ((restController.savedImages.length +
                                              restController.rawImages.length) <
                                          6) {
                                        restController.pickImages();
                                      } else {
                                        showCustomSnackBar('maximum_image_limit_is_6'.tr);
                                      }
                                    },
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(Dimensions.radiusSmall),
                                          child: restController.savedImages.isNotEmpty
                                              ? CustomImage(
                                                  image:
                                                      '${Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}/${restController.savedImages[0]}',
                                                  height: 120,
                                                  width: 150,
                                                  fit: BoxFit.cover,
                                                )
                                              : restController.rawImages.isNotEmpty
                                                  ? GetPlatform.isWeb
                                                      ? Image.network(
                                                          restController.rawImages[0].path,
                                                          height: 120,
                                                          width: 150,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Container(
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color:
                                                                    Theme.of(context).primaryColor,
                                                                width: 2),
                                                            borderRadius: BorderRadius.circular(
                                                                Dimensions.radiusSmall),
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(
                                                                Dimensions.radiusSmall),
                                                            child: Image.file(
                                                              File(
                                                                  restController.rawImages[0].path),
                                                              height: 120,
                                                              width: 150,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        )
                                                  : FadeInImage.assetNetwork(
                                                      placeholder: Images.placeholder,
                                                      image: _product!.image ?? '',
                                                      // '${Get.find<SplashController>().configModel.baseUrls.itemImageUrl}/${_item.image != null ? _item.image : ''}',
                                                      height: 120,
                                                      width: 150,
                                                      fit: BoxFit.cover,
                                                      imageErrorBuilder: (c, o, s) => Container(
                                                        width: 150,
                                                        height: 122,
                                                        alignment: Alignment.center,
                                                        // decoration: BoxDecoration(
                                                        //   borderRadius: BorderRadius.circular(
                                                        //       Dimensions.paddingSizeSmall),
                                                        //   border: Border.all(
                                                        //     color: Theme.of(context).primaryColor,
                                                        //     width: 2,
                                                        //   ),
                                                        // ),
                                                        child: Container(
                                                          padding: EdgeInsets.all(
                                                              Dimensions.paddingSizeDefault),
                                                          child: Icon(
                                                            Icons.add_a_photo,
                                                            size: 35,
                                                            color: Theme.of(context).disabledColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          top: 0,
                                          left: 0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              // color: Colors.black.withOpacity(0.3),
                                              borderRadius: BorderRadius.circular(
                                                  Dimensions.paddingSizeSmall),
                                              border: Border.all(
                                                  width: 2, color: Theme.of(context).primaryColor),
                                            ),
                                            // child: Container(
                                            //   margin: EdgeInsets.all(25),
                                            //   decoration: BoxDecoration(
                                            //     border:
                                            //         Border.all(width: 2, color: Colors.white),
                                            //     shape: BoxShape.circle,
                                            //   ),
                                            //   child:
                                            //       Icon(Icons.camera_alt, color: Colors.white),
                                            // ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: InkWell(
                                            onTap: () {
                                              if (restController.savedImages.isNotEmpty) {
                                                restController.removeSavedImage(0);
                                              } else {
                                                restController.removeImage(
                                                    0 - restController.savedImages.length);
                                              }
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.all(Dimensions.paddingSizeSmall),
                                              child: restController.rawImages.isNotEmpty ||
                                                      restController.savedImages.isNotEmpty
                                                  ? Icon(Icons.delete_forever, color: Colors.red)
                                                  : null,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),

                          SizedBox(height: Dimensions.paddingSizeExtraSmall),
                          restController.savedImages.length + restController.rawImages.length > 1
                              ? SizedBox(
                                  height: 100,
                                  child: GridView.builder(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      childAspectRatio: 1 / 1,
                                      mainAxisSpacing: Dimensions.paddingSizeSmall,
                                      crossAxisSpacing: Dimensions.paddingSizeSmall,
                                    ),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: restController.savedImages.length +
                                        restController.rawImages.length -
                                        1,
                                    itemBuilder: (context, index) {
                                      index++;
                                      bool savedImage = index < restController.savedImages.length;
                                      XFile? file =
                                          (savedImage || index < restController.savedImages.length)
                                              ? null
                                              : restController.rawImages[index -
                                                  restController
                                                      .savedImages.length]; //Just added images

                                      return Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Theme.of(context).primaryColor, width: 2),
                                          borderRadius:
                                              BorderRadius.circular(Dimensions.radiusSmall),
                                        ),
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(Dimensions.radiusSmall),
                                              child: savedImage
                                                  ? CustomImage(
                                                      image:
                                                          '${Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}/${restController.savedImages[index]}',
                                                      width: context.width,
                                                      height: context.width,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : file != null
                                                      ? GetPlatform.isWeb
                                                          ? Image.network(
                                                              file.path,
                                                              width: context.width,
                                                              height: context.width,
                                                              fit: BoxFit.cover,
                                                            )
                                                          : Image.file(
                                                              File(file.path),
                                                              width: context.width,
                                                              height: context.width,
                                                              fit: BoxFit.cover,
                                                            )
                                                      : SizedBox(),
                                            ),
                                            Positioned(
                                              right: 0,
                                              top: 0,
                                              child: InkWell(
                                                onTap: () {
                                                  if (savedImage) {
                                                    restController.removeSavedImage(index);
                                                  } else {
                                                    restController.removeImage(
                                                        index - restController.savedImages.length);
                                                  }
                                                },
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.all(Dimensions.paddingSizeSmall),
                                                  child:
                                                      Icon(Icons.delete_forever, color: Colors.red),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : SizedBox.shrink(),

                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          MyTextField(
                            hintText: '${'price'.tr} *',
                            controller: _priceController,
                            focusNode: _priceNode,
                            nextFocus: _discountNode,
                            isAmount: true,
                            amountIcon: true,
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          Row(children: [
                            Expanded(
                              child: MyTextField(
                                hintText: 'discount'.tr,
                                controller: _discountController,
                                focusNode: _discountNode,
                                isAmount: true,
                              ),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            Expanded(
                                child:
                                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(
                                'discount_type'.tr,
                                style: senRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: themeController.darkTheme
                                        ? Colors.white
                                        : Theme.of(context).dividerColor),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  border: Border.all(color: Colors.grey.withOpacity(.3)),
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //       color: Colors.grey[Get.isDarkMode ? 800 : 200]!,
                                  //       spreadRadius: 2,
                                  //       blurRadius: 5,
                                  //       offset: const Offset(0, 5))
                                  // ],
                                ),
                                child: DropdownButton<String>(
                                  value:
                                      restController.discountTypeIndex == 0 ? 'percent' : 'amount',
                                  items: <String>['percent', 'amount'].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value.tr),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    restController.setDiscountTypeIndex(
                                      value == 'percent' ? 0 : 1,
                                      true,
                                    );
                                  },
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                ),
                              ),
                            ])),
                          ]),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          // Align(
                          //     alignment: Alignment.centerLeft,
                          //     child: Text(
                          //       'food_type'.tr,
                          //       style: robotoRegular.copyWith(
                          //           fontSize: Dimensions.fontSizeSmall,
                          //           color: themeController.darkTheme
                          //               ? Colors.white
                          //               : Theme.of(context).disabledColor),
                          //     )),
                          // Row(children: [
                          //   Expanded(
                          //       child: RadioListTile<String>(
                          //     title: Text(
                          //       'non_veg'.tr,
                          //       style: robotoRegular.copyWith(
                          //           fontSize: Dimensions.fontSizeSmall),
                          //     ),
                          //     groupValue:
                          //         restController.isVeg ? 'veg' : 'non_veg',
                          //     value: 'non_veg',
                          //     contentPadding: EdgeInsets.zero,
                          //     onChanged: (String? value) =>
                          //         restController.setVeg(value == 'veg', true),
                          //     activeColor: Theme.of(context).primaryColor,
                          //   )),
                          //   const SizedBox(width: Dimensions.paddingSizeSmall),
                          //   Expanded(
                          //       child: RadioListTile<String>(
                          //     title: Text(
                          //       'veg'.tr,
                          //       style: robotoRegular.copyWith(
                          //           fontSize: Dimensions.fontSizeSmall),
                          //     ),
                          //     groupValue:
                          //         restController.isVeg ? 'veg' : 'non_veg',
                          //     value: 'veg',
                          //     contentPadding: EdgeInsets.zero,
                          //     onChanged: (String? value) =>
                          //         restController.setVeg(value == 'veg', true),
                          //     activeColor: Theme.of(context).primaryColor,
                          //     dense: false,
                          //   )),
                          // ]),
                          // SizedBox(
                          //     height: Get.find<SplashController>()
                          //             .configModel!
                          //             .toggleVegNonVeg!
                          //         ? Dimensions.paddingSizeLarge
                          //         : 0),
                          Row(children: [
                            Expanded(
                                child:
                                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(
                                '${'category'.tr} *',
                                style: senRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: themeController.darkTheme
                                        ? Colors.white
                                        : Theme.of(context).dividerColor),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  // borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //       color: Colors.grey[Get.isDarkMode ? 800 : 200]!,
                                  //       spreadRadius: 2,
                                  //       blurRadius: 5,
                                  //       offset: const Offset(0, 5))
                                  // ],
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  border: Border.all(color: Colors.grey.withOpacity(.3)),
                                ),
                                child: DropdownButton<int>(
                                  value: restController.categoryIndex,
                                  items: restController.categoryIds.map((int? value) {
                                    return DropdownMenuItem<int>(
                                      value: restController.categoryIds.indexOf(value),
                                      child: Text(value != 0
                                          ? restController
                                              .categoryList![
                                                  (restController.categoryIds.indexOf(value) - 1)]
                                              .name!
                                          : 'Select'),
                                    );
                                  }).toList(),
                                  onChanged: (int? value) {
                                    restController.setCategoryIndex(value, true);
                                    restController.getSubCategoryList(
                                        value != 0
                                            ? restController.categoryList![value! - 1].id
                                            : 0,
                                        null);
                                  },
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                ),
                              ),
                            ])),
                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            Expanded(
                                child:
                                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(
                                '${'sub_category'.tr} *',
                                style: senRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall,
                                  color: themeController.darkTheme
                                      ? Colors.white
                                      : Theme.of(context).dividerColor,
                                ),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                  border: Border.all(color: Colors.grey.withOpacity(.3)),
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //       color: Colors.grey[Get.isDarkMode ? 800 : 200]!,
                                  //       spreadRadius: 2,
                                  //       blurRadius: 5,
                                  //       offset: const Offset(0, 5))
                                  // ],
                                ),
                                child: DropdownButton<int>(
                                  value: restController.subCategoryIndex,
                                  items: restController.subCategoryIds.map((int? value) {
                                    return DropdownMenuItem<int>(
                                      value: restController.subCategoryIds.indexOf(value),
                                      child: Text(value != 0
                                          ? restController
                                              .subCategoryList![
                                                  (restController.subCategoryIds.indexOf(value) -
                                                      1)]
                                              .name!
                                          : 'Select'),
                                    );
                                  }).toList(),
                                  onChanged: (int? value) {
                                    restController.setSubCategoryIndex(value, true);
                                  },
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                ),
                              ),
                            ])),
                          ]),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          Text(
                            'cuisines'.tr,
                            style: senRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).dividerColor),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                          Align(
                            alignment: Alignment.center,
                            child: cuisineView(),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(children: [
                                  Expanded(
                                    flex: 8,
                                    child: MyTextField(
                                      hintText: 'tag'.tr,
                                      controller: _tagController,
                                      inputAction: TextInputAction.done,
                                      onSubmit: (name) {
                                        if (name.isNotEmpty) {
                                          restController.setTag(name);
                                          _tagController.text = '';
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: Dimensions.paddingSizeSmall),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: CustomButton(
                                          buttonText: 'add'.tr,
                                          onPressed: () {
                                            if (_tagController.text.isNotEmpty) {
                                              restController.setTag(_tagController.text.trim());
                                              _tagController.text = '';
                                            }
                                          }),
                                    ),
                                  )
                                ]),
                                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                restController.tagList.isNotEmpty
                                    ? SizedBox(
                                        height: 40,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: restController.tagList.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                margin: const EdgeInsets.symmetric(
                                                    horizontal: Dimensions.paddingSizeExtraSmall),
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: Dimensions.paddingSizeSmall),
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context).primaryColor,
                                                    borderRadius: BorderRadius.circular(
                                                        Dimensions.radiusSmall)),
                                                child: Center(
                                                    child: Row(children: [
                                                  Text(restController.tagList[index]!,
                                                      style: senMedium.copyWith(
                                                          color: Theme.of(context).cardColor)),
                                                  const SizedBox(
                                                      width: Dimensions.paddingSizeExtraSmall),
                                                  InkWell(
                                                      onTap: () => restController.removeTag(index),
                                                      child: Icon(Icons.clear,
                                                          size: 18,
                                                          color: Theme.of(context).cardColor)),
                                                ])),
                                              );
                                            }),
                                      )
                                    : const SizedBox(),
                              ]),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          VariationView(restController: restController, product: _product),
                          Text(
                            'addons'.tr,
                            style: senRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: themeController.darkTheme
                                    ? Colors.white
                                    : Theme.of(context).dividerColor),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                          GetBuilder<AddonController>(builder: (addonController) {
                            List<int> addons = [];
                            if (addonController.addonList != null) {
                              for (int index = 0;
                                  index < (addonController.addonList ?? []).length;
                                  index++) {
                                if (addonController.addonList?[index].status == 1 &&
                                    !(restController.selectedAddons ?? []).contains(index)) {
                                  addons.add(index);
                                }
                              }
                            }
                            return Autocomplete<int>(
                              optionsBuilder: (TextEditingValue value) {
                                if (value.text.isEmpty) {
                                  return const Iterable<int>.empty();
                                } else {
                                  return addons.where((addon) => addonController
                                      .addonList![addon].name!
                                      .toLowerCase()
                                      .contains(value.text.toLowerCase()));
                                }
                              },
                              fieldViewBuilder: (context, controller, node, onComplete) {
                                _c = controller;
                                return Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[Get.isDarkMode ? 800 : 200]!,
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 5))
                                    ],
                                  ),
                                  child: TextField(
                                    controller: controller,
                                    focusNode: node,
                                    onEditingComplete: () {
                                      onComplete();
                                      controller.text = '';
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'addons'.tr,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(Dimensions.radiusSmall),
                                          borderSide: BorderSide.none),
                                    ),
                                  ),
                                );
                              },
                              optionsViewBuilder: (context, Function(int i) onSelected, data) {
                                return Scaffold(
                                  body: ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: context.width * 0.4),
                                    child: ListView.builder(
                                      itemCount: data.length,
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () => onSelected(data.elementAt(index)),
                                          child: Container(
                                            decoration:
                                                BoxDecoration(color: Theme.of(context).cardColor),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: Dimensions.paddingSizeSmall,
                                                horizontal: Dimensions.paddingSizeExtraSmall),
                                            child: Text(addonController
                                                    .addonList![data.elementAt(index)].name ??
                                                ''),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                              displayStringForOption: (value) =>
                                  addonController.addonList![value].name ?? "",
                              onSelected: (int value) {
                                _c.text = '';
                                restController.setSelectedAddonIndex(value, true);
                                //_addons.removeAt(value);
                              },
                            );
                          }),
                          SizedBox(
                              height: (restController.selectedAddons ?? []).isNotEmpty
                                  ? Dimensions.paddingSizeSmall
                                  : 0),
                          SizedBox(
                            height: (restController.selectedAddons ?? []).isNotEmpty ? 40 : 0,
                            child: ListView.builder(
                              itemCount: restController.selectedAddons!.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding:
                                      const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                                  margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  ),
                                  child: Row(children: [
                                    GetBuilder<AddonController>(builder: (addonController) {
                                      return Text(
                                        addonController
                                            .addonList![restController.selectedAddons![index]]
                                            .name!,
                                        style:
                                            senRegular.copyWith(color: Theme.of(context).cardColor),
                                      );
                                    }),
                                    InkWell(
                                      onTap: () => restController.removeAddon(index),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                        child: Icon(Icons.close,
                                            size: 15, color: Theme.of(context).cardColor),
                                      ),
                                    ),
                                  ]),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),
                          Row(children: [
                            Expanded(
                                child: CustomTimePicker(
                              title: '${'available_time_starts'.tr} *',
                              time: _product!.availableTimeStarts,
                              onTimeChanged: (time) => _product!.availableTimeStarts = time,
                            )),
                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            Expanded(
                                child: CustomTimePicker(
                              title: '${'available_time_ends'.tr} *',
                              time: _product!.availableTimeEnds,
                              onTimeChanged: (time) => _product!.availableTimeEnds = time,
                            )),
                          ]),
                          // const SizedBox(height: Dimensions.paddingSizeLarge),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: _languageList!.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  const SizedBox(height: Dimensions.paddingSizeLarge),
                                  MyTextField(
                                    hintText: '${'Details'.tr}*',
                                    controller: _descriptionControllerList[index],
                                    focusNode: _descriptionFocusList[index],
                                    capitalization: TextCapitalization.sentences,
                                    maxLines: 5,
                                    inputAction: index != _languageList!.length - 1
                                        ? TextInputAction.next
                                        : TextInputAction.done,
                                    nextFocus: index != _languageList!.length - 1
                                        ? _nameFocusList[index + 1]
                                        : null,
                                  ),
                                  const SizedBox(height: Dimensions.paddingSizeLarge),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  !restController.isLoading
                      ? CustomButton(
                          buttonText: _update ? 'update'.tr : 'submit'.tr,
                          margin: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeLarge,
                              vertical: Dimensions.radiusDefault),
                          height: 50,
                          onPressed: () {
                            //name screen
                            // bool defaultDataNull = false;
                            // for (int index = 0; index < _languageList!.length; index++) {
                            //   if (_languageList![index].key == 'en') {
                            //     if (_nameControllerList[index].text.trim().isEmpty ||
                            //         _descriptionControllerList[index].text.trim().isEmpty) {
                            //       defaultDataNull = true;
                            //     }
                            //     break;
                            //   }
                            // }

                            //
                            String price = _priceController.text.trim();
                            String discount = _discountController.text.trim();
                            bool variationNameEmpty = false;
                            bool variationMinMaxEmpty = false;
                            bool variationOptionNameEmpty = false;
                            bool variationOptionPriceEmpty = false;
                            bool variationMinLessThenZero = false;
                            bool variationMaxSmallThenMin = false;
                            bool variationMaxBigThenOptions = false;

                            for (VariationModelBody variationModel
                                in restController.variationList ?? []) {
                              if (variationModel.nameController!.text.isEmpty) {
                                variationNameEmpty = true;
                              } else if (!variationModel.isSingle) {
                                if (variationModel.minController!.text.isEmpty ||
                                    variationModel.maxController!.text.isEmpty) {
                                  variationMinMaxEmpty = true;
                                } else if (int.parse(variationModel.minController!.text) < 1) {
                                  variationMinLessThenZero = true;
                                } else if (int.parse(variationModel.maxController!.text) <
                                    int.parse(variationModel.minController!.text)) {
                                  variationMaxSmallThenMin = true;
                                } else if (int.parse(variationModel.maxController!.text) >
                                    (variationModel.options ?? []).length) {
                                  variationMaxBigThenOptions = true;
                                }
                              } else {
                                for (Option option in variationModel.options ?? []) {
                                  if (option.optionNameController!.text.isEmpty) {
                                    variationOptionNameEmpty = true;
                                  } else if (option.optionPriceController!.text.isEmpty) {
                                    variationOptionPriceEmpty = true;
                                  }
                                }
                              }
                            }
                            //nameed screen
                            if (_nameControllerList[0].text.trim().isEmpty) {
                              showCustomSnackBar('enter_data_for_english'.tr);
                            } else if (price.isEmpty) {
                              showCustomSnackBar('enter_food_price'.tr);
                            } else if (discount.isEmpty) {
                              showCustomSnackBar('enter_food_discount'.tr);
                            } else if (restController.categoryIndex == 0) {
                              showCustomSnackBar('select_a_category'.tr);
                            } else if (variationNameEmpty) {
                              showCustomSnackBar('enter_name_for_every_variation'.tr);
                            } else if (variationMinMaxEmpty) {
                              showCustomSnackBar('enter_min_max_for_every_multipart_variation'.tr);
                            } else if (variationOptionNameEmpty) {
                              showCustomSnackBar('enter_option_name_for_every_variation'.tr);
                            } else if (variationOptionPriceEmpty) {
                              showCustomSnackBar('enter_option_price_for_every_variation'.tr);
                            } else if (variationMinLessThenZero) {
                              showCustomSnackBar('minimum_type_cant_be_less_then_1'.tr);
                            } else if (variationMaxSmallThenMin) {
                              showCustomSnackBar('max_type_cant_be_less_then_minimum_type'.tr);
                            } else if (variationMaxBigThenOptions) {
                              showCustomSnackBar(
                                  'max_type_length_should_not_be_more_then_options_length'.tr);
                            } else if (_product!.availableTimeStarts == null) {
                              showCustomSnackBar('pick_start_time'.tr);
                            } else if (_product!.availableTimeEnds == null) {
                              showCustomSnackBar('pick_end_time'.tr);
                            } else if (_descriptionControllerList[0].text.trim().isEmpty) {
                              showCustomSnackBar('Please enter details');
                            } else {
                              //
                              translations = [];
                              for (int index = 0; index < _languageList!.length; index++) {
                                translations.add(Translation(
                                  locale: _languageList![index].key,
                                  key: 'name',
                                  value: _nameControllerList[index].text.trim().isNotEmpty
                                      ? _nameControllerList[index].text.trim()
                                      : _nameControllerList[0].text.trim(),
                                ));
                                translations.add(Translation(
                                  locale: _languageList![index].key,
                                  key: 'description',
                                  value: _descriptionControllerList[index].text.trim().isNotEmpty
                                      ? _descriptionControllerList[index].text.trim()
                                      : _descriptionControllerList[0].text.trim(),
                                ));
                              }
                              //
                              _product!.veg = restController.isVeg ? 1 : 0;
                              _product!.price = double.parse(price);
                              _product!.discount = double.parse(discount);
                              _product!.discountType =
                                  restController.discountTypeIndex == 0 ? 'percent' : 'amount';
                              _product!.categoryIds = [];
                              _product!.categoryIds!.add(CategoryIds(
                                  id: restController
                                      .categoryList![restController.categoryIndex! - 1].id
                                      .toString()));
                              if (restController.subCategoryIndex != 0) {
                                _product!.categoryIds!.add(CategoryIds(
                                    id: restController
                                        .subCategoryList![restController.subCategoryIndex! - 1].id
                                        .toString()));
                              }
                              _product!.addOns = [];
                              for (var index in restController.selectedAddons ?? []) {
                                _product!.addOns!
                                    .add(Get.find<AddonController>().addonList![index]);
                              }
                              _product!.variations = [];
                              if ((restController.variationList ?? []).isNotEmpty) {
                                for (var variation in restController.variationList ?? []) {
                                  List<VariationOption> values = [];
                                  for (var option in variation.options!) {
                                    values.add(VariationOption(
                                        level: option.optionNameController!.text.trim(),
                                        optionPrice: option.optionPriceController!.text.trim()));
                                  }

                                  _product!.variations?.add(
                                    Variation(
                                        name: variation.nameController!.text.trim(),
                                        type: variation.isSingle ? 'single' : 'multi',
                                        min: variation.minController!.text.trim(),
                                        max: variation.maxController!.text.trim(),
                                        required: variation.required ? 'on' : 'off',
                                        variationValues: values),
                                  );
                                  print(_product!.variations);
                                }
                              }
                              _product!.translations = [];
                              _product!.translations!.addAll(translations);

                              restController.addProduct(_product!, widget.product == null);
                            }
                          },
                        )
                      : const Center(child: CircularProgressIndicator()),
                ])
              : const Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }

  Widget cuisineView() {
    return GetBuilder<RestaurantController>(builder: (cuisineController) {
      List<int> cuisines = [];
      if (cuisineController.cuisineModel != null) {
        for (int index = 0; index < cuisineController.cuisineModel!.cuisines!.length; index++) {
          if (cuisineController.cuisineModel!.cuisines![index].status == 1 &&
              !cuisineController.selectedCuisines!.contains(index)) {
            cuisines.add(index);
          }
        }
      }
      return Column(children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            if (cuisineController.cuisineModel?.cuisines != null) ...[
              for (int i = 0; i < cuisineController.cuisineModel!.cuisines!.length; i++)
                InkWell(
                  onTap: () {
                    if (cuisineController.cuisineModel!.cuisines![i].status == 1 &&
                        !cuisineController.selectedCuisines!.contains(i)) {
                      cuisineController.selectedCuisines?.add(i);
                      cuisineController.update();
                    } else {
                      cuisineController.selectedCuisines?.remove(i);
                      cuisineController.update();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: cuisineController.selectedCuisines!.contains(i)
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).cardColor,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault)),
                    padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.paddingSizeExtraSmall,
                        horizontal: Dimensions.paddingSizeExtraSmall),
                    child: Text(cuisineController.cuisineModel!.cuisines![i].name ?? "",
                        style: senMedium.copyWith(
                            color: cuisineController.selectedCuisines!.contains(i)
                                ? Colors.white
                                : Theme.of(context).textTheme.bodyText1!.color)),
                  ),
                )
            ],
          ],
        ),
      ]);
    });
  }
}
