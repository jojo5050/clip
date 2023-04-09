import 'package:clip/Models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../Utils/progress_bar.dart';

class ClientProfile extends StatefulWidget {
  const ClientProfile({Key? key, required this.clientInfo}) : super(key: key);

  final QueryDocumentSnapshot<Object?> clientInfo;

  @override
  State<ClientProfile> createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile> {

  CollectionReference requestCollection = FirebaseFirestore.instance.collection("Request");
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  ClientDetails? clientInfo;
  bool sendRqst = false;
  bool cancelRqst = false;
  bool loading1 = false;
  bool loading2 = false;
  bool isCancelVisible = false;
  bool isSendVisible = true;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 6.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 30,
                    )),
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                      color: Colors.black,
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
                                    //  signOut();
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.share,
                                        color: Colors.green,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        "Share Profile",
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
              backgroundImage: NetworkImage(widget.clientInfo["profilePic"]),
            )),
            SizedBox(
              height: 1.h,
            ),
            Text(widget.clientInfo["name"]),
            SizedBox(
              height: 1.h,
            ),
            Text(widget.clientInfo["username"]),
            SizedBox(
              height: 1.h,
            ),
            Text(widget.clientInfo["Location"]),
            SizedBox(
              height: 10.h,
            ),

              ElevatedButton(
                        onPressed: () {
                          send();
                          showCancelButton();
                          hideSendButton();
                        },
                        style: ElevatedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                            primary: Colors.green,
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.w, vertical: 2.h),
                            textStyle: TextStyle(
                                fontSize: 15.sp, fontWeight: FontWeight.bold)),
                        child: const Text('Send Request')),


                   ElevatedButton(
                      onPressed: () {
                        cancel();
                        showSendButton();
                        hideCancelButton();
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
                      child: const Text('Cancel Request')),
          ],
        ),
      ),
    );
  }

      Future<void> send() async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        "friend request sent",
        style: TextStyle(color: Colors.white),
      ),
    ));

    Map<String, dynamic> user1Map = {
      "ownRequest": {
        widget.clientInfo["userID"]
      },
      "username": widget.clientInfo["username"]
    };
    requestCollection.doc(_firebaseAuth.currentUser?.uid).update(user1Map);


    Map<String, dynamic> user2Map = {
      "friendRequest": {
        _firebaseAuth.currentUser?.uid
      },
      "username": _firebaseAuth.currentUser?.displayName
    };
    requestCollection.doc(widget.clientInfo["userID"]).update(user2Map);
  }


  void cancel() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        "canceled",
        style: TextStyle(color: Colors.white),
      ),
    ));
  }

  void showCancelButton() {
    setState(() {
      isCancelVisible = !isCancelVisible;
    });
  }

  void hideSendButton() {
    setState(() {
      isSendVisible = !isSendVisible;
    });
  }

  void showSendButton() {
    setState(() {
      isSendVisible = !isSendVisible;
    });
  }

  void hideCancelButton() {
    setState(() {
      isCancelVisible = !isCancelVisible;
    });
  }
} 
