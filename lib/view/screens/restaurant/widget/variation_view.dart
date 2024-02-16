import 'package:efood_multivendor_restaurant/controller/restaurant_controller.dart';
import 'package:efood_multivendor_restaurant/data/model/response/product_model.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/theme_controller.dart';

class VariationView extends StatefulWidget {
  final RestaurantController restController;
  final Product? product;
  const VariationView({Key? key, required this.restController, required this.product})
      : super(key: key);

  @override
  State<VariationView> createState() => _VariationViewState();
}

class _VariationViewState extends State<VariationView> {
  ThemeController themeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'variation'.tr,
        style: senRegular.copyWith(
            fontSize: Dimensions.fontSizeSmall,
            color: themeController.darkTheme ? Colors.white : Theme.of(context).dividerColor),
      ),
      // const SizedBox(height: Dimensions.paddingSizeExtraSmall),
      (widget.restController.variationList ?? []).isNotEmpty
          ? ListView.builder(
              itemCount: (widget.restController.variationList ?? []).length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Stack(children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).primaryColor),
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                    child: Column(
                      children: [
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        CustomTextField(
                          hintText: 'name'.tr,
                          showTitle: true,
                          //showShadow: true,
                          controller: widget.restController.variationList![index].nameController,
                        ),
                        ListTileTheme(
                          contentPadding: EdgeInsets.zero,
                          child: CheckboxListTile(
                            visualDensity: VisualDensity(horizontal: -4, vertical: -4),

                            controlAffinity: ListTileControlAffinity.leading,
                            // contentPadding: const EdgeInsets.symmetric(horizontal: 32),
                            value: widget.restController.variationList![index].required,
                            title: Text(
                              'required'.tr,
                              style: const TextStyle(fontSize: Dimensions.fontSizeSmall),
                            ),
                            tristate: true,
                            checkboxShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (value) {
                              widget.restController.setVariationRequired(index);
                            },
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('select_type'.tr, style: senMedium),
                          Row(children: [
                            InkWell(
                              onTap: () => widget.restController.changeSelectVariationType(index),
                              child: Row(children: [
                                Radio(
                                  value: true,
                                  groupValue: widget.restController.variationList![index].isSingle,
                                  onChanged: (bool? value) {
                                    widget.restController.changeSelectVariationType(index);
                                  },
                                  activeColor: Theme.of(context).primaryColor,
                                ),
                                Text('single'.tr)
                              ]),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeLarge),
                            InkWell(
                              onTap: () => widget.restController.changeSelectVariationType(index),
                              child: Row(children: [
                                Radio(
                                  value: false,
                                  groupValue: widget.restController.variationList![index].isSingle,
                                  onChanged: (bool? value) {
                                    widget.restController.changeSelectVariationType(index);
                                  },
                                  activeColor: Theme.of(context).primaryColor,
                                ),
                                Text('multiple'.tr)
                              ]),
                            ),
                          ]),
                        ]),
                        Visibility(
                          visible: !widget.restController.variationList![index].isSingle,
                          child: Row(children: [
                            Flexible(
                                child: CustomTextField(
                              hintText: 'min'.tr,
                              showTitle: true,
                              //showShadow: true,
                              inputType: TextInputType.number,
                              controller: widget.restController.variationList![index].minController,
                            )),
                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            Flexible(
                              child: CustomTextField(
                                hintText: 'max'.tr,
                                inputType: TextInputType.number,
                                showTitle: true,
                                //showShadow: true,
                                controller:
                                    widget.restController.variationList![index].maxController,
                              ),
                            ),
                          ]),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        Container(
                          // padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                          // decoration: BoxDecoration(
                          //   border: Border.all(color: Theme.of(context).primaryColor, width: 0.5),
                          //   borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          // ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ListView.builder(
                                  itemCount:
                                      (widget.restController.variationList![index].options ?? [])
                                          .length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, i) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: Dimensions.paddingSizeExtraSmall),
                                      child: Expanded(
                                        child: Column(children: [
                                          CustomTextField(
                                            hintText: 'option_name'.tr,
                                            showTitle: true,
                                            // showShadow: true,
                                            controller: widget.restController.variationList![index]
                                                .options![i].optionNameController,
                                          ),
                                          const SizedBox(height: Dimensions.paddingSizeDefault),
                                          CustomTextField(
                                            hintText: 'additional_price'.tr,
                                            showTitle: true,
                                            //showShadow: true,
                                            controller: widget.restController.variationList![index]
                                                .options![i].optionPriceController,
                                            inputType: TextInputType.number,
                                            inputAction: TextInputAction.done,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: Dimensions.paddingSizeSmall),
                                            child: (widget.restController.variationList![index]
                                                                .options ??
                                                            [])
                                                        .length >
                                                    1
                                                ? IconButton(
                                                    icon: const Icon(Icons.delete),
                                                    onPressed: () => widget.restController
                                                        .removeOptionVariation(index, i),
                                                  )
                                                : const SizedBox(),
                                          )
                                        ]),
                                      ),
                                    );
                                  }),
                              const SizedBox(height: Dimensions.paddingSizeSmall),
                              InkWell(
                                onTap: () {
                                  bool allFieldsFilled = true;
                                  var variation = widget.restController.variationList![index];
                                  if (variation.options != null) {
                                    for (var option in variation.options!) {
                                      if (option.optionNameController!.text.isEmpty ||
                                          option.optionPriceController!.text.isEmpty) {
                                        allFieldsFilled = false;
                                        break;
                                      }
                                    }
                                  }
                                  if (allFieldsFilled) {
                                    // All fields are filled, proceed with adding a new option for the variation
                                    widget.restController.addOptionVariation(index);
                                  } else {
                                    // Show an alert because some fields are not filled
                                    showCustomSnackBar(
                                        'Please fill all the fields before adding a new option.');
                                  }
                                },
                                child: Container(
                                  width: context.width,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.paddingSizeLarge,
                                      vertical: Dimensions.paddingSizeSmall),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                    // border: Border.all(color: Theme.of(context).primaryColor),
                                  ),
                                  child: Text(
                                    'add_new_option'.tr,
                                    style: senMedium.copyWith(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => widget.restController.removeVariation(index),
                    ),
                  ),
                ]);
              })
          : const SizedBox(),
      const SizedBox(height: Dimensions.paddingSizeDefault),
      InkWell(
        onTap: () {
          bool allFieldsFilled = true;
          // Check if all fields are filled for the current variations
          for (var variation in widget.restController.variationList ?? []) {
            if (variation.nameController.text.isEmpty || variation.options == null) {
              allFieldsFilled = false;
              break;
            }
            for (var option in variation.options ?? []) {
              if (option.optionNameController.text.isEmpty ||
                  option.optionPriceController.text.isEmpty) {
                allFieldsFilled = false;
                break;
              }
            }
            if (!allFieldsFilled) {
              break;
            }
          }
          if (allFieldsFilled) {
            // All fields are filled, proceed with adding a new variation
            widget.restController.addVariation();
          } else {
            // Show an alert because some fields are not filled
            showCustomSnackBar('Please fill all the fields before adding a new variation.');
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeSmall,
            vertical: Dimensions.paddingSizeSmall,
          ),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
          child: Text(
            (widget.restController.variationList ?? []).isNotEmpty
                ? 'add_new_variation'.tr
                : 'add_variation'.tr,
            style: TextStyle(
                fontFamily: "Sen",
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: themeController.darkTheme ? Colors.white : Theme.of(context).cardColor),
            //  robotoMedium.copyWith(
            //   color: themeController.darkTheme ? Colors.white : Theme.of(context).cardColor,
            //   fontSize: Dimensions.fontSizeDefault,
            // ),
          ),
        ),
      ),
      const SizedBox(height: Dimensions.paddingSizeLarge),
    ]);
  }
}
