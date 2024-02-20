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
            style: const TextStyle(
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
                  onTap: () => Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => DashboardScreen(pageIndex: 0))),
                  child: Container(
                    margin: const EdgeInsets.only(left: 20, top: 4),
                    padding: const EdgeInsets.only(
                      left: 10,
                      top: 10,
                      bottom: 10,
                      right: 5,
                    ),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 236, 240, 244),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                        color: Theme.of(context).textTheme.bodyLarge!.color,
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
            NotificationScreen(fromNotification: Get.parameters['from_notification'] == 'true'),
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
