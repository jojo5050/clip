
import 'package:clip/Screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../Models/global_variables.dart';


class LogedUserProfile extends StatefulWidget {
  final String documentID;

  const LogedUserProfile({Key? key, required this.documentID})
      : super(key: key);

  @override
  _LogedUserProfileState createState() => _LogedUserProfileState();
}

class _LogedUserProfileState extends State<LogedUserProfile> {
  CollectionReference usersRef = FirebaseFirestore.instance.collection("Users");
  User? currentuser = FirebaseAuth.instance.currentUser;
  final firebaseStorage = FirebaseStorage.instance;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String userName = "";
  String fullName = "";

  dynamic imageFile;
  Future<String>? profilePicUrl;

  String? imageData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: FutureBuilder<DocumentSnapshot>(
        future: usersRef.doc(currentuser?.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          dynamic data = snapshot.data?.data();
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 7.h),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(15)),
                        child: PopupMenuButton(
                            color: Colors.black,
                            elevation: 20,
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                              size: 25,
                            ),
                            itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 1,
                                    child: Container(
                                      child: GestureDetector(
                                        onTap: () {
                                          signOut();
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.logout,
                                              color: Colors.red,
                                              size: 20,
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              "LogOut",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Center(
                      child: CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(data["profilePic"]),
                            )
                      ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    "${data['username']}",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.sp),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    "${data["name"]}",
                    style: TextStyle(color: Colors.grey[600], fontSize: 16.sp, ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text("${data['Location'] ?? ""} ",  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.sp),),

                  ElevatedButton(
                      onPressed: () {
                        accept();

                      },
                      style: ElevatedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          primary: Colors.red,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.w, vertical: 2.h),
                          textStyle: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.bold)),
                      child: const Text('Accept Request')),
                ],
              ),
            );

          }

          return Container(
            child: Text(
              "No Data",
              style: TextStyle(color: Colors.green),
            ),);
          },
        )

      ),
    );
  }

  void signOut() {
    _firebaseAuth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (route) => false);
  }

  void accept() {


  }
}
