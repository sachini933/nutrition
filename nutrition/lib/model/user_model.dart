// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  String uid;
  String name;
  String email;
  String phoneNumber;
  String age;
  String gender;
  String userType;
  double bmi;
  String img;
  String? token;

  UserModel(
    this.uid,
    this.name,
    this.email,
    this.phoneNumber,
    this.age,
    this.gender,
    this.userType,
    this.bmi,
    this.img,
    this.token,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'age': age,
      'gender': gender,
      'userType': userType,
      'bmi': bmi,
      'img': img,
      'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      map['uid'] as String,
      map['name'] as String,
      map['email'] as String,
      map['phoneNumber'] as String,
      map['age'] as String,
      map['gender'] as String,
      map['userType'] as String,
      map['bmi'] as double,
      map['img'] as String,
      map['token'] != null ? map['token'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
