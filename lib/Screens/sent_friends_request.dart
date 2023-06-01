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




  @override
  void initState() {
    getSentRequest();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
        child: Column(
          children: [
            SizedBox(height: 5.h,),
            Text("Sent Friends Request",
              style: TextStyle(color: Colors.black, fontSize: 18.sp, fontWeight: FontWeight.bold),),
            Expanded(
              child: Container(
                  child: listOfSenders == null ? Center(child: CircularProgressIndicator(color: Colors.green,)):
                  listOfSenders!.isEmpty ?
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.question_mark, color: Colors.grey, size: 40.sp,),
                        const Text(
                          "No Sent Request Yet",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        )
                      ],
                    ),
                  )
                      :ListView.builder(
                      itemCount: listOfSenders!.length,
                      itemBuilder: (context, index){
                        var document = listOfSenders![index]["id"];
                        print("printing document ids asssssssssss$document");
                        return  Container(
                          height: 12.h,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            elevation: 10,
                            child: Container(
                              decoration: BoxDecoration(),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 1.h,),

                                    Row(mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          " Name:",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 4.w,),
                                        Text(
                                          "${listOfSenders![index][ "name"]}",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 1.h,),
                                    Row(mainAxisAlignment: MainAxisAlignment.end,
                                      children: [

                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.green
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
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),
                        );

                      })
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void>  getSentRequest() async {
    String loggedInUserId = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference friendRequestsRef = FirebaseFirestore.instance
        .collection("Users")
        .doc(loggedInUserId)
        .collection("FriendsRequest");
    QuerySnapshot friendRequestsSnapshot = await friendRequestsRef.get();

    List<Map<String, dynamic>> senderDetailsList = [];

    for(QueryDocumentSnapshot friendRequestDoc in friendRequestsSnapshot.docs ){
      String senderId = friendRequestDoc.id;

      DocumentSnapshot senderSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(senderId)
          .get();

      String senderName = senderSnapshot['name'];
      Map<String, dynamic> senderDetails = {
        'id': senderId,
        'name': senderName,

      };
      senderDetailsList.add(senderDetails);

    }
      setState(() {
        listOfSenders = senderDetailsList;
      });

    }
  }


