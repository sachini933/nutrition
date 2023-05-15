import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:nutrition/screen/main/user/user_dashboard.dart';
import 'package:nutrition/utils/util_functions.dart';

class AlertHelper {
  //---shows a dialog
  static void showAlert(BuildContext context, String title, String desc, {DialogType dialogType = DialogType.error}) {
    AwesomeDialog(
      context: context,
      dialogType: dialogType,
      animType: AnimType.rightSlide,
      title: title,
      desc: desc,
      btnCancelOnPress: () {},
      btnOkOnPress: () {},
    ).show();
  }

  //---shows a dialog
  static void showPaidAlert(BuildContext context, String title, String desc) {
    AwesomeDialog(
      dismissOnBackKeyPress: false,
      dismissOnTouchOutside: false,
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: title,
      desc: desc,
      btnOkText: "Go To home",
      btnOkOnPress: () {
        UtilFunctions.navigateTo(context, const UserDashboard());
      },
    ).show();
  }

  //---show a snackbar
  static void showSnackBar(BuildContext context, String msg, {AnimatedSnackBarType type = AnimatedSnackBarType.error}) {
    AnimatedSnackBar.material(
      msg,
      type: type,
      duration: const Duration(seconds: 1),
    ).show(context);
  }
}
