// ignore_for_file: prefer_const_constructors

import 'package:efood_multivendor_restaurant/controller/auth_controller.dart';
import 'package:efood_multivendor_restaurant/helper/route_helper.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_app_bar.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_button.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_snackbar.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPassScreen extends StatefulWidget {
  const ForgetPassScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
          child: Container(
        color: Theme.of(context).primaryColor,
        child: Scrollbar(
            child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          // padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: Column(
            children: [
              SizedBox(
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'forgot_password'.tr,
                      style: TextStyle(
                        fontFamily: "Sen",
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    // Text(
                    //   'please_enter_email'.tr,
                    //   style: const TextStyle(
                    //     fontFamily: "Sen",
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.w400,
                    //     color: Colors.white,
                    //   ),
                    // ),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    Text(
                      'only_for_restaurant_owner'.tr,
                      style: const TextStyle(
                        fontFamily: "Sen",
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  // border: Border.all(color: Theme.of(context).dividerColor, width: 5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    // Text('please_enter_email'.tr,
                    //     style: robotoRegular, textAlign: TextAlign.center),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Email",
                        style: const TextStyle(
                          fontFamily: "Sen",
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      fillColor: Color.fromARGB(255, 240, 245, 250),
                      showBorder: false,
                      controller: _emailController,
                      inputType: TextInputType.emailAddress,
                      inputAction: TextInputAction.done,
                      hintText: 'email'.tr,
                      prefixIcon: Icons.email_outlined,
                      onSubmit: (text) => GetPlatform.isWeb ? _forgetPass() : null,
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),
                    GetBuilder<AuthController>(builder: (authController) {
                      return !authController.isLoading
                          ? CustomButton(
                              buttonText: 'SEND CODE'.tr,
                              onPressed: () => _forgetPass(),
                            )
                          : const Center(child: CircularProgressIndicator());
                    }),
                  ],
                ),
              ),
            ],
          ),
        )),
      )),
    );
  }

  void _forgetPass() {
    String email = _emailController.text.trim();
    if (email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    } else if (!GetUtils.isEmail(email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    } else {
      Get.find<AuthController>().forgetPassword(email).then((status) async {
        if (status.isSuccess) {
          Get.toNamed(RouteHelper.getVerificationRoute(email));
        } else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}
