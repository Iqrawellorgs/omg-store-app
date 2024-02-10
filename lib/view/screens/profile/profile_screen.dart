import 'package:efood_multivendor_restaurant/controller/auth_controller.dart';
import 'package:efood_multivendor_restaurant/controller/splash_controller.dart';
import 'package:efood_multivendor_restaurant/controller/theme_controller.dart';
import 'package:efood_multivendor_restaurant/helper/route_helper.dart';
import 'package:efood_multivendor_restaurant/util/app_constants.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/images.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/confirmation_dialog.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_app_bar.dart';
import 'package:efood_multivendor_restaurant/view/base/switch_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    Get.find<AuthController>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Profile'.tr,
        isCenterTitle: true,
      ),
      backgroundColor: Theme.of(context).cardColor,
      body: GetBuilder<AuthController>(builder: (authController) {
        return authController.profileModel == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Center(
                  child: Container(
                    // width: 1170,
                    color: Theme.of(context).cardColor,
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                    child: Column(children: [
                      Row(
                        children: [
                          ClipOval(
                            child: FadeInImage.assetNetwork(
                              placeholder: Images.placeholder,
                              image:
                                  '${Get.find<SplashController>().configModel!.baseUrls!.vendorImageUrl}'
                                  '/${authController.profileModel != null ? authController.profileModel!.image : ''}',
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                              imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,
                                  height: 80, width: 80, fit: BoxFit.cover),
                            ),
                          ),
                          SizedBox(width: Dimensions.paddingSizeLarge),
                          Column(
                            children: [
                              Text(
                                '${authController.profileModel!.fName} ${authController.profileModel!.lName}',
                                style: const TextStyle(
                                  fontFamily: "Sen",
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                  '${authController.profileModel!.memberSinceDays} ${'days'.tr} ${'since_joining'.tr}'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      // Row(children: [
                      //   ProfileCard(
                      //     title: 'since_joining'.tr,
                      //     data: '${authController.profileModel!.memberSinceDays} ${'days'.tr}',
                      //   ),
                      //   const SizedBox(width: Dimensions.paddingSizeSmall),
                      //   ProfileCard(
                      //       title: 'total_order'.tr,
                      //       data: authController.profileModel!.orderCount.toString()),
                      // ]),
                      const SizedBox(height: 30),
                      Container(
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
                        // margin: const EdgeInsets.symmetric(
                        //     horizontal: Dimensions.paddingSizeExtraLarge),
                        child: Column(
                          children: [
                            SwitchButton(
                                icon: Icons.dark_mode,
                                title: 'dark_mode'.tr,
                                isButtonActive: Get.isDarkMode,
                                onTap: () {
                                  Get.find<ThemeController>().toggleTheme();
                                }),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            SwitchButton(
                              icon: Icons.notifications,
                              title: 'notification'.tr,
                              isButtonActive: authController.notification,
                              onTap: () {
                                authController.setNotificationActive(!authController.notification);
                              },
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            SwitchButton(
                                icon: Icons.lock,
                                title: 'change_password'.tr,
                                onTap: () {
                                  Get.toNamed(
                                      RouteHelper.getResetPasswordRoute('', '', 'password-change'));
                                }),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            SwitchButton(
                                icon: Icons.edit,
                                title: 'edit_profile'.tr,
                                onTap: () {
                                  Get.toNamed(RouteHelper.getUpdateProfileRoute());
                                }),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            SwitchButton(
                              icon: Icons.delete,
                              title: 'delete_account'.tr,
                              onTap: () {
                                Get.dialog(
                                    ConfirmationDialog(
                                        icon: Images.warning,
                                        title: 'are_you_sure_to_delete_account'.tr,
                                        description: 'it_will_remove_your_all_information'.tr,
                                        isLogOut: true,
                                        onYesPressed: () => authController.removeVendor()),
                                    useSafeArea: false);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text('${'version'.tr}:',
                            style: senRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                        Text(AppConstants.appVersion.toString(),
                            style: senMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                      ]),
                    ]),
                  ),
                ),
              );
      }),
    );
  }
}
