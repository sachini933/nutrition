import 'package:flutter/material.dart';
import 'package:nutrition/components/custom_text.dart';
import 'package:nutrition/providers/home/user_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class NutrientsSection extends StatefulWidget {
  const NutrientsSection({super.key});

  @override
  State<NutrientsSection> createState() => _NutrientsSectionState();
}

class _NutrientsSectionState extends State<NutrientsSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Consumer<UserProvider>(
        builder: (context, value, child) {
          return Column(
            children: [
              const SizedBox(height: 20),
              CommonProgressBar(
                nutrient: "Protein",
                value: value.nutrientsData["protein"]!,
              ),
              const SizedBox(height: 20),
              CommonProgressBar(
                nutrient: "Carbohydrates",
                color: Colors.green,
                value: value.nutrientsData["carbs"]!,
              ),
              const SizedBox(height: 20),
              CommonProgressBar(
                nutrient: "Fiber",
                color: Colors.blue,
                value: value.nutrientsData["fiber"]!,
              ),
              const SizedBox(height: 20),
              CommonProgressBar(
                nutrient: "Sugar",
                value: value.nutrientsData["sugar"]!,
                color: Colors.red,
              ),
              const SizedBox(height: 20),
              CommonProgressBar(
                nutrient: "Fat",
                color: Colors.amber,
                value: value.nutrientsData["fat"]!,
              ),
            ],
          );
        },
      ),
    );
  }
}

class CommonProgressBar extends StatelessWidget {
  const CommonProgressBar({
    super.key,
    this.value = 0.5,
    this.color,
    required this.nutrient,
  });

  final double value;
  final Color? color;
  final String nutrient;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 5, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                nutrient,
                fontSize: 20,
              ),
              CustomText(
                "Total - ${double.parse((value).toStringAsFixed(2))} g",
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
        LinearPercentIndicator(
          lineHeight: 12.0,
          percent: value / (10 * 100),
          barRadius: const Radius.circular(10),
          backgroundColor: Colors.grey.shade300,
          progressColor: color ?? Colors.orange,
        ),
      ],
    );
  }
}
