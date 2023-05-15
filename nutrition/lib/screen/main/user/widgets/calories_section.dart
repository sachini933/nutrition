import 'package:flutter/material.dart';
import 'package:nutrition/components/custom_button.dart';
import 'package:nutrition/components/custom_loader.dart';
import 'package:nutrition/components/custom_text.dart';
import 'package:nutrition/providers/home/user_provider.dart';
import 'package:nutrition/screen/main/user/add_food.dart';
import 'package:nutrition/utils/util_functions.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class CaloriesSection extends StatelessWidget {
  const CaloriesSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Map<String, double> datamap = {
    //   "Breakfast": 18.47,
    //   "Lunch": 17.20,
    //   "Dinner": 4.25,
    //   "Snaks": 3.67,
    // };

    List<Color> colorList = [
      const Color(0xff1d3482),
      const Color(0xff821d1d),
      const Color(0xff1f821d),
      const Color(0xff827e1d),
    ];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
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
                child: const Image(image: AssetImage('assets/images/home.png')),
              ),
            ),
            Consumer<UserProvider>(
              builder: (context, value, child) {
                return Container(
                  width: 337,
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(37),
                    color: const Color(0xffe3fcbf),
                  ),
                  child: value.isFetchingSelectedFood
                      ? const CustomLoader()
                      : PieChart(
                          dataMap: value.datamap,
                          colorList: colorList,
                          chartRadius: MediaQuery.of(context).size.width / 2,
                          chartValuesOptions: const ChartValuesOptions(
                            showChartValues: true,
                            showChartValuesInPercentage: true,
                          ),
                          legendOptions: const LegendOptions(
                            showLegends: true,
                            legendShape: BoxShape.rectangle,
                            legendTextStyle: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                );
              },
            ),
            const SizedBox(height: 20),
            Consumer<UserProvider>(
              builder: (context, value, child) {
                return CustomText(
                  "Total Calories Gained => ${value.totalCalories}",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                );
              },
            ),
            const SizedBox(height: 10),
            CustomButton(
              text: "Add Calories",
              onTap: () {
                UtilFunctions.navigateTo(context, const AddFood());
              },
            ),
          ],
        ),
      ),
    );
  }
}
