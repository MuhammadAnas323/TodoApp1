import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/main.dart';
import 'bottomnavigation bar screen.dart';
import 'modelclass.dart';

class CalenderPage extends StatefulWidget {
  const CalenderPage({super.key});

  @override
  State<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? selectedDay = DateTime.now();
  CalendarFormat calendarFormat = CalendarFormat.month;
  final formKey = GlobalKey<FormState>();
  int myindex = 0;
  TextEditingController TaskDate = TextEditingController();
  TextEditingController Task = TextEditingController();
  TextEditingController Discription = TextEditingController();
  TextEditingController Time = TextEditingController();
  TextEditingController documentid = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (selectedDay!= null) {
      TaskDate.text = _formatDate(selectedDay!);
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  void onDaySelected(DateTime newSelectedDay, DateTime focusedDay) {
    if (!isSameDay(selectedDay, newSelectedDay)) {
      setState(() {
        selectedDay = newSelectedDay;
        _focusedDay = focusedDay;

        if (selectedDay != null) {
          TaskDate.text = _formatDate(selectedDay!);
        }
      });
    }
  }

  void onFormatChange(CalendarFormat format) {
    setState(() {
      calendarFormat = format;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Manage your Time",
          style: TextStyle(color: Colors.white),)),
        backgroundColor: const Color(0xFF1253AA),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Color(0xFF1253AA), Color(0xFF05243E),])),
        child: SingleChildScrollView(
          child: Column(children: [
            const Padding(padding: EdgeInsets.only(top: 90)),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TableCalendar(
                calendarStyle: const CalendarStyle(
                  defaultTextStyle: TextStyle(color: Colors.white60),
                  weekendTextStyle: TextStyle(color: Colors.yellow),
                ),
                focusedDay: _focusedDay,
                firstDay: DateTime.utc(1947, 1, 1),
                lastDay: DateTime.utc(3000, 1, 1),
                selectedDayPredicate: (day) => isSameDay(selectedDay, day),
                onDaySelected: onDaySelected,
                calendarFormat: calendarFormat,
                onFormatChanged: onFormatChange,
              ),
            ),
            const SizedBox(height: 60,),
            Container(height: 110, width: 390,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 13),
                        child: Text("Set Task For",
                          style: TextStyle(fontSize: 17,fontWeight: .w600),),
                      ),SizedBox.shrink(),
                      Expanded(
                        child: TextField(
                          controller: TaskDate,
                          readOnly: true,
                          textAlign: TextAlign.start,
                          style: const TextStyle(color: Colors.black,
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(border: OutlineInputBorder(borderSide: .none),
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: SizedBox(height: 45, width: 230,
                        child: TextField(
                          controller: Task,
                          //readOnly: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(hintText: "Task",
                              hintStyle: TextStyle(color: Colors.white),
                              fillColor:  Color(0xFF05243E),
                              filled: true,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Container(
                      height: 45,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.cyan,
                      ),
                      child: ElevatedButton(
                        onPressed: () async{
                          try {
                            var docId = FirebaseFirestore.instance
                                .collection("user")
                                .doc()
                                .id;
                            String? userId=FirebaseAuth.instance.currentUser?.uid;
                            if(userId==null){
                              return;}
                            TodoModelClass newTask = TodoModelClass(
                              Task: Task.text,
                              Discription: Discription.text,
                              Time: Time.text,
                              Date: TaskDate.text,
                              PinTask: false,
                              DoneTask: false,
                              documentid: docId,
                            );
                            await FirebaseFirestore.instance
                                .collection("user")
                                .doc(userId).collection('task').doc(docId)
                                .set(newTask.toJson());
                            Navigator.push(context,
                              MaterialPageRoute(
                                builder: (context) => Bottomnavigationbarscreen(),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Data sending Field")),
                            );
                          }
                          setState(() {

                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Submit"),
                      ),
                    )
                  ]),
                ],
              ),
            )
          ],),
        ),
      ),
    );
  }
}
