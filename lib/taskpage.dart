import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import 'bottomnavigation bar screen.dart';
import 'bottomsheet.dart';
import 'getX.dart';
import 'main.dart';
import 'modelclass.dart';

class TaskDetailPage extends StatefulWidget {
  final TodoModelClass taskdata;

  TaskDetailPage({
    super.key,
    required this.taskdata,

  });
  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}
class _TaskDetailPageState extends State<TaskDetailPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController Task = TextEditingController();
  TextEditingController Time = TextEditingController();
  TextEditingController Discription = TextEditingController();
  TextEditingController Date= TextEditingController();
  final GetxClass controller = Get.put(GetxClass());
  @override
  void initState() {
    super.initState();
    widget.taskdata;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1253AA),
        leading: IconButton(
          icon: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF63D9F3),
              size: 20,
            ),
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          "Task Details",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: Expanded(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1253AA), Color(0xFF05243E)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child:
                            Column(
                              children: [
                                ListTile(
                                  title: Row(
                                    children: [
                                      Text(
                                        widget.taskdata.Task,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: .bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      GestureDetector(
                                        child: IconButton(
                                          onPressed: ()async {
                                            await showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return TaskBottomSheetScreen(
                                                  taskModel: widget.taskdata,);
                                              },
                                            );
                                            setState(() {
                                            });
                                          },
                                          icon: Icon(
                                            Icons.edit_calendar_outlined,
                                            color: Colors.white,
                                            size: 25,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text(
                                        widget.taskdata.Date,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        "  |  ",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: .bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        widget.taskdata.Time,
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.only(right: 45),
                                  child: Container(
                                    width: 320,
                                    height: 1,
                                    color: Color(0xFFFFFFFF40),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.taskdata.Discription,
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  Align(alignment: Alignment.centerLeft),
                  Expanded(
                    child:
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  FirebaseFirestore.instance.collection("user").doc(FirebaseAuth.instance.currentUser!.uid)
                                      .collection("task").
                                  doc(widget.taskdata.documentid).update({
                                    "DoneTask":true,
                                  });
                                  Get.off(() => Bottomnavigationbarscreen());
                                  // setState(() {
                                  //
                                  // });
                                },
                                style: ElevatedButton.styleFrom(

                                  backgroundColor: Color(0xFF05243E),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 5.0),
                                        child: Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 25,
                                        ),
                                      ),
                                      SizedBox(
                                          height: 12
                                      ),
                                      Text(
                                        "Done",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),Spacer(),
                          Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        title:Text("Confirm Delete"),
                                        content:Text("Are you sure you want to delete this task?"),
                                        actions: [TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child:Text("Cancel"),
                                        ),
                                          TextButton(
                                            onPressed: () async {
                                              await FirebaseFirestore.instance.collection("user").doc(FirebaseAuth.instance.currentUser!.uid)
                                                  .collection("task").
                                              doc(widget.taskdata.documentid)
                                                  .delete();
                                              Get.offAll(() => Bottomnavigationbarscreen());
                                              // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                              //   builder: (context) => Bottomnavigationbarscreen(initialindex: 1,),
                                              // ),
                                              //       (route)=>false,
                                              // );
                                            },
                                            child:Text(
                                              "Yes",
                                              style: TextStyle(color: Colors.red,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF05243E),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5.0),
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 25,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Delete",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            children: [
                              SizedBox(
                                child: ElevatedButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance.collection("user").doc(FirebaseAuth.instance.currentUser!.uid)
                                        .collection("task").
                                    doc(widget.taskdata.documentid).update({
                                      "PinTask":true,

                                    },
                                    );
                                    Get.off(() => Bottomnavigationbarscreen());
                                    // Navigator.pushReplacement(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) =>
                                    //         Bottomnavigationbarscreen(),
                                    //   ),
                                    // );setState(() {
                                    //
                                    // });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF05243E),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 7),
                                          child: Icon(
                                            Icons.push_pin,
                                            color: Colors.yellow,
                                            size: 25,
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        Text(
                                          "Pin",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

