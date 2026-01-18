import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/taskpage.dart';
import 'bottomsheet.dart';
import 'modelclass.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}
class _MenuPageState extends State<MenuPage> {
  int index=0;
  TextEditingController SearchController = TextEditingController();
  String search = "";
  List<String> items = ["By Pin", "By Name", "By Month"];
  String? selecteditems = "By Name";
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 360;
    return Scaffold(
      backgroundColor: Color(0xFF1253AA),
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Container(

          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1253AA), Color(0xFF05243E)],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        height:  size.height * 0.055,
                        child: TextFormField(
                          controller: SearchController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            suffixIcon: Icon(Icons.search, color: Colors.white),
                            hintText: "Search by task title",
                            hintStyle: TextStyle(color: Colors.white),
                            fillColor: Color(0xFF1248AA),
                            filled: true,
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              search = value.toString();
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        height: size.height * 0.05,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Color(0xFF05243E),
                        ),
                        child: Row(
                          children: [
                            if (!isSmall) ...[
                              SizedBox(width: 6),
                              Text("  Sort ", style: TextStyle(color: Colors.white,fontSize: size.width* 0.04)),
                            ],
                            Expanded(
                              child: DropdownButton<String>(
                                value: selecteditems,
                                dropdownColor: Color(0xFF05243E),
                                iconEnabledColor: Colors.white,
                                style: TextStyle(color: Colors.white),
                                items: items.map((e)=>DropdownMenuItem(value: e,
                                  child: Text(e, style: TextStyle(color: Colors.white)),
                                )
                                ).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selecteditems = newValue;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],),
              Expanded(
                child: StreamBuilder(
                  stream:
                  FirebaseFirestore.instance.collection("user").doc(
                      FirebaseAuth.instance.currentUser?.uid).collection("task").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "   Tasks List",
                            style: TextStyle(color: Colors.white, fontSize: size.width * 0.055,),
                          ),
                        ),
                        Flexible(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              TodoModelClass modelClass =
                              TodoModelClass.fromJson(
                                snapshot.data!.docs[index].data(),
                              );
                              String taskTitle = modelClass.Task.toLowerCase();
                              String searchText = SearchController.text
                                  .toLowerCase();
                              if (SearchController.text.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: GestureDetector(
                                    child: Column(
                                      children: [
                                        Card(
                                          child: ListTile(
                                            trailing: InkWell(
                                              child: Icon(
                                                Icons.navigate_next_rounded,
                                                size: 30,
                                              ),
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        TaskDetailPage(
                                                          taskdata: modelClass,
                                                        ),
                                                  ),
                                                );
                                              },
                                            ),
                                            title: Text(
                                              modelClass.Task,
                                              style: TextStyle(
                                                fontWeight: .bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            subtitle: Row(
                                              children: [
                                                Text(modelClass.Date),
                                                Text(
                                                  " | ",
                                                  style: TextStyle(
                                                    fontWeight: .bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                Text(modelClass.Time),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else if (taskTitle.contains(searchText)) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    child: Card(
                                      child: ListTile(
                                        trailing: InkWell(
                                          child: Icon(
                                            Icons.navigate_next_rounded,
                                            size: 30,
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    TaskDetailPage(
                                                      taskdata: modelClass,
                                                    ),
                                              ),
                                            );
                                          },
                                        ),
                                        title: Text(
                                          modelClass.Task,
                                          style: TextStyle(
                                            fontWeight: .bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        subtitle: Row(
                                          children: [
                                            Text(modelClass.Date),
                                            Text(
                                              " | ",
                                              style: TextStyle(
                                                fontWeight: .bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(modelClass.Time),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              {
                                return Card();
                              }
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async {
          await showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return TaskBottomSheetScreen();
            },
          );
          setState(() {});
        },
        shape: CircleBorder(),
        backgroundColor: Color(0xFF63D9F3),
        child: Icon(Icons.add_rounded, fontWeight: .w900, color: Colors.white),
      ),
    );
  }
}
