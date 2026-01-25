import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/taskpage.dart';
import 'getX.dart';
import 'modelclass.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  // bool isloading=false;
  // String? profileUrl;
  final GetxClass controller = Get.put(GetxClass());
  @override
  // void initState() {
  //   super.initState();
  //   getdata();
  // }
  // void getdata(){
  //   setState(() {
  //     isloading=true;
  //   });
  //   try{
  //     final uid = FirebaseAuth.instance.currentUser?.uid;
  //     if (uid != null) {
  //       FirebaseFirestore.instance.collection('user').doc(uid).snapshots().listen((snapshot) {
  //         if (snapshot.exists) {
  //           setState(() {
  //             profileUrl = snapshot.data()?['profile_url'];
  //             isloading=false;
  //           });
  //         }});
  //     }
  //   }catch(e){
  //     setState(() {
  //       isloading=false;
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error: $e')),
  //     );setState(() {
  //       isloading=false;
  //     });
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 360;
    return Scaffold(
      body:  Container(
          height:double.infinity,width:double.infinity,decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1253AA),Color(0xFF05243E),]
          )
      ),
          child:SafeArea(
            child: SingleChildScrollView(
              child: Column(children: [
                Obx(() => Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.09,
                        backgroundImage: controller.profileUrl.value.isNotEmpty
                            ? NetworkImage(controller.profileUrl.value) : null,
                        child: controller.isProfileLoading.value
                            ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.redAccent, strokeWidth: 2))
                            : (controller.profileUrl.value.isEmpty ? Icon(Icons.person, size: MediaQuery.of(context).size.width * 0.08) : null),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.userName.value,
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                          Text(
                            controller.userEmail.value,
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          )
                        ],
                      ),
                    ),
                  ],
                )),SizedBox(height: 20,),
                // StreamBuilder<QuerySnapshot>(
                //     stream: FirebaseFirestore.instance.collection("user").doc(
                //         FirebaseAuth.instance.currentUser?.uid).collection("task").snapshots(),
                Obx(() {
                  if (controller.isTaskLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }if (controller.allTask.isEmpty) {
                    return Center(child: Text("No tasks found", style: TextStyle(color: Colors.white)));
                  }return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("   Incomplete Task", style: TextStyle(fontSize: 20, color: Colors.white)),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.allTask.length,
                        itemBuilder: (context, index) {
                          final task = controller.allTask[index];
                          if (task.DoneTask == false) {
                            return Padding(
                              padding: const EdgeInsets.all(11),
                              child: Card(
                                child: ListTile(
                                  leading: task.PinTask == true ? Icon(Icons.push_pin,
                                      color: Colors.blue) : null,
                                  trailing: InkWell(
                                    child: Icon(Icons.navigate_next_rounded, size: 30),
                                    onTap: () {
                                      Get.to(() => TaskDetailPage(taskdata: task));
                                      // Navigator.push(context,
                                      //   MaterialPageRoute(builder: (context) => TaskDetailPage(taskdata: task)),
                                      // );
                                    },
                                  ),
                                  title: Text(task.Task, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  subtitle: Row(
                                    children: [
                                      Text(task.Date),
                                      Text(" | ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                      Text(task.Time),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }return SizedBox.shrink();
                        },
                      ),
                      Text("   Complete", style: TextStyle(fontSize: 20, color: Colors.white)),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.allTask.length,
                        itemBuilder: (context, index) {
                          final task = controller.allTask[index];
                          if (task.DoneTask == true) {
                            return Padding(
                              padding: const EdgeInsets.all(11),
                              child: Card(
                                child: ListTile(
                                  leading: Icon(Icons.check_circle, color: Colors.greenAccent),
                                  trailing: InkWell(
                                    child: Icon(Icons.navigate_next_rounded, size: 30),
                                    onTap: () {
                                      Get.to(() => TaskDetailPage(taskdata: task));
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(builder: (context) => TaskDetailPage(taskdata: task)),
                                      // );
                                    },
                                  ),
                                  title: Row(
                                    children: [
                                      Text(task.Task, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), maxLines: 1, overflow: TextOverflow.ellipsis),
                                      SizedBox(width: 10),
                                      if (task.PinTask == true) Icon(Icons.push_pin, color: Colors.blueAccent)
                                    ],
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text(task.Date),
                                      Text(" | ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                      Text(task.Time),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                          return SizedBox.shrink();
                        },
                      ),
                    ],
                  );
                })
               // ),

              ],),
            ),
          )
      ),);
  }
}

