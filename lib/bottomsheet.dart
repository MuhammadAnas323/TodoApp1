import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'menuepage.dart';
import 'modelclass.dart';

class TaskBottomSheetScreen extends StatefulWidget {
  final TodoModelClass? taskModel;
  const TaskBottomSheetScreen({super.key,this.taskModel});
  State<TaskBottomSheetScreen> createState() => _TaskBottomSheetScreenState();
}

class _TaskBottomSheetScreenState extends State<TaskBottomSheetScreen> {
  late TextEditingController Task=TextEditingController();
  late TextEditingController Discription=TextEditingController();
  late TextEditingController Date=TextEditingController();
  late TextEditingController Time=TextEditingController();
  final formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    if(widget.taskModel !=null){
      Task.text=widget.taskModel?.Task??"";
      Discription.text=widget.taskModel?.Discription??"";
      Date.text=widget.taskModel?.Date??"";
      Time.text=widget.taskModel?.Time??"";
    }
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 360;
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller:Task,
                  style: TextStyle(color: Colors.white),
                  key: ValueKey("Task"),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFF05243E),
                    hintText: "Task",

                    prefixIcon: Icon(
                      Icons.check_box_outlined,
                      color: Colors.white,
                    ),
                    hintStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter Task Title";
                    }
                    return null;
                  },
                ),
                SizedBox(height:size.height * 0.03),

                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller:Discription,
                  key: ValueKey("Description"),
                  maxLines: 6,
                  decoration: InputDecoration(
                    fillColor: Color(0xFF05243E),
                    filled: true,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 120),
                      child: Icon(
                        Icons.menu_rounded,
                        color: Colors.white,
                      ),
                    ),
                    hintText: "Description",
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter Description";
                    }
                    return null;
                  },
                ),
                SizedBox(height: size.height * 0.03),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: size.height * 0.055,
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller:Date,
                          key: ValueKey("Date"),
                          decoration: InputDecoration(
                            fillColor: Color(0xFF05243E),
                            filled: true,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.calendar_month_rounded,
                                color: Colors.white,
                              ),
                            ),
                            hintText: "Date",
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter Date";
                            }
                            return null;
                          },
                          onTap: () async {
                            DateTime? datePicked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1947),
                              lastDate: DateTime(2080),
                            );
                            if (datePicked != null) {
                              Date.text =
                              "${datePicked.day}/${datePicked.month}/${datePicked.year}";
                              setState(() {});
                            };
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 20,),
                    Expanded(
                      child: SizedBox(
                        height: size.height * 0.055,
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          controller:Time,
                          key: ValueKey("Time"),
                          decoration: InputDecoration(
                            fillColor: Color(0xFF05243E),
                            filled: true,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.access_time_sharp,
                                color: Colors.white,
                              ),
                            ),
                            hintText: "Time",
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter Time";
                            }
                            return null;
                          },
                          onTap: () async {
                            TimeOfDay? pickedTime =
                            await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (pickedTime != null) {
                              Time.text =
                              "${pickedTime.hour}:${pickedTime.minute}";
                            }
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {

                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                        child: Text("Cancel"),
                      ),
                    ),Spacer(),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          if (widget.taskModel == null) {
                            var docId = FirebaseFirestore.instance.collection("user").doc().id;
                            String? userId=FirebaseAuth.instance.currentUser?.uid;
                            if(userId==null) {
                              return;
                            }
                            TodoModelClass newTask = TodoModelClass(
                              Task: Task.text,
                              Discription: Discription.text,
                              Date: Date.text,
                              Time: Time.text,
                              documentid: docId,
                              DoneTask: false,
                              PinTask: false,
                            );
                            await FirebaseFirestore.instance
                                .collection("user")
                                .doc(userId).collection('task').doc(docId)
                                .set(newTask.toJson());
                            Navigator.pop(context,
                              MaterialPageRoute(
                                builder: (context) => MenuPage(),
                              ),
                            );setState(() {

                            });
                          } else {
                            widget.taskModel!.Task = Task.text;
                            widget.taskModel!.Discription = Discription.text;
                            widget.taskModel!.Date = Date.text;
                            widget.taskModel!.Time = Time.text;

                            await FirebaseFirestore.instance
                                .collection("user").doc(FirebaseAuth.instance.currentUser!.uid).
                            collection("task").doc(widget.taskModel!.documentid)
                                .update({
                              "Task": Task.text,
                              "Discription": Discription.text,
                              "Date": Date.text,
                              "Time": Time.text,
                            });
                            Navigator.pop(context);
                          }

                        }
                        setState(() {

                        }); },
                      style: ElevatedButton.styleFrom(
                        // fixedSize: Size(166, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Color(0xFF0EA5E9),
                      ),
                      child: Text(
                        widget.taskModel == null ? "Create" : "Update",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
