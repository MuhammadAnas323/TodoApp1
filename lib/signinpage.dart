import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/signuppage.dart';
import 'bottomnavigation bar screen.dart';
import 'firebase_options.dart';


class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isloading=false;
  final formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController forgotPassword= TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  void showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              height: 220,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cancel,
                    color: Colors.red,
                    size: 40,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Sign in Failed",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        height:double.infinity,width: double.infinity,
        decoration:
        BoxDecoration(gradient:LinearGradient(begin:Alignment.topCenter,end:Alignment.bottomCenter,
            colors: [Color(0xFF1253AA), Color(0xFF05243E)]) ),
        child: SingleChildScrollView(
          child: Column(
            children: [Padding(padding: EdgeInsets.only(top: 80)),
              Icon(Icons.check_circle_sharp,size: 100,color: Colors.white,),
              Column(
                children: [
                  Text("Welcome Back To Do IT",style:
                  TextStyle(color: Colors.white,fontWeight: .bold,fontSize: 23),),
                  Text("Have an other productive day !",
                    style:
                    TextStyle(color: Colors.white,fontSize: 15),),
                ],
              ),SizedBox(height: 40,),
              Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextFormField(
                        controller: email,
                        key: ValueKey('email'),
                        decoration: InputDecoration(prefixIcon: Icon(Icons.mail),
                          hint: Text("E-mail ",style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: .bold),),

                          fillColor: Colors.white,filled: true,
                          border: OutlineInputBorder(borderSide:.none,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        validator: (value){
                          if(value==null || value.isEmpty){
                            return "Please Enter Email";
                          }
                          return null;
                        },

                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextFormField(
                          controller: password,
                          key: ValueKey('password'),
                          decoration: InputDecoration(prefixIcon: Icon(Icons.lock),
                            hint: Text("Password",style: TextStyle(
                                color: Colors.black,fontWeight: .bold,fontSize: 17),),
                            fillColor: Colors.white,filled: true,
                            border: OutlineInputBorder(borderSide: .none,
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter Password";
                            } else{
                              return null;
                            }
                          }
                      ),
                    ),Row(mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(onPressed: ()async{
                          await showDialog(context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Forgot Password"), content:
                              TextField(controller: forgotPassword,
                                decoration: InputDecoration(hintText: "Enter Email"
                                ),
                              ),
                                actions: [
                                  TextButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),ElevatedButton(
                                    child: Text("Send"),
                                    onPressed: () async {
                                      var ForgotEmail=forgotPassword.text.trim();
                                      try{
                                        FirebaseAuth.instance.sendPasswordResetEmail(email: ForgotEmail);

                                      }catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(e.toString())),
                                        );
                                      }Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }, child: Text("ForgotPasswordasd", style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            isloading = true;
                          });
                          try {
                            UserCredential login = await auth.signInWithEmailAndPassword(
                              email: email.text.trim(),
                              password: password.text.trim(),
                            );

                            await login.user!.reload();
                            User? user = FirebaseAuth.instance.currentUser;

                            if (user != null && user.emailVerified) {
                              setState(() {
                                isloading = false;
                              });
                              if (!mounted) return;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>Bottomnavigationbarscreen(),
                                ),
                              );
                            } else {
                              setState(() {
                                isloading = false;
                              });
                              if (!mounted) return;
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Verify Email"),
                                  content: const Text("Your email is not verified yet. Please check your inbox."),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("OK"),
                                    ),
                                  ],
                                ),
                              );
                              await auth.signOut();
                            }
                          } catch (e) {
                            setState(() {
                              isloading = false;
                            });
                            if (!mounted) return;
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Login Error"),
                                content: Text(e.toString()),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("OK"),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0EA5E9),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        minimumSize: const Size(348, 42),
                      ),
                      child: isloading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("sign in", style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have account?",style: TextStyle(color: Colors.white,fontSize: 16),),
                        TextButton(onPressed: (){
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => SignUpScreen()),
                                (route) => false,);
                        },
                            child:Text("sign up",style:
                            TextStyle(color: Color(0xFF0EA5E9),fontSize: 17)) ),
                      ],
                    ),
                    SizedBox(height: 70,),


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
