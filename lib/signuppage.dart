import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:todo_app/signinpage.dart';
import 'package:todo_app/verificationpage.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}
class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  bool isloading=false;

  FirebaseAuth auth = FirebaseAuth.instance;

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
              Padding(padding: EdgeInsets.only(top: 60)),
              Icon(Icons.check_circle_sharp, size: 100, color: Colors.white),
              Column(
                children: [
                  Text(
                    "Welcome Back To Do IT",
                    style: TextStyle(color: Colors.white,
                      fontWeight: .bold, fontSize: 25,
                    ),
                  ),
                  Text("Create in account and Join us now!",
                    style: TextStyle(color: Colors.white,
                      fontSize: 15,
                    ),),
                ],
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: name,
                        key: ValueKey('Name'),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.man, size: 30),
                          hint: Text("Name",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: .bold,
                              fontSize: 17,
                            ),),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: .none,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Your Name ";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                    Padding(padding: EdgeInsets.only(top: 13)),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: email,
                        key: ValueKey('email'),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.mail),
                          hint: Text(
                            "E-mail ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: .bold,
                            ),
                          ),

                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: .none,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter some text";
                          }
                          if (!RegExp(r"^[a-zA-Z0-9]+@gmail\.com$",
                          ).hasMatch(value)) {
                            return "Please Enter correct Email like alex1234@gmail.com"
                                "including numbers and letter";
                          }if (email == '') {
                            return("Email not found");

                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: password,
                        key: ValueKey('password'),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          hint: Text(
                            "Password",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: .bold,
                              fontSize: 17,
                            ),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: .none,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter some text";
                          }
                          if (!RegExp(r'^[A-Za-z0-9@$!%*?&]{8,}$',).hasMatch(value)) {
                            return "Please Enter Password like eNdif321h";
                          }return null;
                        },
                      ),
                    ),

                    SizedBox(height: 25),
                    SizedBox(width: 330,
                      child:
                      ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              isloading=true;
                            });
                            try {
                              UserCredential userCred = await auth.createUserWithEmailAndPassword(
                                email: email.text.trim(),
                                password: password.text.trim(),
                              );
                              await userCred.user!.updateDisplayName(name.text.trim());
                              await FirebaseFirestore.instance.collection('user').doc(userCred.user!.uid).set({
                                "email": email.text.trim(),
                                "name": name.text.trim(),
                              });
                              if(!mounted)return;
                              setState(() {
                                isloading=false;
                              });
                              Get.defaultDialog(backgroundColor: Colors.white,
                                title: "Account Created",
                               middleText: "Successfully",titleStyle: TextStyle(fontSize: 20),
                                  middleTextStyle: TextStyle(fontSize: 18),
                                textConfirm: "OK",
                                confirmTextColor: Colors.white,
                                onConfirm: () {
                                  Get.to(() => VerificationPage());
                                },buttonColor: Colors.blueAccent
                              );
                            } catch (e) {
                              setState(() {
                                isloading=false;
                                if(!mounted)return;
                              });
                              Get.snackbar("Sign Up Field","Please Try Again",backgroundColor: Colors.redAccent);
                            }
                          }},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0EA5E9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child:
                        isloading ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("Sign Up", style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have account?",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(() => SignInPage());
                            },
                          child: Text(
                            "sign in",
                            style: TextStyle(
                              color: Color(0xFF0EA5E9),
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20,right: 20),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Sign in with:",
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            SizedBox(width: 20,),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Icon(Icons.apple, size: 30),
                            ),SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Icon(
                                Icons.g_mobiledata,
                                size: 30,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
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
