import 'dart:async';

import 'package:efood_multivendor_restaurant/controller/auth_controller.dart';
import 'package:efood_multivendor_restaurant/controller/splash_controller.dart';
import 'package:efood_multivendor_restaurant/helper/route_helper.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/util/styles.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_app_bar.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_button.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

class VerificationScreen extends StatefulWidget {
  final String? email;
  const VerificationScreen({Key? key, required this.email}) : super(key: key);

  @override
  VerificationScreenState createState() => VerificationScreenState();
}

class VerificationScreenState extends State<VerificationScreen> {
  Timer? _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();

    _startTimer();
  }

  void _startTimer() {
    _seconds = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds = _seconds - 1;
      if (_seconds == 0) {
        timer.cancel();
        _timer?.cancel();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();

    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: ''.tr,
        titleColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: Scrollbar(
          child: Container(
            color: Theme.of(context).primaryColor,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                        Text(
                          'Verification'.tr,
                          style: const TextStyle(
                            fontFamily: "Sen",
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                        Text(
                          'We have send a code to ${widget.email}'.tr,
                          textAlign: TextAlign.center,
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
                    width: 1170,
                    child: GetBuilder<AuthController>(
                      builder: (authController) {
                        return Column(children: [
                          // Get.find<SplashController>().configModel!.demo!
                          //     ? Text(
                          //         'for_demo_purpose'.tr,
                          //         style: robotoRegular,
                          //       )
                          //     : RichText(
                          //         text: TextSpan(
                          //           children: [
                          //             TextSpan(
                          //                 text: 'enter_the_verification_sent_to'.tr,
                          //                 style: robotoRegular.copyWith(
                          //                     color: Theme.of(context).disabledColor)),
                          //             TextSpan(
                          //                 text: ' ${widget.email}',
                          //                 style: robotoMedium.copyWith(
                          //                     color: Theme.of(context).textTheme.bodyLarge!.color)),
                          //           ],
                          //         ),
                          //       ),
                          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "CODE",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextButton(
                                onPressed: _seconds < 1
                                    ? () {
                                        authController.forgetPassword(widget.email).then((value) {
                                          if (value.isSuccess) {
                                            _startTimer();
                                            showCustomSnackBar('resend_code_successful'.tr,
                                                isError: false);
                                          } else {
                                            showCustomSnackBar(value.message);
                                          }
                                        });
                                      }
                                    : null,
                                child: Text(
                                  '${_seconds > 0 ? '${'Resend in'.tr} (${_seconds}sec)' : 'Resend'}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                          PinInputTextField(
                            pinLength: 4,
                            decoration: BoxLooseDecoration(
                              strokeColorBuilder:
                                  PinListenColorBuilder(Colors.transparent, Colors.transparent),
                              bgColorBuilder: PinListenColorBuilder(
                                const Color.fromARGB(255, 240, 245, 250),
                                const Color.fromARGB(255, 240, 245, 250),
                              ),
                              gapSpace: 25, // Adjust the gap space between each square
                              radius:
                                  Radius.circular(10), // Adjust the corner radius of each square
                            ),

                            textInputAction: TextInputAction.go,
                            keyboardType: TextInputType.number,
                            textCapitalization: TextCapitalization.characters,
                            // onSubmit: authController.updateVerificationCode,
                            onChanged: authController.updateVerificationCode,
                            enableInteractiveSelection: false,
                          ),
                          // Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          //   Text(
                          //     'did_not_receive_the_code'.tr,
                          //     style: robotoRegular.copyWith(color: Theme.of(context).disabledColor),
                          //   ),
                          //   TextButton(
                          //     onPressed: _seconds < 1
                          //         ? () {
                          //             authController.forgetPassword(widget.email).then((value) {
                          //               if (value.isSuccess) {
                          //                 _startTimer();
                          //                 showCustomSnackBar('resend_code_successful'.tr,
                          //                     isError: false);
                          //               } else {
                          //                 showCustomSnackBar(value.message);
                          //               }
                          //             });
                          //           }
                          //         : null,
                          //     child: Text('${'resend'.tr}${_seconds > 0 ? ' ($_seconds)' : ''}'),
                          //   ),
                          // ]),
                          const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                          authController.verificationCode.length == 4
                              ? !authController.isLoading
                                  ? CustomButton(
                                      buttonText: 'verify'.tr,
                                      onPressed: () {
                                        authController.verifyToken(widget.email).then((value) {
                                          if (value.isSuccess) {
                                            Get.toNamed(RouteHelper.getResetPasswordRoute(
                                                widget.email,
                                                authController.verificationCode,
                                                'reset-password'));
                                          } else {
                                            showCustomSnackBar(value.message);
                                          }
                                        });
                                      },
                                    )
                                  : const Center(child: CircularProgressIndicator())
                              : const SizedBox.shrink(),
                        ]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
