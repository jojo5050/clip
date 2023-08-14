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
  CollectionReference requestRef =
      FirebaseFirestore.instance.collection("Users");

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FormModel formModel = FormModel();

  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  late Future<bool> isFriendRequestSent;

  ClientDetails? clientInfo;
  bool loading1 = false;
  bool loading2 = false;
  bool isCancelVisible = false;
  bool isSendVisible = true;

  Map<String, dynamic>? clientMap;

  Map<String, String?>? logedUserMap;

  var clientid;

  @override
  void initState() {
    isFriendRequestSent = checkFriendRequestStatus();
    super.initState();
  }

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

            FutureBuilder<bool>(
                future: isFriendRequestSent,
                builder: (context, snapshot){
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if(snapshot.hasData){

                    final isSent = snapshot.data!;
                    if(isSent){
                      return ElevatedButton(
                          onPressed: () {
                            cancelFriendRequest(widget.clientInfo.id)
                            .then((_){
                              setState(() {
                                isFriendRequestSent = checkFriendRequestStatus();
                              });
                            });
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
                          child: const Text('Cancel Request'));
                    }else{
                      return ElevatedButton(
                          onPressed: () {
                            sendFriendRequest(widget.clientInfo.id)
                                .then((_){
                              setState(() {
                                isFriendRequestSent = checkFriendRequestStatus();
                              });
                            });
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
                          child: const Text('Send Request'));

                    }
                  }
                  return const Text('Error retrieving friend request status');

                }),

          ],
        ),
      ),
    );
  }

  Future<bool> checkFriendRequestStatus() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUserId)
          .get();

      final friendRequestData = snapshot.data()!['FriendsRequestField'];
      final sentRequestIds = friendRequestData['sentRequests'].cast<String>();

      return sentRequestIds.contains(widget.clientInfo.id);
    }catch(error){
      print('Error retrieving friend request status: $error');
      return false;

    }
  }

  Future <void> sendFriendRequest(String receiverId) async {
    send();
   // Add the current user's ID to the receiver's friend request list
    FirebaseFirestore.instance.collection('Users').doc(receiverId).update({
      'FriendsRequestField.receivedRequests ': FieldValue.arrayUnion([currentUserId]),
    });

    // Update the current user's friend request list
    FirebaseFirestore.instance.collection('Users').doc(currentUserId).update({
      'FriendsRequestField.sentRequests': FieldValue.arrayUnion([receiverId]),
    });

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

  Future<void> sendRequest(String recipientId) async {
    String senderID = _firebaseAuth.currentUser!.uid;

    await requestRef
        .doc(senderID)
        .collection("FriendsRequest")
        .doc(clientid)
        .set({"status": "OutGoingPending", "senderID": senderID}) ;

    await requestRef
        .doc(recipientId)
        .collection("FriendsRequest")
        .doc(senderID)
        .set({"status": "IncomingPending", "senderID": senderID});
  }
   Future <void> cancelFriendRequest(String receiverId) async {
     cancelRequest();
    // Remove the current user's ID from the receiver's friend request list
     FirebaseFirestore.instance.collection('Users').doc(receiverId).update({
       'FriendsRequestField.receivedRequests': FieldValue.arrayRemove([currentUserId]),
     });

     // Remove the receiver ID from the current user list
     FirebaseFirestore.instance.collection('Users').doc(currentUserId).update({
       'FriendsRequestField.sentRequests': FieldValue.arrayRemove([receiverId]),
     });
   }

  Future<void> cancelRequest() async {
    clientid = widget.clientInfo["userID"];

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        "friend request has been cancelled",
        style: TextStyle(color: Colors.white),
      ),
    ));
    cancel(clientid!);

  }

  Future<void> cancel(String recipientId) async {
    String senderID = _firebaseAuth.currentUser!.uid;
    await requestRef
        .doc(senderID)
        .collection("FriendsRequest")
        .doc(clientid).delete();

    await requestRef
        .doc(recipientId)
        .collection("FriendsRequest")
        .doc(senderID).delete();



  }


}
