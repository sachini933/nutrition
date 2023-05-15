import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UtilFunctions {
  //----navigate function
  static void navigateTo(BuildContext context, Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }

  //----go back
  static void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  //--navigate using push rmeove
  static void pushremoveNavigation(BuildContext context, Widget page) {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => page), (Route<dynamic> route) => true);
  }

  ///--calculate calory
  static String calcCalories(double amount, double calInOneGram) {
    return (amount * calInOneGram).toStringAsFixed(2);
  }

  static String getCurrentDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(now); // Format the date as "Monday, January 1, 2022".
    return formattedDate;
  }
}
