// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:nutrition/model/main_food_model.dart';

class FoodModel {
  MainFoodModel foodModel;
  double size;
  String mealName;
  String date;
  double totalCalories;

  FoodModel(
    this.foodModel,
    this.size,
    this.mealName,
    this.date,
    this.totalCalories,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'foodModel': foodModel.toMap(),
      'size': size,
      'mealName': mealName,
      'date': date,
      'totalCalories': totalCalories,
    };
  }

  factory FoodModel.fromMap(Map<String, dynamic> map) {
    return FoodModel(
      MainFoodModel.fromMap(map['foodModel'] as Map<String, dynamic>),
      map['size'] as double,
      map['mealName'] as String,
      map['date'] as String,
      map['totalCalories'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory FoodModel.fromJson(String source) => FoodModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
