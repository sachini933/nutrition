import 'package:flutter/material.dart';
import 'package:nutrition/components/custom_loader.dart';
import 'package:nutrition/components/custom_text.dart';
import 'package:nutrition/providers/home/coach_provider.dart';
import 'package:nutrition/providers/notifications/notification_provider.dart';
import 'package:nutrition/screen/main/coach/widgets/user_card.dart';
import 'package:nutrition/screen/profile/profile.dart';
import 'package:nutrition/utils/util_functions.dart';
import 'package:provider/provider.dart';

class CoachDashboard extends StatefulWidget {
  const CoachDashboard({super.key});

  @override
  State<CoachDashboard> createState() => _CoachDashboardState();
}

class _CoachDashboardState extends State<CoachDashboard> {
  int choiceIndex = 0;
  Map<String, double> datamap = {
    "Breakfast": 18.47,
    "Lunch": 17.20,
    "Dinner": 4.25,
    "Snaks": 3.67,
  };

  List<Color> colorList = [
    const Color(0xff1d3482),
    const Color(0xff821d1d),
    const Color(0xff1f821d),
    const Color(0xff827e1d),
  ];

  @override
  void initState() {
    //----get and update device token
    Provider.of<NotificationProvider>(context, listen: false).initNotifications(context);

    Provider.of<NotificationProvider>(context, listen: false).onReceiveMessage(context);

    //---handling foreground notifications
    Provider.of<NotificationProvider>(context, listen: false).foregroundHandler();

    //---handling when clicked on notifications to open the app from background
    Provider.of<NotificationProvider>(context, listen: false).onClickedOpenedApp(context);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CoachProvider>(context, listen: false).startGetPaidUsers(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      const Text('Today'),
                      Text(UtilFunctions.getCurrentDate()),
                    ],
                  ),
                ],
              ),
              Transform.rotate(
                angle: 0.00,
                child: Container(
                  width: 337,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Image(
                    image: AssetImage('assets/images/home.png'),
                  ),
                ),
              ),
              Expanded(
                child: Consumer<CoachProvider>(
                  builder: (context, value, child) {
                    return value.isFetchingPaidUsers
                        ? const CustomLoader()
                        : value.padiUsers.isEmpty
                            ? const Center(child: CustomText("No users"))
                            : ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return UserCard(
                                    model: value.padiUsers[index],
                                    onTap: () {
                                      _showAddMealPlanForm(context, value.padiUsers[index].uid);
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) => const SizedBox(height: 20),
                                itemCount: value.padiUsers.length,
                              );
                  },
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.home, size: 28, color: Color(0xff14c38e)),
                  SizedBox(
                    height: 4,
                  ),
                  CircleAvatar(
                    radius: 4,
                  )
                ],
              ),
              // GestureDetector(
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => const MealPlans()),
              //     );
              //   },
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: const [
              //       Icon(Icons.note, size: 28, color: Color(0xff14c38e)),
              //       SizedBox(
              //         height: 4,
              //       ),
              //       //CircleAvatar(radius: 4,)
              //     ],
              //   ),
              // ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Profile()),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.person, size: 28, color: Color(0xff14c38e)),
                    SizedBox(
                      height: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddMealPlanForm(BuildContext context, String userId) {
    final mealPlanController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Add Meal Plan')),
          content: TextField(
            controller: mealPlanController,
            keyboardType: TextInputType.number,
            maxLines: 8,
            decoration: const InputDecoration(
              labelText: 'Type the meal plan',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                Provider.of<CoachProvider>(context, listen: false).startAddMealPlan(userId, mealPlanController.text, context);
              },
            ),
          ],
        );
      },
    );
  }
}
