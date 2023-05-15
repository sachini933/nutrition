import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nutrition/controllers/coach_controller.dart';
import 'package:nutrition/model/user_model.dart';
import 'package:nutrition/providers/auth/auth_provider.dart';
import 'package:nutrition/utils/alert_helper.dart';
import 'package:nutrition/utils/util_functions.dart';
import 'package:provider/provider.dart';

class CoachProvider extends ChangeNotifier {
  final CoachController _coachController = CoachController();

  //-----===================================-fetch coach's padi users list

  //---store coaches list
  List<UserModel> _padiUsers = [];

  //---getter
  List<UserModel> get padiUsers => _padiUsers;

  //----creating coaches loader state
  bool _isFetchingPaidUsers = false;

  //--get loading state
  bool get isFetchingPaidUsers => _isFetchingPaidUsers;

  //---set loader state
  void setIsFetchingPaidUsers(bool val) {
    _isFetchingPaidUsers = val;
    notifyListeners();
  }

  //---start fetching paid users list
  Future<void> startGetPaidUsers(BuildContext context) async {
    try {
      String uid = Provider.of<AuthProvider>(context, listen: false).userModel!.uid;
      //start the loader
      setIsFetchingPaidUsers(true);

      //-start fetching
      await _coachController.fetchPaidUsersList(uid).then(
        (value) {
          _padiUsers = value;
          Logger().w(_padiUsers.length);
          notifyListeners();

          //stop the loader
          setIsFetchingPaidUsers(false);
        },
      );
    } catch (e) {
      Logger().e(e);
      //stop the loader
      setIsFetchingPaidUsers(false);
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

  //--update users BMI value
  Future<void> startAddMealPlan(String userid, String mealPlan, BuildContext context) async {
    try {
      UserModel coachModel = Provider.of<AuthProvider>(context, listen: false).userModel!;
      //--stop the loader
      setLoading(true);

      await _coachController
          .addMealPlan(
        userid: userid,
        mealPlan: mealPlan,
        coachModel: coachModel,
      )
          .then(
        (value) {
          //--stop the loader
          setLoading(false);

          AlertHelper.showSnackBar(context, "Meal PLan added", type: AnimatedSnackBarType.success);

          UtilFunctions.goBack(context);
        },
      );
    } catch (e) {
      //--stop the loader
      setLoading(false);
      Logger().e(e);
    }
  }
}
