import 'package:flutter/material.dart';
import 'package:nutrition/providers/auth/auth_provider.dart';
import 'package:nutrition/reusable_widgets/reusable_widget.dart';
import 'package:nutrition/screen/auth/resetpassword.dart';
import 'package:nutrition/screen/auth/select_user_type.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.1, 10, 0),
            child: Consumer<AuthProvider>(
              builder: (context, value, child) {
                return Column(
                  children: <Widget>[
                    const Text(
                      "SIGN IN",
                      style: TextStyle(
                        color: Color(0xff14c38e),
                        fontSize: 24,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Image.asset('assets/images/fix.png'),
                    const SizedBox(
                      height: 30,
                    ),
                    reusableTextField("Email", Icons.person_outline, false, value.emailController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Password", Icons.lock_outline, true, value.passwordController),
                    const SizedBox(
                      height: 5,
                    ),
                    forgetPassword(context),
                    firebaseUIButton(
                      context,
                      "Sign In",
                      () {
                        value.startLogin(context);
                        // FirebaseAuth.instance
                        //     .signInWithEmailAndPassword(
                        //   email: _emailTextController.text,
                        //   password: _passwordTextController.text,
                        // )
                        //     .then((value) {
                        //   Navigator.push(context, MaterialPageRoute(builder: (context) => const Dashboard()));
                        // }).onError((error, stackTrace) {
                        //   print("Error ${error.toString()}");
                        // });
                      },
                      isLoading: value.isLoading,
                    ),
                    signUpOption()
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?", style: TextStyle(color: Colors.blueGrey)),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SelectUserType()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.blue),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ResetPassword())),
      ),
    );
  }
}
