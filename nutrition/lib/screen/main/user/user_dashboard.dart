import 'package:flutter/material.dart';
import 'package:nutrition/providers/home/user_provider.dart';
import 'package:nutrition/providers/notifications/notification_provider.dart';
import 'package:nutrition/screen/main/user/widgets/calories_section.dart';
import 'package:nutrition/screen/main/user/widgets/custom_bottom_bar.dart';
import 'package:nutrition/screen/main/user/widgets/nutrients_section.dart';
import 'package:provider/provider.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int choiceIndex = 0;

  @override
  void initState() {
    //----get and update device token
    Provider.of<NotificationProvider>(context, listen: false).initNotifications(context);

    //---handling foreground notifications
    Provider.of<NotificationProvider>(context, listen: false).foregroundHandler();

    //---handling when clicked on notifications to open the app from background
    Provider.of<NotificationProvider>(context, listen: false).onClickedOpenedApp(context);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<UserProvider>(context, listen: false).startGetMainFoods(context);
      Provider.of<UserProvider>(context, listen: false).startGetUserSelectedFoods(context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "Calories",
                  icon: Icon(Icons.boy_outlined),
                ),
                Tab(
                  text: "Nutrients",
                  icon: Icon(Icons.pie_chart_outline_rounded),
                ),
              ],
            ),
            title: const Text('Dashboard'),
          ),
          body: const TabBarView(
            children: [
              CaloriesSection(),
              NutrientsSection(),
            ],
          ),
          bottomNavigationBar: const CustomBottomBar(),
        ),
      ),
    );
  }
}
