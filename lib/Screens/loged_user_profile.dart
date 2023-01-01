
import 'dart:io';

import 'package:clip/AuthMangers/auth_service.dart';
import 'package:clip/Models/user_model.dart';
import 'package:clip/Screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../Utils/routers.dart';

class LogedUserProfile extends StatefulWidget {
 final String documentID;
  const LogedUserProfile({Key? key, required this.documentID}) : super(key: key);

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

  Future<String>? imageLink;

  String? imageData;


  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: Container(

          child: FutureBuilder<DocumentSnapshot> (
            future: usersRef.doc(currentuser?.uid).get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){

              dynamic data = snapshot.data?.data();

              loadImage();

              print("printing user Image as $profilePicUrl");
              if(snapshot.connectionState == ConnectionState.done){
                print("connection done");

                print("printing snapshot data as${snapshot.data?.data()}");
                print("Printing firebase storage snapshot as ${firebaseStorage.ref(currentuser?.uid).child("UserProfilePic")}");

                  return Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                    child: Column(

                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
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
                                    size: 30,
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
                                                    color: Colors.red,
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

                        SizedBox(height: 7.h,),
                            Center(
                              child: imageData != null ?
                              CircleAvatar(
                               radius: 70,
                               backgroundColor: Colors.grey,
                               backgroundImage: NetworkImage("$imageData"),):
                                  
                              const CircleAvatar(radius: 70,
                                backgroundColor: Colors.greenAccent,
                                           )
                            ),
                      SizedBox(height: 5.h,),

                        Text("${data['username']}", style: TextStyle(color: Colors.green),),
                        Text("${data["name"]}", style: TextStyle(color: Colors.green),),




                      ],),
                  )
                  ;
              }

              return Container(child: Text("No Data", style: TextStyle(color: Colors.green),),);

            }
            ,)

        ),
      );


  }

 Future <void> loadImage() async {

   Reference profilePicRef = FirebaseStorage.instance.ref(currentuser?.uid).child("UserProfilePic");
   imageData = await profilePicRef.getDownloadURL();
   print("printing image data as$imageData");

 }

  void signOut() {
    _firebaseAuth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen(),),
          (route) => false);

  }

}
