
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:todo_app/modelclass.dart';

class GetxClass extends GetxController{
  var isTaskLoading = true.obs;
  var isProfileLoading = true.obs;

  var allTask = <TodoModelClass>[].obs;
  var incompleteTask = <TodoModelClass>[].obs;
  var completeTask = <TodoModelClass>[].obs;

  var profileUrl = ''.obs;
  var userName = ''.obs;
  var userEmail = ''.obs;

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void onInit() {
    super.onInit();
    getTask();
    getProfile();
  }

  void getTask() {
    isTaskLoading(true);
    final uid = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance
        .collection("user")
        .doc(uid)
        .collection("task")
        .snapshots()
        .listen((snapshot) {
      allTask.value = snapshot.docs.map((e) => TodoModelClass.fromJson(e.data())).toList();
      incompleteTask.value = allTask.where((task) => task.DoneTask == false).toList();
      completeTask.value = allTask.where((task) => task.DoneTask == true).toList();

      isTaskLoading(false);
    });
  }

  void getProfile() {
    isProfileLoading(true);
    final uid = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance
        .collection("user").doc(uid).snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data();
        profileUrl.value = data?['profile_url'] ?? '';
        userName.value = data?['name'] ?? user?.displayName ?? 'No Name';
        userEmail.value = data?['email'] ?? user?.email ?? 'No Email';
      }
      isProfileLoading(false);
    });
  }
}