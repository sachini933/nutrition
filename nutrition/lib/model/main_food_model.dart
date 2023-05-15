// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MainFoodModel {
  String name;
  double calories;
  double carbohydrates;
  double fat;
  double fiber;
  double protein;
  double sugar;

  MainFoodModel(
    this.name,
    this.calories,
    this.carbohydrates,
    this.fat,
    this.fiber,
    this.protein,
    this.sugar,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'calories': calories,
      'carbohydrates': carbohydrates,
      'fat': fat,
      'fiber': fiber,
      'protein': protein,
      'sugar': sugar,
    };
  }

  factory MainFoodModel.fromMap(Map<String, dynamic> map) {
    return MainFoodModel(
      map['name'] as String,
      (map['calories'] as num).toDouble(),
      (map['carbohydrates'] as num).toDouble(),
      (map['fat'] as num).toDouble(),
      (map['fiber'] as num).toDouble(),
      (map['protein'] as num).toDouble(),
      (map['sugar'] as num).toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory MainFoodModel.fromJson(String source) => MainFoodModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
