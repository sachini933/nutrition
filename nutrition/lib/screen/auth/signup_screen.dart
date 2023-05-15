import 'package:flutter/material.dart';
import 'package:nutrition/providers/auth/signup_provider.dart';
import 'package:nutrition/reusable_widgets/reusable_widget.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();
  final TextEditingController _ageTextController = TextEditingController();
  final TextEditingController _genderTextController = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: const Text(
          "User Sign Up",
          style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Consumer<SignupProvider>(
              builder: (context, value, child) {
                return Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter User Name", Icons.person_outline, false, value.nameController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Email", Icons.email, false, value.emailController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter Password", Icons.lock_outlined, true, value.passwordController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Phone Number", Icons.phone_android_outlined, false, value.phoneController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Age", Icons.person_2, false, value.ageController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Gender", Icons.generating_tokens_outlined, false, value.genderController),
                    const SizedBox(
                      height: 20,
                    ),
                    firebaseUIButton(
                      context,
                      "Sign Up",
                      () {
                        value.startSignup(context);
                        // FirebaseAuth.instance
                        //     .createUserWithEmailAndPassword(
                        //   email: _emailTextController.text,
                        //   password: _passwordTextController.text,
                        // )
                        //     .then(
                        //   (value) async {
                        //     CollectionReference collRef = FirebaseFirestore.instance.collection('client');
                        //     await collRef.add(
                        //       {
                        //         'name': _userNameTextController.text,
                        //         'email': _emailTextController.text,
                        //         'password': _passwordTextController.text,
                        //         'phone Number': _phoneTextController.text,
                        //         'Age': _ageTextController.text,
                        //         'Gender': _genderTextController.text,
                        //       },
                        //     ).then(
                        //       (value) {
                        //         print("Created New Account");
                        //         Navigator.push(context, MaterialPageRoute(builder: (context) => const Homepage()));
                        //       },
                        //     );
                        //   },
                        // ).onError(
                        //   (error, stackTrace) {
                        //     print("Error ${error.toString()}");
                        //   },
                        // );
                      },
                      isLoading: value.isLoading,
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
