import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/taskpage.dart';
import 'modelclass.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  bool isloading=false;
  String? profileUrl;
  @override
  void initState() {
    super.initState();
    getdata();
  }
  void getdata(){
    setState(() {
      isloading=true;
    });
    try{
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        FirebaseFirestore.instance.collection('user').doc(uid).snapshots().listen((snapshot) {
          if (snapshot.exists) {
            setState(() {
              profileUrl = snapshot.data()?['profile_url'];
              isloading=false;
            });
          }});
      }
    }catch(e){
      setState(() {
        isloading=false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );setState(() {
        isloading=false;
      });
    }
  }
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
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal:15,),
                      child:  CircleAvatar(
                        radius: size.width * 0.09,
                        backgroundImage: profileUrl!= null ? NetworkImage(profileUrl!) : null,
                        child: isloading==true ? SizedBox(height:20,width: 20,
                            child: CircularProgressIndicator(color: Colors.redAccent,strokeWidth: 2,)):
                        profileUrl == null ? Icon(Icons.person,size: size.width * 0.08) : null,
                      ),),
                    Expanded(
                      child: Column(
                        children: [
                          Text(FirebaseAuth.instance.currentUser!.displayName.toString(),
                            style: TextStyle(color: Colors.white,fontSize: 22),
                          ),
                          Text(FirebaseAuth.instance.currentUser!.email.toString(),
                            style: TextStyle(color: Colors.white,fontSize: 17),
                          )
                        ],),
                    ),],
                ),SizedBox(height: 20,),
                FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance.collection("user").doc(
                        FirebaseAuth.instance.currentUser?.uid).collection("task").get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Text('Something went Wrong Please try again');
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text("No tasks found",
                            style: TextStyle(color: Colors.white)));
                      }
                      List<TodoModelClass> modelclass = snapshot.data!.docs
                          .map((doc) => TodoModelClass.fromJson(doc.data() as Map<String, dynamic>))
                          .toList();
                      return Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("   Incomplete Task",style: TextStyle(
                              fontSize: 20,color: Colors.white),),
                          ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: modelclass.length,
                              itemBuilder: (context, index) {
                                if (modelclass[index].DoneTask == false) {
                                  TodoModelClass modelClass = modelclass[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(11),
                                    child: Card(
                                      child: ListTile(
                                        leading: modelClass.PinTask == true?
                                        Icon(Icons.push_pin, color: Colors.blue)
                                            : null,
                                        trailing: InkWell(
                                          child: Icon(
                                            Icons.navigate_next_rounded,
                                            size: 30,
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => TaskDetailPage(
                                                  taskdata: modelClass,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        title: Text(
                                          modelClass.Task,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,

                                        ),
                                        subtitle: Row(
                                          children: [
                                            Text(modelClass.Date),
                                            Text(" | ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(modelClass.Time),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                else {
                                  return SizedBox.shrink();
                                }
                              }
                          ),
                          Text("   Complete",style: TextStyle(
                              fontSize: 20,color: Colors.white),),
                          ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: modelclass.length,
                              itemBuilder: (context, index) {
                                if (modelclass[index].DoneTask == true
                                ) {
                                  TodoModelClass modelClass = modelclass[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(11),
                                    child: Card(
                                      child: ListTile(

                                        leading: Icon(Icons.check_circle,color: Colors.greenAccent,),

                                        trailing: InkWell(
                                          child: Icon(
                                            Icons.navigate_next_rounded,
                                            size: 30,
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => TaskDetailPage(
                                                  taskdata: modelClass,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        title: Row(
                                          children: [
                                            Text(
                                              modelClass.Task,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: size.width * 0.045,
                                              ),
                                            ),SizedBox(width: 41,),
                                            if (modelClass.PinTask == true)
                                              Icon(Icons.push_pin, color: Colors.blueAccent)
                                          ],
                                        ),
                                        subtitle: Row(
                                          children: [
                                            Text(modelClass.Date),
                                            Text(
                                              " | ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(modelClass.Time),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return SizedBox.shrink();
                                }
                              }
                          ),
                        ],
                      );
                    }
                ),

              ],),
            ),
          )
      ),);
  }
}

