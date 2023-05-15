import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:nutrition/model/food_model.dart';
import 'package:nutrition/model/main_food_model.dart';
import 'package:nutrition/model/meal_plan_model.dart';

class UserController {
  //---firebase auth instance
  final FirebaseAuth auth = FirebaseAuth.instance;

  //---------saving data in cloud firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Create a CollectionReference called users that references the firestore collection
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  //-- save food items by user

  Future<void> saveFoods(String uid, MainFoodModel foodModel, String size, String mealName) async {
    await users
        .doc(uid)
        .collection("foods")
        .add(
          {
            "foodModel": foodModel.toMap(),
            "size": double.parse(size),
            "mealName": mealName,
            "date": DateTime.now().toString(),
            "totalCalories": double.parse((double.parse(size) * foodModel.calories).toStringAsFixed(2))
          },
        )
        .then((value) => Logger().i("food saved"))
        .catchError((error) => Logger().e("Failed to add: $error"));
  }

  //--fetch user's food list  from cloudfirestore
  Future<List<FoodModel>> fetchUserSelectedFoodList(String uid) async {
    try {
      //---firebase query tht find and fetch food list
      QuerySnapshot documentSnapshot = await users.doc(uid).collection("foods").get();

      //--food list
      List<FoodModel> list = [];

      Logger().w(documentSnapshot.docs.length);

      if (documentSnapshot.docs.isNotEmpty) {
        for (var e in documentSnapshot.docs) {
          //--mapping to food model
          FoodModel model = FoodModel.fromMap(e.data() as Map<String, dynamic>);

          //--adding to the list
          list.add(model);
        }

        return list;
      } else {
        //---if error occurs
        Logger().e("data not found");
        return [];
      }
    } catch (e) {
      Logger().e(e);
      return [];
    }
  }

  CollectionReference foods = FirebaseFirestore.instance.collection('food');

  //--fetch main food list with all the calories and nutrients  from cloudfirestore
  Future<List<MainFoodModel>> fetchMainFoodList() async {
    // try {
    //---firebase query tht find and fetch food list
    QuerySnapshot documentSnapshot = await foods.get();

    //--food list
    List<MainFoodModel> list = [];

    // Logger().w(documentSnapshot.docs.length);

    if (documentSnapshot.docs.isNotEmpty) {
      for (var e in documentSnapshot.docs) {
        //--mapping to food model
        MainFoodModel model = MainFoodModel.fromMap(e.data() as Map<String, dynamic>);

        //--adding to the list
        list.add(model);
      }

      return list;
    } else {
      //---if error occurs
      Logger().e("data not found");
      return [];
    }
    // } catch (e) {
    //   Logger().e(e);
    //   return [];
    // }
  }

  //--fetch padi users list from cloudfirestore
  Future<List<MealPlanModel>> fetchMealPlans(String uid) async {
    try {
      //---firebase query tht find and fetch coaches list
      QuerySnapshot documentSnapshot = await users.doc(uid).collection("mealPlans").get();

      //--MealPlanModel list
      List<MealPlanModel> list = [];

      // Logger().w(documentSnapshot.docs.length);

      if (documentSnapshot.docs.isNotEmpty) {
        for (var e in documentSnapshot.docs) {
          //--mapping to users model
          MealPlanModel model = MealPlanModel.fromMap(e.data() as Map<String, dynamic>);

          //--adding to the list
          list.add(model);
        }

        return list;
      } else {
        //---if error occurs
        Logger().e("data not found");
        return [];
      }
    } catch (e) {
      Logger().e(e);
      return [];
    }
  }
}
