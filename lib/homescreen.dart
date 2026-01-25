import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/provider_class.dart';
import 'package:todo_app/taskpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isloading = false;
  String? profileUrl;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = context.read<ProviderClass>();
      provider.getTask();
      provider.getProfile();
    });
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 360;
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1253AA), Color(0xFF05243E)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Consumer<ProviderClass>(
                      builder: (context, profileProvider, child) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: CircleAvatar(
                            radius: size.width * 0.09,
                            backgroundImage: profileProvider.profileUrl != null
                                ? NetworkImage(profileProvider.profileUrl!)
                                : null,
                            child: profileProvider.isProfileLoading
                                ? const SizedBox(
                                    height: 20, width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.redAccent,
                                    ),
                                  )
                                : profileProvider.profileUrl == null
                                ? Icon(Icons.person, size: size.width * 0.08)
                                : null,
                          ),
                        );
                      },
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            FirebaseAuth.instance.currentUser?.displayName ??
                                '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                          Text(
                            FirebaseAuth.instance.currentUser?.email ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Consumer<ProviderClass>(
                  builder: (context, taskprovider, child) {
                    if (taskprovider.isTaskLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "   Incomplete Task",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: taskprovider.incompleteTask.length,
                          itemBuilder: (context, int index) {
                            final modelClass = taskprovider.incompleteTask[index];
                            return Padding(
                              padding: const EdgeInsets.all(11),
                              child: Card(
                                child: ListTile(
                                  leading: modelClass.PinTask == true
                                      ? Icon(Icons.push_pin, color: Colors.blue) : null,
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
                                      fontSize: 18,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
                          },
                        ),
                        Text(
                          "   Complete",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: taskprovider.completeTask.length,
                          itemBuilder: (context, index) {
                            final modelClass = taskprovider.completeTask[index];
                            return Padding(
                              padding: const EdgeInsets.all(11),
                              child: Card(
                                child: ListTile(
                                  leading: Icon(
                                    Icons.check_circle,
                                    color: Colors.greenAccent,
                                  ),

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
                                      ),
                                      SizedBox(width: 41),
                                      if (modelClass.PinTask == true)
                                        Icon(
                                          Icons.push_pin,
                                          color: Colors.blueAccent,
                                        ),
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
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
