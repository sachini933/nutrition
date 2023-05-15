import 'package:flutter/material.dart';
import 'package:nutrition/components/custom_text.dart';
import 'package:nutrition/model/user_model.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.model,
    required this.onTap,
  });

  final UserModel model;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: const Color(0xff9B9B9B).withOpacity(.5),
            blurRadius: 5,
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.person_pin_circle_rounded,
                    size: 40,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        model.email,
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "${model.gender} / ${model.age} years old",
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xff0FA956),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CustomText(
                  "BMI\n${model.bmi}",
                  color: Colors.white,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: onTap,
            icon: const Icon(
              Icons.add_circle,
            ),
            label: const CustomText("Add Meal Plan"),
          )
        ],
      ),
    );
  }
}
