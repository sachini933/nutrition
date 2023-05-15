import 'package:flutter/material.dart';
import 'package:nutrition/screen/auth/select_user_type.dart';
import 'package:nutrition/screen/main/user/user_dashboard.dart';

class loginuser extends StatefulWidget {
  const loginuser({super.key});

  @override
  State<loginuser> createState() => _loginuserState();
}

class _loginuserState extends State<loginuser> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                Image(
                  image: const AssetImage('assets/images/fix.png'),
                  height: size.height * 0.3,
                ),
                const Text(
                  "Login",
                  style: TextStyle(
                    color: Color(0xff14c38e),
                    fontSize: 24,
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Form(
                    child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person_outlined), labelText: 'E-mail', hintText: 'E-mail', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.fingerprint),
                            labelText: 'Password',
                            hintText: 'Password',
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: null,
                              icon: Icon(Icons.remove_red_eye_sharp),
                            )),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                builder: (context) => Container(
                                  padding: const EdgeInsets.all(30.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Make Selection!", style: Theme.of(context).textTheme.headlineMedium),
                                      Text("Select one of the options given below to reset your password.",
                                          style: Theme.of(context).textTheme.bodyMedium),
                                      const SizedBox(height: 30.0),
                                      const SizedBox(height: 20.0),
                                      ForgetPasswordWidget(
                                        btnIcon: Icons.mail_outline_rounded,
                                        title: 'Email',
                                        subTitle: 'Reset via Email',
                                        onTap: () {},
                                      ),
                                      const SizedBox(height: 20.0),
                                      ForgetPasswordWidget(
                                        btnIcon: Icons.mobile_friendly_outlined,
                                        title: 'Phone No',
                                        subTitle: 'Reset via Phone',
                                        onTap: () {},
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'Forget Password?',
                              style: TextStyle(color: Colors.blue),
                            )),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const UserDashboard()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff14c38e),
                            shape: const RoundedRectangleBorder(),
                          ),
                          child: Text(
                            'Login'.toUpperCase(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SelectUserType()),
                          );
                        },
                        child: Text.rich(TextSpan(text: "Don't Have an Account?", style: Theme.of(context).textTheme.bodySmall, children: const [
                          TextSpan(
                            text: 'Signup',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ])),
                      ),
                    ],
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ForgetPasswordWidget extends StatelessWidget {
  const ForgetPasswordWidget({
    required this.btnIcon,
    required this.title,
    required this.subTitle,
    required this.onTap,
    super.key,
  });
  final IconData btnIcon;
  final String title, subTitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey.shade200,
        ),
        child: Row(
          children: [
            Icon(btnIcon, size: 60.0),
            const SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineSmall),
                Text(subTitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            )
          ],
        ),
      ),
    );
  }
}
