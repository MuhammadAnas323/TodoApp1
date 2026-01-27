import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:todo_app/taskpage.dart';
import 'bottomsheet.dart';
import 'getX.dart';
import 'modelclass.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}
class _MenuPageState extends State<MenuPage> {
  TextEditingController SearchController = TextEditingController();
  String search = "";
  List<String> items = ["By Pin", "By Name", "By Month"];
  String? selecteditems = "By Name";
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GetxClass controller = Get.put(GetxClass());
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
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: SearchController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: const Color(0xFF1248AA),
                          hintText: "Search...",
                          hintStyle: const TextStyle(color: Colors.white70),
                          suffixIcon: const Icon(Icons.search, color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) => setState(() => search = value),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF05243E),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selecteditems,
                            dropdownColor: const Color(0xFF05243E),
                            iconEnabledColor: Colors.white,
                            style: const TextStyle(color: Colors.white),
                            items: items.map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e, overflow: TextOverflow.ellipsis),
                            )).toList(),
                            onChanged: (value) => setState(() => selecteditems = value),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child:
                  Obx (() {
                    if (controller.isTaskLoading.value) {
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
                            itemCount: controller.allTask.length,
                            itemBuilder: (context, index) {
                              TodoModelClass modelClass =
                              TodoModelClass.fromJson(
                                controller.allTask[index].toJson()
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
                                                Get.to(() => TaskDetailPage(taskdata: modelClass));
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
                                            Get.to(() => TaskDetailPage(taskdata: modelClass));
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
                  },)
               // ),
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
