
import 'package:clip/AuthMangers/auth_service.dart';
import 'package:clip/Screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';



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


  dynamic imageFile;
  Future<String>? profilePicUrl;

  String? imageData;

  @override
  void initState() {
    super.initState();
  }

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
                            onSelected: (val){
                              switch (val){
                                case 1: Navigator.pushNamed(context, '/incoming_request');
                                break;
                                case 2:  Navigator.pushNamed(context, '/sent_friend_request');
                                break;
                                case 4:  signOut();
                                break;
                              }

                            },
                            itemBuilder: (context) => [
                                  PopupMenuItem(
                                value: 1,
                                child: Container(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.mobile_friendly,
                                          color: Colors.green,
                                          size: 20.sp,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          "Friends Request",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                ),
                              ),
                                  PopupMenuItem(
                                value: 2,
                                child: Container(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.send_to_mobile,
                                          color: Colors.green,
                                          size: 20.sp,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          "Sent Request",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                ),
                              ),
                                  PopupMenuItem(
                                    value: 3,
                                    child: Container(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.group,
                                              color: Colors.green,
                                              size: 20.sp,
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              "My Friends",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                    ),
                                  ),
                                 PopupMenuItem(
                                value: 4,
                                child: Container(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.logout,
                                          color: Colors.red,
                                          size: 20.sp,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          "LogOut",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
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

  Future<void> acceptRequest(String clientString) async {

    String recipientUid = FirebaseAuth.instance.currentUser!.uid;
    // Update friend request status in sender's subcollection
    await FirebaseFirestore.instance.collection("Users").
        doc(clientString)
        .collection("FriendsRequest")
        .doc(recipientUid)
        .update({"status": "Accepted"});

    await FirebaseFirestore.instance.collection("Users").
    doc(recipientUid)
        .collection("FriendsRequest")
        .doc(clientString)
        .update({"status": "Accepted"});

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(clientString)
        .collection('friends')
        .doc(recipientUid)
        .set({});

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(recipientUid)
        .collection('friends')
        .doc(clientString)
        .set({});
  }


}
