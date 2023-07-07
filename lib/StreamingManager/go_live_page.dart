import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../Utils/progress_bar.dart';
import 'broadcast_page.dart';

class GoLivePage extends StatefulWidget {
  const GoLivePage({Key? key}) : super(key: key);

  @override
  State<GoLivePage> createState() => _GoLivePageState();
}


class _GoLivePageState extends State<GoLivePage> {

  bool loading = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  var userName;
  var userProfilePic;

  @override
  void initState() {
    getLogedUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willPopControll,
      child: Scaffold(backgroundColor: Colors.transparent,
        appBar: (AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: EdgeInsets.only(right: 20, left: 20, top: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(onPressed: (){
                  Navigator.of(context).pop();
                }, icon: Icon(Icons.clear)),
                //  Container(child: Image.asset("assets/images/camera.png")),
              ],
            ),
          ),
        )),
        body: Column(
          children: [
            loading ? ProgressBar()
                : Expanded(
              child: Align(alignment: FractionalOffset.bottomCenter,
                child: ElevatedButton(
                  onPressed: () => onStartStream(isBroadcaster: true),
                  child: Text("Start Stream"),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 2.h),
                      textStyle: TextStyle(
                          fontSize: 19.sp, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            SizedBox(height: 2.h,),
          ],
        ),
      ),
    );
  }

  Future<void> onStartStream({required bool isBroadcaster}) async {

    await [Permission.camera, Permission.microphone].request();

    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => BroadCastPage(
            userId: _firebaseAuth.currentUser!.uid,
            userName: userName,
            userImage: userProfilePic,
            isBroadcaster: isBroadcaster
        )));

  }

  Future<void> getLogedUser() async {
    String userID = _firebaseAuth.currentUser!.uid;
    DocumentSnapshot snapshot = await firebaseFirestore.collection('Users').doc(userID).get();
    if (snapshot.exists) {
      Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;
      if (userData != null) {
        userName = userData['username'];
        userProfilePic = userData['profilePic'];

        print("username assssssss...............$userName");
        print("userpic assssssss...............$userProfilePic");

      }
    }
  }

  Future<bool> willPopControll() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        //  title: new Text('Are you sure?'),
        content: new Text('Do you want to exit the App'),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () => exitApp(),
                child: new Text('Yes'),
              ),
            ],
          ),
        ],
      ),
    )) ??
        false;
  }

  exitApp() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    });
  }
}