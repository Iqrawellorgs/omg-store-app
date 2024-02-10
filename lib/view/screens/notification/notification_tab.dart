import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../chat/conversation_screen.dart';
import '../dashboard/dashboard_screen.dart';
import 'notification_screen.dart';

class NotificationChatTab extends StatefulWidget {
  const NotificationChatTab({Key? key}) : super(key: key);

  @override
  State<NotificationChatTab> createState() => _NotificationChatTabState();
}

class _NotificationChatTabState extends State<NotificationChatTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String appBarTitle = "Notification";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        appBarTitle = _tabController.index == 0 ? "Notification" : "Messages";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            appBarTitle,
            style: TextStyle(
              fontFamily: "Sen",
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: Color(0xff181C2E),
            ),
          ),
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashboardScreen(pageIndex: 0))),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xffECF0F4),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 15,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: "Notifications"),
              Tab(text: "Messages"),
            ],
            labelStyle: TextStyle(
              fontFamily: "Sen",
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColor,
            ),
            unselectedLabelStyle: TextStyle(
              fontFamily: "Sen",
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xffA5A7B9),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            NotificationScreen(
                fromNotification:
                    Get.parameters['from_notification'] == 'true'),
            ConversationScreen(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
