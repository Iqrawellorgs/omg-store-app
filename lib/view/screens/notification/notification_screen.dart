import 'package:efood_multivendor_restaurant/controller/notification_controller.dart';
import 'package:efood_multivendor_restaurant/helper/route_helper.dart';
import 'package:efood_multivendor_restaurant/util/dimensions.dart';
import 'package:efood_multivendor_restaurant/view/screens/notification/widget/notification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/splash_controller.dart';
import '../../../helper/date_converter.dart';
import '../../base/custom_image.dart';

class NotificationScreen extends StatelessWidget {
  final bool fromNotification;
  const NotificationScreen({Key? key, this.fromNotification = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<NotificationController>().getNotificationList();

    return WillPopScope(
      onWillPop: () async {
        if (fromNotification) {
          Get.offAllNamed(RouteHelper.getInitialRoute());
          return true;
        } else {
          Get.back();
          return true;
        }
      },
      child: Scaffold(
        // appBar: CustomAppBar(title: 'notification'.tr, onBackPressed: () {
        //   if(fromNotification) {
        //     Get.offAllNamed(RouteHelper.getInitialRoute());
        //   }else {
        //     Get.back();
        //   }
        // }),
        body:
            // Scrollbar(
            //     child: SingleChildScrollView(
            //         child: Center(
            //             child: SizedBox(
            //                 width: 1170,
            //                 child: ListView.builder(
            //                   itemCount: 2,
            //                   padding: EdgeInsets.zero,
            //                   physics: const NeverScrollableScrollPhysics(),
            //                   shrinkWrap: true,
            //                   itemBuilder: (context, index) {
            //                     // DateTime originalDateTime = DateConverter.dateTimeStringToDate(notificationController.notificationList![index].createdAt!);
            //                     // DateTime convertedDate = DateTime(originalDateTime.year, originalDateTime.month, originalDateTime.day);
            //                     // bool addTitle = false;
            //                     // if(!dateTimeList.contains(convertedDate)) {
            //                     //   addTitle = true;
            //                     //   dateTimeList.add(convertedDate);
            //                     // }
            //                     return Column(
            //                         crossAxisAlignment: CrossAxisAlignment.start,
            //                         children: [
            //                           const SizedBox(
            //                               height: Dimensions.paddingSizeDefault),
            //                           ListTile(
            //                             onTap: () {
            //                               // showDialog(context: context, builder: (BuildContext context) {
            //                               //   return NotificationDialog(notificationModel: notificationController.notificationList![index]);
            //                               // });
            //                             },
            //                             leading: ClipOval(
            //                               child: CustomImage(
            //                                 height: 50,
            //                                 width: 50,
            //                                 fit: BoxFit.cover,
            //                                 image: Images.notificationPlaceholder,
            //                               ),
            //                             ),
            //                             title: Text(
            //                               'Notification',
            //                               style: TextStyle(
            //                                 fontFamily: "Sen",
            //                                 fontSize: 13,
            //                                 fontWeight: FontWeight.w400,
            //                                 color: Color(0xff32343E),
            //                               ),
            //                             ),
            //                             subtitle: Column(
            //                               crossAxisAlignment:
            //                                   CrossAxisAlignment.start,
            //                               mainAxisAlignment:
            //                                   MainAxisAlignment.start,
            //                               children: [
            //                                 Text(
            //                                   'This is notification',
            //                                   style: TextStyle(
            //                                     fontFamily: "Sen",
            //                                     fontSize: 10,
            //                                     fontWeight: FontWeight.w400,
            //                                     color: Color(0xff9C9BA6),
            //                                   ),
            //                                 ),
            //                                 const SizedBox(
            //                                     height:
            //                                         Dimensions.paddingSizeSmall),
            //                                 Text(
            //                                   'Jan 17,2024',
            //                                   style: TextStyle(
            //                                     fontFamily: "Sen",
            //                                     fontSize: 10,
            //                                     fontWeight: FontWeight.w400,
            //                                     color: Color(0xff9C9BA6),
            //                                   ),
            //                                 ),
            //                               ],
            //                             ),
            //                           ),
            //                           Padding(
            //                             padding: const EdgeInsets.symmetric(
            //                                 horizontal:
            //                                     Dimensions.paddingSizeSmall),
            //                             child: Divider(color: Color(0xffF0F4F9)),
            //                           ),
            //                         ]);
            //                   },
            //                 ))))),

            GetBuilder<NotificationController>(
                builder: (notificationController) {
          if (notificationController.notificationList != null) {
            notificationController.saveSeenNotificationCount(
                notificationController.notificationList!.length);
          }
          List<DateTime> dateTimeList = [];
          return notificationController.notificationList != null
              ? notificationController.notificationList!.isNotEmpty
                  ? RefreshIndicator(
                      onRefresh: () async {
                        await notificationController.getNotificationList();
                      },
                      child: Scrollbar(
                          child: SingleChildScrollView(
                              child: Center(
                                  child: SizedBox(
                                      width: 1170,
                                      child: ListView.builder(
                                        itemCount: notificationController
                                            .notificationList!.length,
                                        padding: EdgeInsets.zero,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          DateTime originalDateTime =
                                              DateConverter
                                                  .dateTimeStringToDate(
                                                      notificationController
                                                          .notificationList![
                                                              index]
                                                          .createdAt!);
                                          DateTime convertedDate = DateTime(
                                              originalDateTime.year,
                                              originalDateTime.month,
                                              originalDateTime.day);
                                          bool addTitle = false;
                                          if (!dateTimeList
                                              .contains(convertedDate)) {
                                            addTitle = true;
                                            dateTimeList.add(convertedDate);
                                          }
                                          return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                    height: Dimensions
                                                        .paddingSizeDefault),
                                                // addTitle
                                                //     ? Padding(
                                                //         padding:
                                                //             const EdgeInsets
                                                //                 .fromLTRB(
                                                //                 10, 10, 10, 0),
                                                //         child: Text(DateConverter
                                                //             .dateTimeStringToDateOnly(
                                                //                 notificationController
                                                //                     .notificationList![
                                                //                         index]
                                                //                     .createdAt!)),
                                                //       )
                                                //     : const SizedBox(),
                                                ListTile(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return NotificationDialog(
                                                              notificationModel:
                                                                  notificationController
                                                                          .notificationList![
                                                                      index]);
                                                        });
                                                  },
                                                  leading:
                                                      // ClipOval(child: FadeInImage.assetNetwork(
                                                      //   placeholder: Images.notificationPlaceholder, height: 40, width: 40, fit: BoxFit.cover,
                                                      //   image: '${Get.find<SplashController>().configModel!.baseUrls!.notificationImageUrl}'
                                                      //       '/${notificationController.notificationList![index].image}',
                                                      //   imageErrorBuilder: (c, o, s) => Image.asset(Images.notificationPlaceholder, height: 40, width: 40, fit: BoxFit.cover),
                                                      // )),
                                                      ClipOval(
                                                    child: CustomImage(
                                                      height: 50,
                                                      width: 50,
                                                      fit: BoxFit.cover,
                                                      image:
                                                          '${Get.find<SplashController>().configModel!.baseUrls!.notificationImageUrl}'
                                                          '/${notificationController.notificationList![index].image}',
                                                    ),
                                                  ),
                                                  title: Text(
                                                    notificationController
                                                            .notificationList![
                                                                index]
                                                            .title ??
                                                        '',
                                                    style: TextStyle(
                                                      fontFamily: "Sen",
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color(0xff32343E),
                                                    ),
                                                  ),
                                                  subtitle: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        notificationController
                                                                .notificationList![
                                                                    index]
                                                                .description ??
                                                            '',
                                                        style: TextStyle(
                                                          fontFamily: "Sen",
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color:
                                                              Color(0xff9C9BA6),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: Dimensions
                                                              .paddingSizeSmall),
                                                      addTitle
                                                          ? Text(
                                                              DateConverter.dateTimeStringToDateOnly(
                                                                  notificationController
                                                                      .notificationList![
                                                                          index]
                                                                      .createdAt!),
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    "Sen",
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Color(
                                                                    0xff9C9BA6),
                                                              ),
                                                            )
                                                          : const SizedBox(),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: Dimensions
                                                          .paddingSizeSmall),
                                                  child: Divider(
                                                      color: Theme.of(context)
                                                          .disabledColor),
                                                ),
                                              ]);
                                        },
                                      ))))),
                    )
                  : Center(child: Text('no_notification_found'.tr))
              : const Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }
}
