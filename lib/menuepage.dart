import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider_class.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask((){
      final provider=context.read<ProviderClass>();
      provider.getTask();
    });
  }
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
              colors: [Color(0xFF1253AA), Color(0xFF05243E),],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  height: 35,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: SearchController,
                          textAlignVertical: TextAlignVertical.center,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: const Color(0xFF1248AA),
                            hintText: "Search...",
                            hintStyle: const TextStyle(color: Colors.white70),
                            suffixIcon: const Icon(Icons.search, color: Colors.white, size: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              search = value.toString();
                            });
                          },
                        ),
                      ), const SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xFF05243E),
                          ),
                          child: Row(
                            children: [
                              if (!isSmall)
                                Text("Sort ", style: TextStyle(color: Colors.white, fontSize: size.width * 0.03)),
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selecteditems,
                                    isExpanded: true, // Prevents layout crash on small screens
                                    dropdownColor: const Color(0xFF05243E),
                                    iconEnabledColor: Colors.white,
                                    style: const TextStyle(color: Colors.white, fontSize: 13),
                                    items: items.map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e, overflow: TextOverflow.ellipsis),
                                    )).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selecteditems = newValue;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child:
                Consumer<ProviderClass>(
                  builder: (context, provider, child) {
                    if (provider.isTaskLoading) {
                      return const Center(child: CircularProgressIndicator
                        (color: Colors.white));}
                    final allTasks = [];
                    allTasks.addAll(provider.incompleteTask);
                    allTasks.addAll(provider.completeTask);
                    return Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "   Tasks List",
                            style: TextStyle(color: Colors.white, fontSize: size.width * 0.055),
                          ),),
                        Flexible(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: allTasks.length,
                            itemBuilder: (context, index) {
                              final modelClass = allTasks[index];
                              final taskTitle = modelClass.Task.toLowerCase();
                              final searchText = SearchController.text.toLowerCase();
                              if (searchText.isNotEmpty && !taskTitle.contains(searchText)) {
                                return const SizedBox.shrink();
                              }

                              return Padding(
                                padding: const EdgeInsets.all(12),
                                child: Card(
                                  child: ListTile(
                                    title: Text(
                                      modelClass.Task,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Text(modelClass.Date),
                                        const Text(" | ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                        Text(modelClass.Time),
                                      ],
                                    ),
                                    trailing: InkWell(
                                      child: const Icon(Icons.navigate_next_rounded, size: 30),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TaskDetailPage(taskdata: modelClass),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
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
