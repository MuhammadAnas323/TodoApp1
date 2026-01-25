import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/modelclass.dart';

class ProviderClass extends ChangeNotifier {
  bool isTaskLoading = true;
  bool isProfileLoading = true;
  List<TodoModelClass> allTask = [];
  List<TodoModelClass> incompleteTask = [];
  List<TodoModelClass> completeTask = [];
  String? profileUrl;
  String? userName;
  String? userEmail;

  final User? user = FirebaseAuth.instance.currentUser;

  void getTask() {
    isTaskLoading = true;
    notifyListeners();
    final uid = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance
        .collection("user").doc(uid)
        .collection("task").snapshots()
        .listen((snapshot) {

      allTask = snapshot.docs.map((e) => TodoModelClass.fromJson(e.data())).toList();

      incompleteTask = allTask.where((task) {
        if (task.DoneTask == false) {
          return true;
        } else {
          return false;
        }
      }).toList();

      completeTask = allTask.where((task) {
        if (task.DoneTask == true) {
          return true;
        } else {
          return false;
        }
      }).toList();

      isTaskLoading = false;
      notifyListeners();
    });
  }

  void getProfile() {
    isProfileLoading = true;
    notifyListeners();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection("user")
        .doc(uid)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data();
        profileUrl = data?['profile_url'];
        userName = data?['name'] ?? user?.displayName;
        userEmail = data?['email'] ?? user?.email;
      }
      isProfileLoading = false;
      notifyListeners();
    });
  }
}