import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nutrition/components/custom_button.dart';
import 'package:nutrition/providers/auth/auth_provider.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Consumer<AuthProvider>(
            builder: (context, value, child) {
              return value.userModel == null
                  ? const Text("Error fetching User Data")
                  : Column(
                      children: [
                        const SizedBox(height: 100),
                        value.isLoading
                            ? const SpinKitDoubleBounce(
                                color: Colors.black,
                                size: 30.0,
                              )
                            : SizedBox(
                                width: 200,
                                height: 200,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(45),
                                      child: Image.network(
                                        value.userModel!.img,
                                        width: 200,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.amber,
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            value.selectImage();
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                        const SizedBox(height: 30),
                        Text(
                          value.userModel!.name,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          value.userModel!.email,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          value.userModel!.phoneNumber,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 100),
                        CustomButton(
                          text: "Logout",
                          onTap: () => Provider.of<AuthProvider>(context, listen: false).signOut(context),
                        ),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }
}
