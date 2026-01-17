import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'bottomnavigation bar screen.dart';
import 'onboardingscreen.dart';

class UsercheckScreen extends StatefulWidget {
  const UsercheckScreen({super.key});
  @override
  State<UsercheckScreen> createState() => _UsercheckScreenState();
}

class _UsercheckScreenState extends State<UsercheckScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;

  void dp() {
    auth.authStateChanges().listen((User? user) {
      if (!mounted) return;

      if (user == null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => OnboardingScreens()),
              (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Bottomnavigationbarscreen()),
              (route) => false,
        );}
    });
  }

  @override
  void initState() {
    super.initState();
    dp();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}