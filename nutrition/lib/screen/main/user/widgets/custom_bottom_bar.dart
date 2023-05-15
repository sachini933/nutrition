import 'package:flutter/material.dart';
import 'package:nutrition/screen/main/user/meal_plans.dart';
import 'package:nutrition/screen/profile/profile.dart';
import 'package:nutrition/screen/reminder.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
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
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MealPlans()),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.note, size: 28, color: Color(0xff14c38e)),
                  SizedBox(
                    height: 4,
                  ),
                  //CircleAvatar(radius: 4,)
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Reminder()),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.notifications_active, size: 28, color: Color(0xff14c38e)),
                  SizedBox(
                    height: 4,
                  ),
                ],
              ),
            ),
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
    );
  }
}
