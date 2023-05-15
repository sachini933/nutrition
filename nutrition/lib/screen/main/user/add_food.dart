import 'package:flutter/material.dart';
import 'package:nutrition/components/custom_loader.dart';
import 'package:nutrition/components/custom_text.dart';
import 'package:nutrition/model/food_model.dart';
import 'package:nutrition/model/main_food_model.dart';
import 'package:nutrition/providers/home/user_provider.dart';
import 'package:provider/provider.dart';

class AddFood extends StatefulWidget {
  const AddFood({super.key});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Foods Added'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, value, child) {
          return value.isFetchingSelectedFood
              ? const CustomLoader()
              : value.selectedFoods.isEmpty
                  ? const Center(
                      child: CustomText("No added foods"),
                    )
                  : ListView.separated(
                      itemBuilder: (context, index) {
                        return FoodCard(
                          model: value.selectedFoods[index],
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemCount: value.selectedFoods.length,
                    );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddForm(context);
        },
        label: const Text(
          "Add Food",
        ),
        icon: const Icon(
          Icons.fastfood_sharp,
        ),
      ),
    );
  }

  void _showAddForm(BuildContext context) {
    final sizeController = TextEditingController();

    String meal = '';

    late MainFoodModel foodmodel;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<UserProvider>(
          builder: (context, value, child) {
            return AlertDialog(
              title: const Text('Add Food'),
              content: value.isFetchingFood
                  ? const CustomLoader()
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Select the food item"),
                        DropdownButtonFormField(
                          items: value.foods.map<DropdownMenuItem<MainFoodModel>>(
                            (MainFoodModel value) {
                              return DropdownMenuItem<MainFoodModel>(
                                value: value,
                                child: Text(value.name),
                              );
                            },
                          ).toList(),
                          onChanged: (value) {
                            setState(() {
                              foodmodel = value!;
                            });
                          },
                        ),
                        TextField(
                          controller: sizeController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Size in Grams',
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text("Select the Meal"),
                        DropdownButtonFormField(
                          items: <String>['Breakfast', 'Lunch', 'Dinner', 'Snacks'].map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                ),
                              );
                            },
                          ).toList(),
                          onChanged: (value) {
                            setState(() {
                              meal = value!;
                            });
                          },
                        )
                      ],
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
                    value.startSaveFoods(
                      context,
                      foodmodel,
                      sizeController.text,
                      meal,
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class FoodCard extends StatelessWidget {
  const FoodCard({
    super.key,
    required this.model,
  });

  final FoodModel model;

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.fastfood_outlined,
                size: 30,
              ),
              const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.foodModel.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Food Amount - ${model.size}g",
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Calories Amount - ${model.totalCalories}",
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
              model.mealName,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
