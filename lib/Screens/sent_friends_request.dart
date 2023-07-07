import 'package:clip/Utils/routers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SentFriendsRequest extends StatefulWidget {
  const SentFriendsRequest({Key? key}) : super(key: key);

  @override
  State<SentFriendsRequest> createState() => _SentFriendsRequestState();
}

class _SentFriendsRequestState extends State<SentFriendsRequest> {
  DocumentSnapshot<Object?>? senderSnapshot;

  List<Map<String, dynamic>>? listOfSenders;

  String currendUserId = FirebaseAuth.instance.currentUser!.uid;




  @override
  void initState() {
    getSentRequest();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title:  Text(
      "Sent Request",
      style: TextStyle(

          fontSize: 18.sp,
          fontWeight: FontWeight.bold),
    ),),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
              child: listOfSenders == null
                  ? const Center(
                child: CircularProgressIndicator(color: Colors.green),
              ):listOfSenders!.isEmpty ?
                   Center(
                      child: Column(
                        children: [
                          SizedBox(height: 25.h,),
                          Icon(
                            Icons.question_mark,
                            color: Colors.grey,
                            size: 40.sp,
                          ),
                          const Text(
                            "No Request sent",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ): ListView.builder(
                        itemCount: listOfSenders!.length,
                        itemBuilder: (context, index){
                          return  Container(
                            height: 15.h,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              elevation: 10,
                              child: Container(
                                decoration: BoxDecoration(),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: NetworkImage(listOfSenders![index]["profilePic"]),
                                      ),
                                      SizedBox(width: 4.w,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "${listOfSenders![index][ "name"]}",
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(width: 1.w,),
                                              Text(
                                                ",",
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              SizedBox(width: 3.w,),
                                              Text(
                                                "${listOfSenders![index][ "Sex"]}",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 1.h,),
                                          Text(
                                            "${listOfSenders![index][ "Location"]}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic),
                                          ),
                                          SizedBox(height: 1.h,),
                                          Row(mainAxisAlignment: MainAxisAlignment.start,
                                            children: [

                                              InkWell(onTap: (){
                                                print("this line was tapped...............");
                                                String sendersID =   listOfSenders![index]["id"];
                                                String friendRequestId = listOfSenders![index]["id"];
                                                cancelRequest(friendRequestId, sendersID, currendUserId);

                                              },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20),
                                                      color: Colors.red
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                                                    child: Text(
                                                      "CANCEL REQUEST",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 17.sp,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 1.h,),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );

                        })
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getSentRequest() async {
    String loggedInUserId = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference friendRequestsRef = FirebaseFirestore.instance
        .collection("Users")
        .doc(loggedInUserId)
        .collection("FriendsRequest");

    Query query = friendRequestsRef.where('status', isEqualTo: 'OutGoingPending');


     QuerySnapshot friendRequestsSnapshot = await query.get();

    List<Map<String, dynamic>> senderDetailsList = [];

    for(QueryDocumentSnapshot friendRequestDoc in friendRequestsSnapshot.docs ){
      String senderId = friendRequestDoc.id;

      DocumentSnapshot senderSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(senderId)
          .get();

      String senderName = senderSnapshot['name'];
      String senderPic = senderSnapshot['profilePic'];
      String senderLocation = senderSnapshot['Location'];
      String senderGender = senderSnapshot['Sex'];
      Map<String, dynamic> senderDetails = {
        'id': senderId,
        'name': senderName,
        'profilePic': senderPic,
        'Location': senderLocation,
        'Sex': senderGender

      };
      senderDetailsList.add(senderDetails);
    }
    setState(() {
      listOfSenders = senderDetailsList;
    });
    return senderDetailsList;
    }

  void cancelRequest(String friendRequestId, String sendersID, String currendUserId) {

    // remove the friend request from the current user's friend requests
    FirebaseFirestore.instance
        .collection('Users')
        .doc(currendUserId)
        .collection('FriendsRequest')
        .doc(friendRequestId)
        .delete();

    // remove the friend request from the senders friend requests
    FirebaseFirestore.instance
        .collection('Users')
        .doc(sendersID)
        .collection('FriendsRequest')
        .doc(currendUserId)
        .delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        "friend request was canceled",
        style: TextStyle(color: Colors.white),
      ),
    ));

    setState(() {
      listOfSenders!.removeWhere((sender) => sender['id'] == sendersID);
    });

  }
  }


