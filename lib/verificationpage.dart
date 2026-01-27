import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:todo_app/signinpage.dart';


class VerificationPage extends StatefulWidget {
  VerificationPage({super.key});
  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  TextEditingController email = TextEditingController();
  bool isloading=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1253AA), Color(0xFF05243E)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Text(
                  "Verify account",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
              SizedBox(height: 50),
              Container(
                height: 468,
                width: 360,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white38,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        "DO IT",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: .bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(35),
                      child: Text(
                        "By verifying your account, you data will be "
                            "secured and be default you are "
                            "accepting our terms and policies",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: Text(
                        "Please Click on Verify Butten,then we will send you verification Email",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final user = FirebaseAuth.instance.currentUser;
                        setState(() {
                          isloading=true;
                        });
                        if (user != null) {
                          try {
                            await user.sendEmailVerification();
                            setState(() {
                              isloading=false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Verification email sent Please Check your  Email inbox.",
                                ),
                              ),
                            );
                          } catch (e) {
                            isloading=false;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Something Wrong")),
                            );
                          }
                        } else {
                          isloading=false;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("No user is currently signed up"),
                            ),
                          );
                        }
                        Get.off(()=>SignInPage());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        fixedSize: Size(280, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("Verify"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
