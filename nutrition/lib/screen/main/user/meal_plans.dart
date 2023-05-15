import 'package:flutter/material.dart';
import 'package:nutrition/components/custom_loader.dart';
import 'package:nutrition/components/custom_text.dart';
import 'package:nutrition/providers/home/user_provider.dart';
import 'package:provider/provider.dart';

class MealPlans extends StatefulWidget {
  const MealPlans({super.key});

  @override
  State<MealPlans> createState() => _MealPlansState();
}

class _MealPlansState extends State<MealPlans> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<UserProvider>(context, listen: false).startGetMealPlans(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Added Meal Plans'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Consumer<UserProvider>(
          builder: (context, value, child) {
            return value.isFetchingPlans
                ? const CustomLoader()
                : value.mealPlans.isEmpty
                    ? const Center(
                        child: CustomText("No added meal plans"),
                      )
                    : ListView.separated(
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 2,
                            color: Colors.amber,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                              child: Column(
                                children: [
                                  CustomText(
                                    value.mealPlans[index].mealPlan,
                                    fontSize: 18,
                                  ),
                                  const SizedBox(height: 10),
                                  CustomText(
                                    "Sent by : ${value.mealPlans[index].coachModel.name}",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                        itemCount: value.mealPlans.length,
                      );
          },
        ),
      ),
    );
  }
}
