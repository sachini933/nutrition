import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:nutrition/model/user_model.dart';

class CoachController {
  //---------saving data in cloud firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Create a CollectionReference called users that references the firestore collection
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  CollectionReference mealPlans = FirebaseFirestore.instance.collection('mealPlans');

  //--fetch coaches list from cloudfirestore
  Future<List<UserModel>> fetchCoachesList() async {
    try {
      //---firebase query tht find and fetch coaches list
      QuerySnapshot documentSnapshot = await users.where("userType", isEqualTo: "coach").get();

      //--coaches list
      List<UserModel> list = [];

      Logger().w(documentSnapshot.docs.length);

      if (documentSnapshot.docs.isNotEmpty) {
        for (var e in documentSnapshot.docs) {
          //--mapping to users model
          UserModel model = UserModel.fromMap(e.data() as Map<String, dynamic>);

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

  //--add user to a coach profile when the payment is done

  Future<void> addPaidUsers(String coachUid, UserModel addedUser) async {
    await users
        .doc(coachUid)
        .collection("paidUsers")
        .add(
          addedUser.toMap(),
        )
        .then((value) => Logger().i("user added to coach paid users list"))
        .catchError((error) => Logger().e("Failed to add: $error"));
  }

  //--fetch padi users list from cloudfirestore
  Future<List<UserModel>> fetchPaidUsersList(String uid) async {
    try {
      //---firebase query tht find and fetch coaches list
      QuerySnapshot documentSnapshot = await users.doc(uid).collection("paidUsers").get();

      //--coaches list
      List<UserModel> list = [];

      Logger().w(documentSnapshot.docs.length);

      if (documentSnapshot.docs.isNotEmpty) {
        for (var e in documentSnapshot.docs) {
          //--mapping to users model
          UserModel model = UserModel.fromMap(e.data() as Map<String, dynamic>);

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

  //--add meal plan
  Future<void> addMealPlan({
    required String userid,
    required String mealPlan,
    required UserModel coachModel,
  }) async {
    await users
        .doc(userid)
        .collection("mealPlans")
        .add(
          {
            "mealPlan": mealPlan,
            "coachModel": coachModel.toMap(),
          },
        )
        .then((value) => Logger().i("meal plan added"))
        .catchError((error) => Logger().e("Failed to add: $error"));
  }
}
