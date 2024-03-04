// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:developer';

import 'package:efood_multivendor_restaurant/controller/auth_controller.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_button.dart';
import 'package:efood_multivendor_restaurant/view/base/custom_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String? number;
  const OtpVerificationScreen({
    Key? key,
    required this.number,
  }) : super(key: key);

  @override
  OtpVerificationScreenState createState() => OtpVerificationScreenState();
}

class OtpVerificationScreenState extends State<OtpVerificationScreen> {
  String? _number;
  Timer? _timer;
  int _seconds = 0;
  String? localVerificationId;

  @override
  void initState() {
    super.initState();

    // print('-------${widget.fromSignUp} // ${(widget.password.isNotEmpty)}');

    Get.find<AuthController>().updateVerificationCode('', canUpdate: false);
    _number = widget.number!.startsWith('+')
        ? widget.number
        : '+${widget.number!.substring(1, widget.number!.length)}';
    _startTimer();
    verifyPhoneNumber(phoneNumber: _number!);
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

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyPhoneNumber({required String phoneNumber}) async {
    try {
      await _auth.verifyPhoneNumber(
        timeout: Duration(seconds: 60),
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification completed (Android only)
          await _auth.signInWithCredential(credential);

          log('Phone number verified automatically!');
          Get.back(result: true);
          // PhoneNumber phoneNumber = await PhoneNumberUtil().parse(_number!);
          // AuthController authController = Get.find();
          // login(authController, '+91', phoneNumber.nationalNumber);
        },
        verificationFailed: (FirebaseAuthException error) {
          log('Verification failed: ${error.code}');
          showCustomSnackBar(error.code, isError: true);
        },
        codeSent: (String verificationId, int? resendToken) {
          log('Code sent! Verification ID: $verificationId');
          localVerificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          log('Time out for auto-retrieval of code: $verificationId');
          localVerificationId = verificationId;
        },
      );
    } catch (error) {
      log('Error verifying phone number: $error');
      showCustomSnackBar("Entered OTP is invalid", isError: true);
    }
  }

  Future<void> verifyOTP({required String verificationId}) async {
    AuthController authController = Get.find();
    authController.isLoading = true;
    try {
      // Manually verify the OTP entered by the user

      String enteredOTP = authController.verificationCode;
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: enteredOTP,
      );
      // Verify the phone number with the credential
      await _auth.signInWithCredential(credential);
      log('Phone number verified with entered OTP: $enteredOTP');
      Get.back(result: true);
    } catch (error) {
      log('Error verifying OTP: $error');
      showCustomSnackBar("Entered OTP is invalid", isError: true);
    }
    authController.isLoading = false;
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CustomAppBar(title: 'otp_verification'.tr),
      backgroundColor: Theme.of(context).primaryColor,

      body: SafeArea(
          child: Scrollbar(
              child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        // padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: Container(
          width: context.width > 700 ? 700 : context.width,
          padding: context.width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          ),
          // : null,
          child: GetBuilder<AuthController>(builder: (authController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: EdgeInsets.only(left: 15, right: 10, top: 10, bottom: 10),
                        decoration: const BoxDecoration(
                          color: Colors.white, // Set background color to white
                          shape: BoxShape.circle, // Make the background circular
                        ),
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 15,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 143,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Verification",
                        style: TextStyle(
                          fontFamily: "Sen",
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      Text(
                        'We have sent a code to your mobile number',
                        style: const TextStyle(
                          fontFamily: "Sen",
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _number ?? '',
                        style: const TextStyle(
                          fontFamily: "Sen",
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: context.height - 200,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: Dimensions.paddingSizeLarge),
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
                                  ? () async {
                                      _startTimer();
                                      showCustomSnackBar('resend_code_successful'.tr,
                                          isError: false);
                                      await verifyPhoneNumber(phoneNumber: _number!);
                                    }
                                  : null,
                              child: Text(
                                _seconds > 0 ? '${'Resend in'.tr} (${_seconds}sec)' : 'Resend',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(height: Dimensions.paddingSizeLarge),

                        PinInputTextField(
                          pinLength: 6,
                          decoration: BoxLooseDecoration(
                            strokeColorBuilder:
                                PinListenColorBuilder(Colors.transparent, Colors.transparent),
                            bgColorBuilder: PinListenColorBuilder(
                              const Color.fromARGB(255, 240, 245, 250),
                              const Color.fromARGB(255, 240, 245, 250),
                            ),
                            gapSpace: 5, // Adjust the gap space between each square
                            radius: Radius.circular(10), // Adjust the corner radius of each square
                          ),

                          textInputAction: TextInputAction.go,
                          keyboardType: TextInputType.number,
                          textCapitalization: TextCapitalization.characters,
                          // onSubmit: authController.updateVerificationCode,
                          onChanged: authController.updateVerificationCode,
                          enableInteractiveSelection: false,
                        ),
                        const SizedBox(height: 40),

                        authController.verificationCode.length == 6
                            ? CustomButton(
                                radius: Dimensions.radiusDefault,
                                buttonText: 'VERIFY'.tr,
                                fontSize: 14,
                                isLoading: authController.isLoading,
                                onPressed: () async {
                                  //firebase otp

                                  verifyOTP(verificationId: localVerificationId ?? '');

                                  //firebase otp
                                },
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ))),
    );
  }
}
