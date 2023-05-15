class UserProfile {
  final String userName;
  final String email;
  final int age;
  final String gender;
  final String phoneNumber;

  UserProfile({
    required this.userName,
    required this.email,
    required this.age,
    required this.gender,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'email': email,
      'age': age,
      'gender': gender,
      'phoneNumber': phoneNumber,
    };
  }
}
