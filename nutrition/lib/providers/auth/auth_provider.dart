import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:nutrition/controllers/auth_controller.dart';
import 'package:nutrition/controllers/coach_controller.dart';
import 'package:nutrition/model/user_model.dart';
import 'package:nutrition/providers/notifications/notification_provider.dart';
import 'package:nutrition/screen/avaialble_coaches_list.dart';
import 'package:nutrition/screen/main/coach/coach_dashboard.dart';
import 'package:nutrition/screen/main/user/user_dashboard.dart';
import 'package:nutrition/screen/welcomepage.dart';
import 'package:nutrition/utils/alert_helper.dart';
import 'package:nutrition/utils/shared_pref.dart';
import 'package:nutrition/utils/util_functions.dart';
import 'package:provider/provider.dart';

class AuthProvider extends ChangeNotifier {
  //---auth controller

  final AuthController _authController = AuthController();

  final CoachController _coachController = CoachController();

  //---email text controller
  final _emailController = TextEditingController();

  //--get email controller
  TextEditingController get emailController => _emailController;

  //---password text controller
  final _passwordController = TextEditingController();

  //--get password controller
  TextEditingController get passwordController => _passwordController;

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
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
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

  //---start the Login process
  Future<void> startLogin(BuildContext context) async {
    try {
      //-check if the validations are pass
      if (validateFields(context)) {
        //--start the loader
        setLoading(true);
        //---start ceating user
        await _authController
            .loginUser(
          _emailController.text,
          _passwordController.text,
          context,
        )
            .then(
          (value) async {
            if (value != null) {
              SharedPref.instance.setStringValue("uid", value.uid);

              await startFetchUserData(context, value.uid).then((value) {
                //---clear controllers
                _emailController.clear();

                _passwordController.clear();

                //--stop the loader
                setLoading(false);

                if (_userModel?.userType == "user") {
                  UtilFunctions.navigateTo(context, const UserDashboard());
                } else {
                  UtilFunctions.navigateTo(context, const CoachDashboard());
                }
              });
            } else {
              //--stop the loader
              setLoading(false);
            }
          },
        );
      }
    } catch (e) {
      Logger().e(e);
      //--stop the loader
      setLoading(false);
    }
  }

  //---usermodel
  UserModel? _userModel;

  //---get usermodel
  UserModel? get userModel => _userModel;

  void setUser(UserModel model) {
    _userModel = model;
    notifyListeners();
  }

  //-----------------fetch user data
  Future<void> startFetchUserData(BuildContext context, String uid) async {
    try {
      await _authController.fetchUserData(uid).then((value) {
        //---check if the fetched result is null
        if (value != null) {
          _userModel = value;
          notifyListeners();
        } else {
          //---shows an error snackbar
          AlertHelper.showSnackBar(context, "Error fetching user data");
        }
      });
    } catch (e) {
      Logger().e(e);
    }
  }

  //----initialize and listen to user auth state
  Future<void> initializUser(BuildContext context) async {
    String uid = await SharedPref.instance.getStringValue("uid");

    Logger().w(uid);

    if (uid != "") {
      await _authController.fetchUserData(uid).then(
        (value) {
          //---check if the fetched result is null
          if (value != null) {
            _userModel = value;
            notifyListeners();

            Logger().w(_userModel?.userType);

            if (_userModel?.userType == "user") {
              UtilFunctions.navigateTo(context, const UserDashboard());
            } else {
              UtilFunctions.navigateTo(context, const CoachDashboard());
            }
          } else {
            //---shows an error snackbar
            AlertHelper.showSnackBar(context, "Error fetching user data");

            UtilFunctions.navigateTo(context, const WelcomeScreen());
          }
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      UtilFunctions.navigateTo(context, const WelcomeScreen());
    }
  }

  Future<void> signOut(BuildContext context) async {
    await SharedPref.instance.removeValue("uid");
    await FirebaseAuth.instance.signOut().then(
      (value) {
        UtilFunctions.pushremoveNavigation(context, const WelcomeScreen());
      },
    );
  }

  //--update users BMI value
  Future<void> updateUserBMI(double val, BuildContext context) async {
    try {
      //--stop the loader
      setLoading(true);

      await _authController.updateBMI(_userModel!.uid, val).then((value) {
        _userModel!.bmi = val;
        notifyListeners();
        //--stop the loader
        setLoading(false);

        //--start fetch coaches
        startGetCoaches();

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AvailableCoacheslist()),
        );
      });
    } catch (e) {
      //--stop the loader
      setLoading(false);
      Logger().e(e);
    }
  }

  //-----===================================-fetch coaches list

  //---store coaches list
  List<UserModel> _coaches = [];

  //---getter
  List<UserModel> get coaches => _coaches;

  //----creating coaches loader state
  bool _isFetchingCoaches = false;

  //--get loading state
  bool get isFetchingCoaches => _isFetchingCoaches;

  //---set loader state
  void setIsFetchingCoaches(bool val) {
    _isFetchingCoaches = val;
    notifyListeners();
  }

  //---start fetching coaches list
  Future<void> startGetCoaches() async {
    try {
      //start the loader
      setIsFetchingCoaches(true);

      //-start fetching
      await _coachController.fetchCoachesList().then(
        (value) {
          _coaches = value;
          Logger().w(_coaches.length);
          notifyListeners();

          //stop the loader
          setIsFetchingCoaches(false);
        },
      );
    } catch (e) {
      Logger().e(e);
      //stop the loader
      setIsFetchingCoaches(false);
    }
  }

  //--------------pick, upload and update user profile image

  //---pick an image
  final ImagePicker _picker = ImagePicker();

  //---file object
  File _image = File("");

  //--get picked file
  File get image => _image;

  //---pick image function
  Future<void> selectImage() async {
    try {
      // Pick an image
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      //--check if the user has picked a file or not
      if (pickedFile != null) {
        //---assigning to the file object
        _image = File(pickedFile.path);

        //--start uploading the file
        await uploadAndProfileImage(_image);
        notifyListeners();
      } else {
        Logger().e("no image selected ");
      }
    } catch (e) {
      Logger().e(e);
    }
  }

  // //----upload image loader state
  // bool _isLoading = false;

  // //--get loading state
  // bool get isLoading => _isLoading;

  // //---set loader state
  // void setLoading(bool val) {
  //   _isLoading = val;
  //   notifyListeners();
  // }

  //---upload picked image file to firebase storage
  Future<void> uploadAndProfileImage(File pickedFIle) async {
    try {
      //--start the loader
      setLoading(true);

      //upload pcked file
      final imgUrl = await _authController.uploadAndupdateProfileImage(pickedFIle, _userModel!.uid);

      if (imgUrl != "") {
        //---update the usermodel img field with the retunred download url
        _userModel!.img = imgUrl;
        notifyListeners();

        setLoading(false);
      } else {
        setLoading(false);
      }
    } catch (e) {
      Logger().e(e);
      setLoading(false);
    }
  }

  //--save paid users to coach
  Future<void> savePaidUsers(String coachUid, String coachToken, BuildContext context) async {
    try {
      if (_userModel != null) {
        //--stop the loader
        setLoading(true);

        await _coachController.addPaidUsers(coachUid, _userModel!).then(
          (value) {
            Provider.of<NotificationProvider>(context, listen: false).sendCoachNotification(
              receiverToken: coachToken,
              userModel: _userModel!,
            );
            //--stop the loader
            setLoading(false);

            AlertHelper.showPaidAlert(context, "Payment success", "You can now have the coach's service");
          },
        );
      } else {
        //---shows an error snackbar
        AlertHelper.showSnackBar(context, "Usermodel is null");
      }
    } catch (e) {
      //--stop the loader
      setLoading(false);
      Logger().e(e);
    }
  }

  //---update usermodel token field with device token
  void setDeviceToken(String token) {
    _userModel!.token = token;
    notifyListeners();
  }
}
