import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nutrition/controllers/user_controller.dart';
import 'package:nutrition/model/food_model.dart';
import 'package:nutrition/model/main_food_model.dart';
import 'package:nutrition/model/meal_plan_model.dart';
import 'package:nutrition/providers/auth/auth_provider.dart';
import 'package:nutrition/utils/util_functions.dart';
import 'package:provider/provider.dart';

class UserProvider extends ChangeNotifier {
  final UserController _userController = UserController();
  //-----===================================-fetch user's  foodslist

  //---store Food list
  List<FoodModel> _selectedFoods = [];

  //---getter
  List<FoodModel> get selectedFoods => _selectedFoods;

  //----creating coaches loader state
  bool _isFetchingSelectedFoods = false;

  //--get loading state
  bool get isFetchingSelectedFood => _isFetchingSelectedFoods;

  //---set loader state
  void setIsFetchingSelectedFood(bool val) {
    _isFetchingSelectedFoods = val;
    notifyListeners();
  }

  //---start fetching foods list
  Future<void> startGetUserSelectedFoods(BuildContext context) async {
    try {
      String uid = Provider.of<AuthProvider>(context, listen: false).userModel!.uid;

      //start the loader
      setIsFetchingSelectedFood(true);

      //-start fetching
      await _userController.fetchUserSelectedFoodList(uid).then(
        (value) async {
          _selectedFoods = value;
          // Logger().w(_selectedFoods.length);
          notifyListeners();

          await Future.wait([
            calculateCaloryStats(),
            calculateNutrients(),
          ]).then(
            (value) {
              //stop the loader
              setIsFetchingSelectedFood(false);
            },
          );
        },
      );
    } catch (e) {
      Logger().e(e);
      //stop the loader
      setIsFetchingSelectedFood(false);
    }
  }

  //----total calories
  double _toalBreakfastCal = 0.0;

  double _toalLunchCal = 0.0;

  double _toalDinnerCal = 0.0;

  double _toalSnacksCal = 0.0;

  final Map<String, double> _datamap = {
    "Breakfast": 0.00,
    "Lunch": 0.00,
    "Dinner": 0.00,
    "Snacks": 0.00,
  };

  Map<String, double> get datamap => _datamap;

  double _totalCalories = 0.0;

  double get totalCalories => _totalCalories;

  //-------calculate the stats
  Future<void> calculateCaloryStats() async {
    try {
      for (var i = 0; i < _selectedFoods.length; i++) {
        switch (_selectedFoods[i].mealName) {
          case "Breakfast":
            _toalBreakfastCal += _selectedFoods[i].totalCalories;
            break;
          case "Lunch":
            _toalLunchCal += _selectedFoods[i].totalCalories;
            break;
          case "Dinner":
            _toalDinnerCal += _selectedFoods[i].totalCalories;
            break;
          case "Snacks":
            _toalSnacksCal += _selectedFoods[i].totalCalories;
            break;
        }

        _totalCalories += _selectedFoods[i].totalCalories;
      }

      _datamap["Breakfast"] = _toalBreakfastCal;
      _datamap["Lunch"] = _toalLunchCal;
      _datamap["Dinner"] = _toalDinnerCal;
      _datamap["Snacks"] = _toalSnacksCal;
      notifyListeners();
    } catch (e) {
      Logger().e(e);
    }
  }

  //----------------calculate nutrients
  final Map<String, double> _nutrientsData = {
    "carbs": 0.00,
    "fat": 0.00,
    "fiber": 0.00,
    "protein": 0.00,
    "sugar": 0.00,
  };

  Map<String, double> get nutrientsData => _nutrientsData;

  Future<void> calculateNutrients() async {
    try {
      for (var i = 0; i < _selectedFoods.length; i++) {
        var temp = _selectedFoods[i].foodModel;
        var size = _selectedFoods[i].size;

        _nutrientsData["carbs"] = _nutrientsData["carbs"]! + (size * temp.carbohydrates);
        _nutrientsData["fat"] = _nutrientsData["fat"]! + (size * temp.fat);
        _nutrientsData["fiber"] = _nutrientsData["fiber"]! + (size * temp.fiber);
        _nutrientsData["protein"] = _nutrientsData["protein"]! + (size * temp.protein);
        _nutrientsData["sugar"] = _nutrientsData["sugar"]! + (size * temp.sugar);
      }

      notifyListeners();
    } catch (e) {
      Logger().e(e);
    }
  }

  //----creating user loader state
  bool _isLoading = false;

  //--get loading state
  bool get isLoading => _isLoading;

  //---set loader state
  void setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  //---start the Login process
  Future<void> startSaveFoods(
    BuildContext context,
    MainFoodModel foodModel,
    String size,
    String mealName,
  ) async {
    try {
      String uid = Provider.of<AuthProvider>(context, listen: false).userModel!.uid;
      //--start the loader
      setLoading(true);
      //---start ceating user
      await _userController
          .saveFoods(
        uid,
        foodModel,
        size,
        mealName,
      )
          .then(
        (value) async {
          _selectedFoods.add(
            FoodModel(
              foodModel,
              double.parse(size),
              mealName,
              DateTime.now().toString(),
              double.parse((double.parse(size) * foodModel.calories).toStringAsFixed(2)),
            ),
          );

          calculateCaloryStats();
          calculateNutrients();

          notifyListeners();

          setLoading(false);

          UtilFunctions.goBack(context);
        },
      );
    } catch (e) {
      Logger().e(e);
      //--stop the loader
      setLoading(false);
    }
  }

  //---store Food list
  List<MainFoodModel> _foods = [];

  //---getter
  List<MainFoodModel> get foods => _foods;

  //----creating coaches loader state
  bool _isFetchingCoaches = false;

  //--get loading state
  bool get isFetchingFood => _isFetchingCoaches;

  //---set loader state
  void setIsFetchingFood(bool val) {
    _isFetchingCoaches = val;
    notifyListeners();
  }

  //---start fetching foods list
  Future<void> startGetMainFoods(BuildContext context) async {
    try {
      //start the loader
      setIsFetchingFood(true);

      //-start fetching
      await _userController.fetchMainFoodList().then(
        (value) {
          _foods = value;
          // Logger().w(_foods.length);
          notifyListeners();

          //stop the loader
          setIsFetchingFood(false);
        },
      );
    } catch (e) {
      Logger().e(e);
      //stop the loader
      setIsFetchingFood(false);
    }
  }

  //---store Food list
  List<MealPlanModel> _mealPlans = [];

  //---getter
  List<MealPlanModel> get mealPlans => _mealPlans;

  //----creating coaches loader state
  bool _isFetchingPlans = false;

  //--get loading state
  bool get isFetchingPlans => _isFetchingPlans;

  //---set loader state
  void setIsFetchingPlans(bool val) {
    _isFetchingPlans = val;
    notifyListeners();
  }

  //---start fetching foods list
  Future<void> startGetMealPlans(BuildContext context) async {
    try {
      String uid = Provider.of<AuthProvider>(context, listen: false).userModel!.uid;
      //start the loader
      setIsFetchingPlans(true);

      //-start fetching
      await _userController.fetchMealPlans(uid).then(
        (value) {
          _mealPlans = value;
          // Logger().w(_foods.length);
          notifyListeners();

          //stop the loader
          setIsFetchingPlans(false);
        },
      );
    } catch (e) {
      Logger().e(e);
      //stop the loader
      setIsFetchingPlans(false);
    }
  }
}
