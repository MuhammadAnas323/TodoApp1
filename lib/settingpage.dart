import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/signinpage.dart';

import 'getX.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({super.key});

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  late double screenWidth = MediaQuery.of(context).size.width;
  bool isloading = false;
  final GetxClass controller = Get.put(GetxClass());

  var currentuserid = FirebaseAuth.instance.currentUser;
  final supabase = Supabase.instance.client;
  File? profilepic;
  String? profileUrl;
  @override
  void initState() {
    super.initState();
    getdata();
  }

  void getdata() {
    setState(() {
      isloading = true;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        FirebaseFirestore.instance.collection('user').doc(user.uid).get().then((
          doc,
        ) {
          if (doc.exists && doc.data()!.containsKey('profile_url')) {
            setState(() {
              profileUrl = doc['profile_url'];
            });
          }
        });
      }
    } catch (e) {
      setState(() {
        isloading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
    setState(() {
      isloading = false;
    });
  }
  void deletePhoto() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await FirebaseFirestore.instance.collection('user').doc(user!.uid).update({
      'profile_url': FieldValue.delete(),
    });
    setState(() {
      profileUrl = null;
      profilepic = null;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Container(
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
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Text("Profile",style: TextStyle(color: Colors.white,fontSize: 25),),SizedBox(height: 75,),
                Center(
                  child: CircleAvatar(
                        radius: screenWidth * 0.230,
                        backgroundImage: profilepic != null
                            ? FileImage(profilepic!) as ImageProvider : (profileUrl != null
                                  ? NetworkImage(profileUrl!) as ImageProvider : null),
                        child: isloading == true
                            ? CircularProgressIndicator() : profilepic == null && profileUrl == null
                            ? Icon(Icons.person, size: 40) : null,
                      ),
                ),SizedBox(height: 30),
                TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);},
                                  icon:Icon(Icons.close_rounded,size: 27,),),
                                Text(
                                  "Profile",
                                  style: TextStyle(color: Colors.black,
                                    fontSize: 25, fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(onPressed: () {
                                  showDialog(

                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        title:Text("Confirm Delete"),
                                        content:Text("Are you sure to delete this Photo"),
                                        actions: [TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child:Text("Cancel"),
                                        ),
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                             deletePhoto();
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
                                  );},
                                  icon: Icon(Icons.delete,color: Colors.redAccent,size: 27,),
                                ),
                              ],
                            ),SizedBox(height: 25,),TextButton.icon(onPressed: ()async{
                              final XFile? pickedFile = await ImagePicker()
                                  .pickImage(source: ImageSource.camera);
                              if (pickedFile == null) return;
                              if (mounted) Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Confirmation"),
                                    content:Text(
                                      "Do you want to update your profile picture?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child:Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          final messenger = ScaffoldMessenger.of(
                                            context,
                                          );
                                          Navigator.pop(context);
                                          setState(() {
                                            isloading = true;
                                          });
                                          try {
                                            final userId = FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid;
                                            final timestamp = DateTime.now()
                                                .millisecondsSinceEpoch;
                                            final path =
                                                'user/$userId-$timestamp.jpg';
            
                                            profilepic = File(pickedFile.path);
                                            await supabase.storage
                                                .from('bucket1')
                                                .upload(
                                              path,
                                              profilepic!,
                                              fileOptions: const FileOptions(
                                                upsert: true,
                                              ),
                                            );
                                            var imageUrl = supabase.storage
                                                .from('bucket1')
                                                .getPublicUrl(path);
                                            await FirebaseFirestore.instance
                                                .collection('user')
                                                .doc(userId)
                                                .update({
                                              'profile_url': imageUrl,
                                            });
            
                                            if (!mounted) return;
                                            setState(() {
                                              isloading = false;
                                              profileUrl = imageUrl;
                                            });
                                            messenger.showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Profile uploaded successfully",
                                                ),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          } catch (e) {
                                            if (!mounted) return;
                                            setState(() {
                                              isloading = false;
                                            });
                                            messenger.showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Profile uploading Field",
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                  ),
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        },
                                        child: const Text(
                                          "Yes",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }, label: Row(
                              children: [
                                Icon(Icons.camera_alt,size: 25,color: Colors.black,),Text("Camera",
                                  style: TextStyle(color: Colors.black,fontSize: 20),)
                              ],
                            )
                            ),SizedBox(height: 20,),
                            TextButton.icon(onPressed: ()async{
                              final XFile? pickedFile = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              if (pickedFile == null) return;
                              if (mounted) Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Confirmation"),
                                    content: const Text(
                                      "Do you want to update your profile picture?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          final messenger = ScaffoldMessenger.of(
                                            context,
                                          );
                                          Navigator.pop(context);
                                          setState(() {
                                            isloading = true;
                                          });
                                          try {
                                            final userId = FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid;
                                            final timestamp = DateTime.now()
                                                .millisecondsSinceEpoch;
                                            final path =
                                                'user/$userId-$timestamp.jpg';
            
                                            profilepic = File(pickedFile.path);
                                            await supabase.storage
                                                .from('bucket1')
                                                .upload(
                                              path,
                                              profilepic!,
                                              fileOptions: const FileOptions(
                                                upsert: true,
                                              ),
                                            );
                                            var imageUrl = supabase.storage
                                                .from('bucket1')
                                                .getPublicUrl(path);
                                            await FirebaseFirestore.instance
                                                .collection('user')
                                                .doc(userId)
                                                .update({
                                              'profile_url': imageUrl,
                                            });
            
                                            if (!mounted) return;
                                            setState(() {
                                              isloading = false;
                                              profileUrl = imageUrl;
                                            });
                                            messenger.showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Profile uploaded successfully",
                                                ),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          } catch (e) {
                                            if (!mounted) return;
                                            setState(() {
                                              isloading = false;
                                            });
                                            messenger.showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Profile uploading Field",
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                  ),
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        },
                                        child: const Text(
                                          "Yes",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }, label: Row(
                              children: [
                                Icon(Icons.photo,size: 25,color: Colors.black,),Text("Gallery",
                                  style: TextStyle(color: Colors.black,fontSize: 20),)
                              ],
                            )
                            ),
                          ],
            
                        );
                        },
                    );
                  },
                  child: Text(
                    "Edit",
                    style: TextStyle(color: Colors.white, fontWeight: .bold,fontSize: 20),
                  ),
                ),SizedBox(height: 20,),
                ListTile(leading: Icon(Icons.person,color: Colors.white,size: 30,),
                  title: Text("Name",style: TextStyle(color: Colors.white,fontSize: 18),),
                  subtitle: Text(FirebaseAuth.instance.currentUser!.displayName.toString(),
                    style: TextStyle(color: Colors.white,fontSize: 15),),),SizedBox(height: 25,),
                ListTile(leading: Icon(Icons.email,color: Colors.white,size: 25,),
                  title: Text("Email",style: TextStyle(color: Colors.white,fontSize: 18),),
                  subtitle: Text(FirebaseAuth.instance.currentUser!.email.toString(),
                    style: TextStyle(color: Colors.white,fontSize: 15),),),SizedBox(height: 40,),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signOut();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Log Out Succesfully")),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignInPage()),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Logout Field Please Try Again")),
                      );
                    }
                  },
                  child: Text("Logout", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
