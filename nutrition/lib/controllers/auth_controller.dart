import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nutrition/controllers/file_upload_controller.dart';
import 'package:nutrition/model/user_model.dart';
import 'package:nutrition/utils/alert_helper.dart';
import 'package:nutrition/utils/app_assets.dart';

class AuthController {
  //---firebase auth instance
  final FirebaseAuth auth = FirebaseAuth.instance;

  //---------saving data in cloud firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Create a CollectionReference called users that references the firestore collection
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  //-----signup user function

  Future<User?> signupUser(
    String email,
    String password,
    String name,
    String phone,
    String age,
    String gender,
    String userType,
    BuildContext context,
  ) async {
    try {
      //--send email and password to the firebase and try to create a user
      return await auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then(
        (value) async {
          //check if the user is not null
          if (value.user != null) {
            //---save extra userdata in firestore
            await saveUserData(value.user!.uid, name, email, password, phone, age, gender, userType);

            Logger().i(value.user);

            return value.user;
          } else {
            // ignore: use_build_context_synchronously
            AlertHelper.showAlert(context, "Error", "Something went wrong! try again ");

            return null;
          }
        },
      );
    } on FirebaseAuthException catch (e) {
      Logger().e(e.message);
      AlertHelper.showAlert(context, "Error", e.message!);
      return null;
    } catch (e) {
      Logger().e(e);
      AlertHelper.showAlert(context, "Error", e.toString());
      return null;
    }
  }

//---login user
  Future<User?> loginUser(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      //--send email and password to the firebase and try to login a user
      final credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        Logger().i(credential.user);

        return credential.user;
      } else {
        // ignore: use_build_context_synchronously
        AlertHelper.showAlert(context, "Error", "Something went wrong! try again ");

        return null;
      }
    } on FirebaseAuthException catch (e) {
      Logger().e(e.message);
      AlertHelper.showAlert(context, "Error", e.message!);
      return null;
    } catch (e) {
      Logger().e(e);
      AlertHelper.showAlert(context, "Error", e.toString());
      return null;
    }
  }

  // //----reset password
  // Future<void> sendPassResetEmail(BuildContext context, String email) async {
  //   try {
  //     await auth.sendPasswordResetEmail(email: email).then(
  //       (value) {
  //         AlertHelper.showAlert(
  //           context,
  //           "Email sent !",
  //           "Please check your inbox !",
  //           dialogType: DialogType.success,
  //         );
  //       },
  //     );
  //   } catch (e) {
  //     Logger().e(e);
  //   }
  // }

  //---save extra user data in cloud firestore
  Future<void> saveUserData(
    String uid,
    String name,
    String email,
    String password,
    String phone,
    String age,
    String gender,
    String userType,
  ) async {
    // Call the user's CollectionReference to add a new user
    await users
        .doc(uid)
        .set(
          {
            "uid": uid,
            'name': name,
            'email': email,
            'password': password,
            'phoneNumber': phone,
            'age': age,
            'gender': gender,
            'userType': userType,
            'bmi': 0.0,
            'img': AppAssets.profileUrl,
            "token": "",
          },
        )
        .then((value) => Logger().i("User Added"))
        .catchError((error) => Logger().e("Failed to add user: $error"));
  }

  //--fetch userdata from cloudfirestore
  Future<UserModel?> fetchUserData(String uid) async {
    try {
      //---firebase query tht find and fetch user data according to the uid
      DocumentSnapshot documentSnapshot = await users.doc(uid).get();

      if (documentSnapshot.exists) {
        // Logger().w(documentSnapshot.data());

        //mapping fetched data into a userModel
        UserModel model = UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);

        return model;
      } else {
        //---if error occurs
        Logger().e("data not found");
        return null;
      }
    } catch (e) {
      Logger().e(e);
      return null;
    }
  }

  //--update users BMI value

  Future<void> updateBMI(String uid, double value) async {
    await users
        .doc(uid)
        .update(
          {
            "bmi": value,
          },
        )
        .then((value) => Logger().i("bmi updated"))
        .catchError((error) => Logger().e("Failed to update: $error"));
  }

  //---fileupload controller object
  final FileUpladController _fileUpladController = FileUpladController();

  //---upload picked image file to firebase storage
  Future<String> uploadAndupdateProfileImage(File file, String uid) async {
    try {
      //start uploading
      final String downloadUrl = await _fileUpladController.uploadFile(file, "profileImages");

      if (downloadUrl != "") {
        //--updating the uploaded file download url in user data
        await users.doc(uid).update(
          {
            "img": downloadUrl,
          },
        );

        return downloadUrl;
      } else {
        Logger().e("download url is empty,");
        return "";
      }
    } catch (e) {
      Logger().e(e);
      return "";
    }
  }
}
