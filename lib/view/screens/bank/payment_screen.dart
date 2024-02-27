import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

import '../../base/custom_app_bar.dart';
import '../../base/custom_snackbar.dart';

class PaymentScreen extends StatefulWidget {
  final int id;
  final double balance;

  const PaymentScreen({Key? key, required this.id, required this.balance})
      : super(key: key);

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  String environment = "PRODUCTION";
  String appId = "";
  String transactionId = DateTime.now().microsecondsSinceEpoch.toString();
  String merchantId = "WELLORGSONLINE";
  bool enableLogging = true;
  String checksum = "";
  String saltKey = "fbca8041-d464-47b5-82ed-6a650adb0867";

  String saltIndex = "1";

  String callbackUrl =
      "https://webhook.site/daf598da-2aa3-45ba-acb4-e48072e531d6";

  String body = "";

  Object? result;

  String apiEndPoint = "/pg/v1/pay";

  late String selectedUrl;
  double value = 0.0;
  PullToRefreshController? pullToRefreshController;
  // MyInAppBrowser? browser;
  double? maxCodOrderAmount;

  @override
  void initState() {
    super.initState();
    // selectedUrl =
    //     '${AppConstants.baseUrl}/payment-mobile?customer_id=${widget.orderModel.userId}&order_id=${widget.orderModel.id}';
    phonepeInit();
    body = getCheksum().toString();
    startPgTransaction();
  }

  getCheksum() {
    final requestData = {
      "merchantId": merchantId,
      "merchantTransactionId": transactionId,
      "merchantUserId": widget.id,
      "amount": widget.balance * 100,
      "callbackUrl": callbackUrl,
      "mobileNumber": 9906607989,
      "paymentInstrument": {"type": "PAY_PAGE"}
    };
    String base64Body = base64.encode(utf8.encode(json.encode(requestData)));

    checksum =
        '${sha256.convert(utf8.encode(base64Body + apiEndPoint + saltKey)).toString()}###$saltIndex';

    return base64Body;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (() => _exitApp().then((value) => value!)),
      child: Scaffold(
          backgroundColor: Theme.of(context).cardColor,
          appBar: CustomAppBar(title: '', onBackPressed: () => _exitApp()),
          // body: const Center(
          //   child: CircularProgressIndicator(),
          // )
          body: const Center(
            child: CircularProgressIndicator(),
          )),
    );
  }

  Future<bool?> _exitApp() async {
    Get.back();
    showCustomSnackBar('Payment failed'.tr);
    return true;
  }

  void phonepeInit() {
    PhonePePaymentSdk.init(environment, appId, merchantId, enableLogging)
        .then((val) => {
              setState(() {
                result = 'PhonePe SDK Initialized - $val';
              })
            })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }

  void startPgTransaction() async {
    try {
      var response =
          PhonePePaymentSdk.startTransaction(body, callbackUrl, checksum, "");
      String status;
      String error;
      response
          .then((val) async => {
                log("Response: $val"),
                if (val != null)
                  {
                    status = val['status'].toString(),
                    error = val['error'].toString(),
                    if (status == 'SUCCESS')
                      {
                        result = "Complete - status : Success",
                        await checkStatus(),
                      }
                    else
                      {
                        result =
                            "Complete - status : $status and error: $error",
                        log("Complete - status : $status and error: $error"),
                        log(val['error']),
                        await _exitApp(),
                      }
                  }
                else
                  {
                    result = "Incomplete",
                  },
                setState(() {}),
              })
          .catchError((error) {
        log("Error: $error");
        handleError(error);
        return <dynamic>{};
      });
    } catch (error) {
      handleError(error);
    }
  }

  checkStatus() async {
    try {
      String url =
          'https://api.phonepe.com/apis/hermes/pg/v1/status/$merchantId/$transactionId';

      String concate = "/pg/v1/status/$merchantId/$transactionId$saltKey";

      var bytes = utf8.encode(concate);

      var digest = sha256.convert(bytes).toString();

      String xVerify = "$digest###$saltIndex";

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "X-VERIFY": xVerify,
        "X-MERCHANT-ID": merchantId
      };

      await http.get(Uri.parse(url), headers: headers).then((value) {
        Map<String, dynamic> response = jsonDecode(value.body);
        try {
          if (response["success"] &&
              response["code"] == "PAYMENT_SUCCESS" &&
              response['data']['status'] == "COMPLETED") {
            log(response["message"]);
          } else {
            log("Something went wrong");
          }
        } catch (e) {
          log("error:$e");
        }
      });
    } catch (e) {
      log("errorss:$e");
    }
  }

  void handleError(error) {
    setState(() {
      result = {"error": error.toString()};
    });
  }
}
