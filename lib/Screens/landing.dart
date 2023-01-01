import 'dart:io';
import 'package:clip/AuthMangers/auth_service.dart';
import 'package:clip/Screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../Utils/imagePickerManager.dart';


class Landing extends StatefulWidget {
  const Landing({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final imagePickerManager = ImagePickerManager();

  File? profileImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Padding(
       padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.w),
       child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 50,
                  width: 50,
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
                        size: 35,
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: Container(
                            child: GestureDetector(
                              onTap: (){
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
                                        color: Colors.white,
                                        fontSize: 14.sp, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ]
                  ),
                )
              ],
            ),

          ],
        ),
     ),
    );
  }

  void signOut() {
    _firebaseAuth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false);
  }

}
