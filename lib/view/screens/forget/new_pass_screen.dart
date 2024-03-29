import 'package:efood_multivendor_restaurant/controller/auth_controller.dart';
import 'package:efood_multivendor_restaurant/data/model/response/profile_model.dart';
import 'package:efood_multivendor_restaurant/helper/route_helper.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/images.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_app_bar.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_button.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewPassScreen extends StatefulWidget {
  final String? resetToken;
  final String? email;
  final bool fromPasswordChange;
  const NewPassScreen(
      {Key? key, required this.resetToken, required this.email, required this.fromPasswordChange})
      : super(key: key);

  @override
  State<NewPassScreen> createState() => _NewPassScreenState();
}

class _NewPassScreenState extends State<NewPassScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FocusNode _oldPasswordFocus = FocusNode();
  final FocusNode _newPasswordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: widget.fromPasswordChange ? 'change_password'.tr : 'reset_password'.tr),
      body: SafeArea(
          child: Center(
              child: Scrollbar(
                  child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Center(
            child: SizedBox(
                width: 1170,
                child: Column(children: [
                  Text('enter_new_password'.tr, style: senRegular, textAlign: TextAlign.center),
                  const SizedBox(height: 50),
                  Column(children: [
                    CustomTextField(
                      showBorder: false,
                      fillColor: const Color.fromARGB(255, 240, 245, 250),
                      hintText: 'Old Password',
                      controller: _oldPasswordController,
                      focusNode: _oldPasswordFocus,
                      inputType: TextInputType.visiblePassword,
                      prefixIcon: Icons.lock,
                      isPassword: true,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                    CustomTextField(
                      showBorder: false,
                      fillColor: const Color.fromARGB(255, 240, 245, 250),
                      hintText: 'new_password'.tr,
                      controller: _newPasswordController,
                      focusNode: _newPasswordFocus,
                      nextFocus: _confirmPasswordFocus,
                      inputType: TextInputType.visiblePassword,
                      // prefixImage: Images.lock,
                      prefixIcon: Icons.lock,

                      isPassword: true,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                    CustomTextField(
                      showBorder: false,
                      fillColor: const Color.fromARGB(255, 240, 245, 250),
                      hintText: 'confirm_password'.tr,
                      controller: _confirmPasswordController,
                      focusNode: _confirmPasswordFocus,
                      inputAction: TextInputAction.done,
                      inputType: TextInputType.visiblePassword,
                      prefixIcon: Icons.lock,
                      isPassword: true,
                      onSubmit: (text) => GetPlatform.isWeb ? _resetPassword() : null,
                    ),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                  GetBuilder<AuthController>(builder: (authController) {
                    return !authController.isLoading
                        ? CustomButton(
                            buttonText: 'done'.tr,
                            onPressed: () => _resetPassword(),
                          )
                        : const Center(child: CircularProgressIndicator());
                  }),
                ]))),
      )))),
    );
  }

  void _resetPassword() {
    String password = _newPasswordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    if (password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    } else if (password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    } else if (password != confirmPassword) {
      showCustomSnackBar('password_does_not_matched'.tr);
    } else {
      if (widget.fromPasswordChange) {
        ProfileModel user = Get.find<AuthController>().profileModel!;
        Get.find<AuthController>().changePassword(user, password);
      } else {
        Get.find<AuthController>()
            .resetPassword(widget.resetToken, widget.email, password, confirmPassword)
            .then((value) {
          if (value.isSuccess) {
            Get.find<AuthController>().login(widget.email, password).then((value) async {
              Get.offAllNamed(RouteHelper.getInitialRoute());
            });
          } else {
            showCustomSnackBar(value.message);
          }
        });
      }
    }
  }
}
