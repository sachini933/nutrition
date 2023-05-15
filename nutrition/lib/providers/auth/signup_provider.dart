import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nutrition/controllers/auth_controller.dart';
import 'package:nutrition/providers/auth/auth_provider.dart';
import 'package:nutrition/screen/auth/calculate_BMI.dart';
import 'package:nutrition/screen/main/coach/coach_dashboard.dart';
import 'package:nutrition/utils/alert_helper.dart';
import 'package:nutrition/utils/shared_pref.dart';
import 'package:provider/provider.dart';

import '../../utils/util_functions.dart';

class SignupProvider extends ChangeNotifier {
  //---auth controller

  final AuthController _authController = AuthController();

  //---email text controller
  final _emailController = TextEditingController();

  //--get email controller
  TextEditingController get emailController => _emailController;

  //---name text controller
  final _nameController = TextEditingController();

  //--get name controller
  TextEditingController get nameController => _nameController;

  //---password text controller
  final _passwordController = TextEditingController();

  //--get password controller
  TextEditingController get passwordController => _passwordController;

  //---password text controller
  final _phoneController = TextEditingController();

  //--get password controller
  TextEditingController get phoneController => _phoneController;

  //---password text controller
  final _ageController = TextEditingController();

  //--get password controller
  TextEditingController get ageController => _ageController;

  //---password text controller
  final _genderController = TextEditingController();

  //--get password controller
  TextEditingController get genderController => _genderController;

  String _userType = "user";

  String get usertype => _userType;

  void setUserType(String type) {
    _userType = type;
    notifyListeners();
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

//---------------validate text inputs
  bool validateFields(BuildContext context) {
    //---first checking if all the etxtfields are rmoty or not
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty || _nameController.text.isEmpty) {
      Logger().w("Please fill all the fields !");
      //--shows a dialog
      AlertHelper.showAlert(context, 'Validation Error', 'Please fill all the fields !');

      return false;
    } else if (!_emailController.text.contains("@")) {
      //--shows a dialog
      AlertHelper.showAlert(context, 'Validation Error', 'Please enter a valid email !');

      return false;
    } else if (_passwordController.text.length < 6) {
      //--shows a dialog
      AlertHelper.showAlert(context, 'Validation Error', 'The password must have more than 6 digits !');

      return false;
    } else {
      Logger().w(_emailController.text);
      return true;
    }
  }

  //---start the singup process
  Future<void> startSignup(BuildContext context) async {
    try {
      //-check if the validations are pass
      if (validateFields(context)) {
        //--start the loader
        setLoading(true);
        //---start ceating user
        var res = await _authController.signupUser(
          _emailController.text,
          _passwordController.text,
          _nameController.text,
          _phoneController.text,
          _ageController.text,
          _genderController.text,
          _userType,
          context,
        );

        Logger().w(res);
        if (res != null) {
          //---clear controllers
          _emailController.clear();
          _nameController.clear();
          _passwordController.clear();
          _phoneController.clear();
          _ageController.clear();
          _genderController.clear();

          await _authController.fetchUserData(res.uid).then(
            (value) {
              //---check if the fetched result is null
              if (value != null) {
                Provider.of<AuthProvider>(context, listen: false).setUser(value);

                if (value.userType == "user") {
                  //--stop the loader
                  setLoading(false);
                  UtilFunctions.navigateTo(context, const CalculateBMI());
                } else {
                  SharedPref.instance.setStringValue("uid", value.uid);
                  //--stop the loader
                  setLoading(false);
                  UtilFunctions.navigateTo(context, const CoachDashboard());
                }
              } else {
                //--stop the loader
                setLoading(false);
                //---shows an error snackbar
                AlertHelper.showSnackBar(context, "Error fetching user data");
              }
            },
          );
        } else {
          //---shows an error snackbar
          // ignore: use_build_context_synchronously
          AlertHelper.showSnackBar(context, "Something went wrong");
          //--stop the loader
          setLoading(false);
        }
      }
    } catch (e) {
      Logger().e(e);
      //--stop the loader
      setLoading(false);
    }
  }
}
