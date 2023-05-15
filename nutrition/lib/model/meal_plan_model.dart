// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:nutrition/model/user_model.dart';

class MealPlanModel {
  UserModel coachModel;
  String mealPlan;

  MealPlanModel(
    this.coachModel,
    this.mealPlan,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'coachModel': coachModel.toMap(),
      'mealPlan': mealPlan,
    };
  }

  factory MealPlanModel.fromMap(Map<String, dynamic> map) {
    return MealPlanModel(
      UserModel.fromMap(map['coachModel'] as Map<String, dynamic>),
      map['mealPlan'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MealPlanModel.fromJson(String source) => MealPlanModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
