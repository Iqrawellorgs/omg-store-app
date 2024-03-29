import 'dart:io';

import 'package:efood_multivendor_restaurant/controller/auth_controller.dart';
import 'package:efood_multivendor_restaurant/controller/splash_controller.dart';
import 'package:efood_multivendor_restaurant/data/model/response/profile_model.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/images.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_app_bar.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_button.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_restaurant/view/base/my_text_field.dart';
import 'package:efood_multivendor_restaurant/view/screens/profile/widget/profile_bg_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateProfileScreen extends StatelessWidget {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Get.find<AuthController>().profileModel == null) {
      Get.find<AuthController>().getProfile();
    }
    Get.find<AuthController>().initData();

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: CustomAppBar(
        title: 'Edit Profile',
        isCenterTitle: true,
      ),
      body: GetBuilder<AuthController>(builder: (authController) {
        if (authController.profileModel != null && _emailController.text.isEmpty) {
          _firstNameController.text = authController.profileModel!.fName ?? '';
          _lastNameController.text = authController.profileModel!.lName ?? '';
          _phoneController.text = authController.profileModel!.phone ?? '';
          _emailController.text = authController.profileModel!.email ?? '';
        }

        return authController.profileModel != null
            ?

            // backButton: true,
            // circularImage: Center(
            //   child: Stack(
            //     children: [
            //       ClipOval(
            //           child: authController.pickedFile != null
            //               ? GetPlatform.isWeb
            //                   ? Image.network(
            //                       authController.pickedFile!.path,
            //                       width: 100,
            //                       height: 100,
            //                       fit: BoxFit.cover,
            //                     )
            //                   : Image.file(
            //                       File(authController.pickedFile!.path),
            //                       width: 100,
            //                       height: 100,
            //                       fit: BoxFit.cover,
            //                     )
            //               : FadeInImage.assetNetwork(
            //                   placeholder: Images.placeholder,
            //                   image:
            //                       '${Get.find<SplashController>().configModel!.baseUrls!.vendorImageUrl}/${authController.profileModel!.image}',
            //                   height: 100,
            //                   width: 100,
            //                   fit: BoxFit.cover,
            //                   imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,
            //                       height: 100, width: 100, fit: BoxFit.cover),
            //                 )),
            //       Positioned(
            //         bottom: 0,
            //         right: 0,
            //         top: 0,
            //         left: 0,
            //         child: InkWell(
            //           onTap: () => authController.pickImage(),
            //           child: Container(
            //             decoration: BoxDecoration(
            //               color: Colors.black.withOpacity(0.3),
            //               shape: BoxShape.circle,
            //               border: Border.all(width: 1, color: Theme.of(context).primaryColor),
            //             ),
            //             child: Container(
            //               margin: const EdgeInsets.all(25),
            //               decoration: BoxDecoration(
            //                 border: Border.all(width: 2, color: Colors.white),
            //                 shape: BoxShape.circle,
            //               ),
            //               child: const Icon(Icons.camera_alt, color: Colors.white),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // mainWidget:
            Column(
                children: [
                  Stack(
                    children: [
                      ClipOval(
                        child: FadeInImage.assetNetwork(
                          placeholder: Images.placeholder,
                          image:
                              '${Get.find<SplashController>().configModel!.baseUrls!.vendorImageUrl}/${authController.profileModel!.image}',
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                          imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,
                              height: 100, width: 100, fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        // top: 0,
                        // left: 0,
                        child: InkWell(
                          onTap: () => authController.pickImage(),
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                border: Border.all(width: 2, color: Colors.white),
                                shape: BoxShape.circle,
                                color: Theme.of(context).primaryColor),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                        child: Center(
                          child: SizedBox(
                            width: 1170,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyTextField(
                                  isBorderenabled: false,
                                  fillColor: const Color.fromARGB(255, 240, 245, 250),
                                  hintText: 'first_name'.tr,
                                  controller: _firstNameController,
                                  focusNode: _firstNameFocus,
                                  nextFocus: _lastNameFocus,
                                  inputType: TextInputType.name,
                                  capitalization: TextCapitalization.words,
                                ),
                                const SizedBox(height: Dimensions.paddingSizeLarge),
                                MyTextField(
                                  isBorderenabled: false,
                                  fillColor: Color.fromARGB(255, 240, 245, 250),
                                  hintText: 'last_name'.tr,
                                  controller: _lastNameController,
                                  focusNode: _lastNameFocus,
                                  nextFocus: _phoneFocus,
                                  inputType: TextInputType.name,
                                  capitalization: TextCapitalization.words,
                                ),
                                const SizedBox(height: Dimensions.paddingSizeLarge),
                                MyTextField(
                                  isBorderenabled: false,
                                  fillColor: Color.fromARGB(255, 240, 245, 250),
                                  hintText: 'phone'.tr,
                                  controller: _phoneController,
                                  focusNode: _phoneFocus,
                                  inputType: TextInputType.phone,
                                  inputAction: TextInputAction.done,
                                ),
                                const SizedBox(height: Dimensions.paddingSizeLarge),
                                MyTextField(
                                  isBorderenabled: false,
                                  fillColor: Color.fromARGB(255, 240, 245, 250),
                                  hintText: 'email'.tr,
                                  controller: _emailController,
                                  focusNode: _emailFocus,
                                  inputAction: TextInputAction.done,
                                  inputType: TextInputType.emailAddress,
                                  isEnabled: false,
                                ),
                                const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                                !authController.isLoading
                                    ? CustomButton(
                                        onPressed: () => _updateProfile(authController),
                                        radius: 13,
                                        // margin:
                                        //     const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                                        buttonText: 'update'.tr,
                                      )
                                    : const Center(child: CircularProgressIndicator()),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // !authController.isLoading
                  //     ? CustomButton(
                  //         onPressed: () => _updateProfile(authController),
                  //         margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  //         buttonText: 'update'.tr,
                  //       )
                  //     : const Center(child: CircularProgressIndicator()),
                ],
              )
            : const Center(child: CircularProgressIndicator());
      }),
    );
  }

  void _updateProfile(AuthController authController) async {
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String email = _emailController.text.trim();
    String phoneNumber = _phoneController.text.trim();
    if (authController.profileModel!.fName == firstName &&
        authController.profileModel!.lName == lastName &&
        authController.profileModel!.phone == phoneNumber &&
        authController.profileModel!.email == _emailController.text &&
        authController.pickedFile == null) {
      showCustomSnackBar('change_something_to_update'.tr);
    } else if (firstName.isEmpty) {
      showCustomSnackBar('enter_your_first_name'.tr);
    } else if (lastName.isEmpty) {
      showCustomSnackBar('enter_your_last_name'.tr);
    } else if (email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    } else if (!GetUtils.isEmail(email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    } else if (phoneNumber.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    } else if (phoneNumber.length < 6) {
      showCustomSnackBar('enter_a_valid_phone_number'.tr);
    } else {
      ProfileModel updatedUser = ProfileModel(
          fName: firstName.substring(0, 1).toUpperCase() + firstName.substring(1),
          lName: lastName.substring(0, 1).toUpperCase() + lastName.substring(1),
          email: email,
          phone: phoneNumber);
      bool isSuccess = await authController.updateUserInfo(
          updatedUser, Get.find<AuthController>().getUserToken());
      if (isSuccess) {
        authController.getProfile();
      }
    }
  }
}
