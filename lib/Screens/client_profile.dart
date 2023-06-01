import 'package:clip/Models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../Models/form_model.dart';
import '../Models/global_variables.dart';

class ClientProfile extends StatefulWidget {
  const ClientProfile({Key? key, required this.clientInfo}) : super(key: key);

  final QueryDocumentSnapshot<Object?> clientInfo;

  @override
  State<ClientProfile> createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile> {

  CollectionReference requestRef = FirebaseFirestore.instance.collection("Users");

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FormModel formModel = FormModel();


  ClientDetails? clientInfo;
  bool sendRqst = false;
  bool cancelRqst = false;
  bool loading1 = false;
  bool loading2 = false;
  bool isCancelVisible = false;
  bool isSendVisible = true;

  Map<String, dynamic>? clientMap;

  Map<String, String?>? logedUserMap;

  var clientid;



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
                         // showCancelButton();
                         // hideSendButton();
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
        clientid = widget.clientInfo["userID"];

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        "friend request has been sent",
        style: TextStyle(color: Colors.white),
      ),
    ));
        sendRequest(clientid!);


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

  Future<void> sendRequest(String recipientId) async {
    String senderID = _firebaseAuth.currentUser!.uid;

    await requestRef.doc(senderID)
        .collection("FriendsRequest")
        .doc(clientid)
        .set({"status": "OutGoingPending"});

    await requestRef.doc(recipientId)
        .collection("FriendsRequest")
        .doc(senderID)
        .set({"status": "IncomingPending"});

     }
  }


