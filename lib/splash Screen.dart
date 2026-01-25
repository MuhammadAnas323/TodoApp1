import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:todo_app/usercheckscreen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => SplashscreenState();
}

class SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {
      Get.off(() => UsercheckScreen());
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute<void>(
      //     builder: (BuildContext context) => UsercheckScreen(),
      //   ),
      // );
    });
  }
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
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 170)),
                Icon(Icons.check_circle, color: Colors.white, size: 100),
                SizedBox(height: 50),
                Text(
                  "Do  IT",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: .bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 350),
                Text(
                  "v 1.0.0",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
