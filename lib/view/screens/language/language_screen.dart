import 'package:efood_multivendor_restaurant/controller/localization_controller.dart';
import 'package:efood_multivendor_restaurant/controller/splash_controller.dart';
import 'package:efood_multivendor_restaurant/helper/responsive_helper.dart';
import 'package:efood_multivendor_restaurant/helper/route_helper.dart';
import 'package:efood_multivendor_restaurant/util/app_constants.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/images.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_app_bar.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_button.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_restaurant/view/screens/language/widget/language_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageScreen extends StatelessWidget {
  final bool fromMenu;
  const LanguageScreen({Key? key, required this.fromMenu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: fromMenu ? CustomAppBar(title: 'language'.tr) : null,
      body: SafeArea(
        child: GetBuilder<LocalizationController>(builder: (localizationController) {
          return Column(children: [
            Expanded(
                child: Center(
              child: Scrollbar(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Center(
                      child: SizedBox(
                    width: 1170,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(child: Image.asset(Images.logo, width: 100)),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Center(child: Image.asset(Images.logoName, width: 100)),

                          //Center(child: Text(AppConstants.APP_NAME, style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE))),
                          const SizedBox(height: 30),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeExtraSmall),
                            child: Text('select_language'.tr, style: senMedium),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: ResponsiveHelper.isDesktop(context)
                                    ? 4
                                    : ResponsiveHelper.isTab(context)
                                        ? 3
                                        : 2,
                                childAspectRatio: (1 / 1),
                              ),
                              itemCount: AppConstants.languages.length,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) => LanguageWidget(
                                languageModel: AppConstants.languages[index],
                                localizationController: localizationController,
                                index: index,
                              ),
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          Text('you_can_change_language'.tr,
                              style: senRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).disabledColor,
                              )),
                        ]),
                  )),
                ),
              ),
            )),
            CustomButton(
              buttonText: 'save'.tr,
              margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              onPressed: () {
                if (AppConstants.languages.isNotEmpty &&
                    localizationController.selectedIndex != -1) {
                  localizationController.setLanguage(Locale(
                    AppConstants.languages[localizationController.selectedIndex].languageCode!,
                    AppConstants.languages[localizationController.selectedIndex].countryCode,
                  ));
                  if (fromMenu) {
                    Navigator.pop(context);
                  } else {
                    Get.find<SplashController>().setIntro(false);
                    Get.offNamed(RouteHelper.getSignInRoute());
                  }
                } else {
                  showCustomSnackBar('select_a_language'.tr);
                }
              },
            ),
          ]);
        }),
      ),
    );
  }
}
