import 'package:clip/Models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../Models/form_model.dart';
import '../Models/global_variables.dart';
import '../StreamingManager/broadcast_page.dart';

class FriendsClientProfile extends StatefulWidget {
  const FriendsClientProfile({Key? key, required this.arguments}) : super(key: key);

  final FriendsScreenArgs arguments;

  @override
  State<FriendsClientProfile> createState() => _FriendsClientProfileState();
}

class _FriendsClientProfileState extends State<FriendsClientProfile> {
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
  String requestStatus = "OutGoingPending";

  var streamStatus;

  CollectionReference usersRef = FirebaseFirestore.instance.collection("Users");
  User? currentuser = FirebaseAuth.instance.currentUser;

  var currentUserName;

  var currentUserPic;

  @override
  void initState() {
    getCurrentUserDetails();
    getStreamStatus();
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
                 Row(children: [
                        InkWell(onTap: (){
                          Navigator.of(context).pop();
                        },
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                            size: 27,
                          ),
                        ),
                  SizedBox(width: 6.w,),
                   InkWell(onTap: () {
                     if(streamStatus == "Stopped" || streamStatus == null){
                       showError();
                       return;
                     }else if (streamStatus == "Started"){
                       onJoin(isBroadCaster: false);
                     }
                   },
                     child: Container(
                              child: streamStatus  == "Started"
                                  ? Stack(children: <Widget>[
                                Container(
                                    child: Image.asset(
                                      "assets/images/livestream.png",
                                      height: 40,
                                      width: 40,
                                    )),
                                const Positioned(
                                  bottom: 23,
                                  left: 24,
                                  child: CircleAvatar(
                                    radius: 8,
                                    backgroundColor: Colors.green,
                                  ),
                                )
                              ])
                                  : Container(
                                child: Image.asset(
                                  "assets/images/livestream.png",
                                  height: 40,
                                  width: 40,
                                ),
                              )
                     ),
                   ),
                      ],
                    ),
                Container(
                  height: 40,
                  width: 40,
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
                  backgroundImage: NetworkImage(widget.arguments.peerAvatar),
                )),
            SizedBox(
              height: 1.h,
            ),
            Text(widget.arguments.peerName),
            SizedBox(
              height: 1.h,
            ),
            Text(widget.arguments.peerUserName),
            SizedBox(
              height: 1.h,
            ),
            Text(widget.arguments.peerLocation),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }

 Future<void> getStreamStatus() async {
    print("here first ;;;;;;;;;;;;;;");
    final String userid = widget.arguments.peerId;
    try{
      final snapshot = await FirebaseFirestore.instance
          .collection('Streams')
          .doc(userid)
          .get();

      final statusData = snapshot.data()!['Status'];
      print("::::::::::::::::::::::::: as $statusData");
      setState(() {
        streamStatus = statusData;
      });

    }catch(e){
      print("this is the error $e");
    }

  }

  void showError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.black,
        duration: Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Text(
          "No Live Stream Available",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  Future<void> onJoin({required bool isBroadCaster}) async {
    await [Permission.camera, Permission.microphone].request();

      Navigator.of(context).push(MaterialPageRoute(
       builder: (context) => BroadCastPage(
      isBroadcaster: isBroadCaster,
       userName: currentUserName,
        userImage: currentUserPic,
        userId: currentUserId,
        clientName: widget.arguments.peerUserName
    //  userImage: client_pic!,
    )));
    print("printing client name for joining: ${widget.arguments.peerUserName}");

  }

 Future<void> getCurrentUserDetails() async {

   DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
       .collection('Users')
       .doc(currentUserId)
       .get();
   Map<String, dynamic> userData = snapshot.data()!;
   currentUserName = userData['username'];
   currentUserPic = userData['profilePic'];

   print("printing username asssssssssssssss $currentUserName");

  }
}

class FriendsScreenArgs {
  final String peerId;
  final String peerAvatar;
  final String peerName;
  final String peerLocation;
  final String peerUserName;

  FriendsScreenArgs({required this.peerId, required this.peerAvatar,
    required this.peerLocation, required this.peerName, required this.peerUserName, });
}
