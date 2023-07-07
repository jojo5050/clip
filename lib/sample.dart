import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class IncomingRequest extends StatefulWidget {
  const IncomingRequest({Key? key}) : super(key: key);

  @override
  State<IncomingRequest> createState() => _IncomingRequestState();
}

class _IncomingRequestState extends State<IncomingRequest> {
  List<Map<String, dynamic>>? listOfSenders;

  String currendUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    getIncomingRequest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text(
        "Incoming Friends Request",
        style: TextStyle(

            fontSize: 18.sp,
            fontWeight: FontWeight.bold),
      ),),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 4.h),
          child: FutureBuilder<List<Map<String, dynamic>>>(
              future: getIncomingRequest(),
              builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  );
                }else if(snapshot.hasData && snapshot.data!.isEmpty){

                  return Center(
                    child: Column(
                      children: [
                        SizedBox(height: 25.h,),
                        Icon(
                          Icons.question_mark,
                          color: Colors.grey,
                          size: 40.sp,
                        ),
                        const Text(
                          "No Incoming Request",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  );
                }else if(snapshot.hasData){
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 17.h,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10)),
                            elevation: 10,
                            child: Container(
                              decoration: BoxDecoration(),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.w, vertical: 1.h),
                                child: Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor:
                                      Colors.transparent,
                                      backgroundImage: NetworkImage(
                                        snapshot.data![index]["profilePic"],),
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "${snapshot.data![index]["name"]}",
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 18.sp,
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 1.w,
                                            ),
                                            Text(
                                              ",",
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 18.sp,
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                            SizedBox(
                                              width: 3.w,
                                            ),
                                            Text(
                                              "${snapshot.data![index]["Sex"]}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18.sp,
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        Text(
                                          "${snapshot.data![index]["Location"]}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.sp,
                                              fontWeight:
                                              FontWeight.bold,
                                              fontStyle:
                                              FontStyle.italic),
                                        ),
                                        SizedBox(
                                          height: 1.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                String sendersID =   snapshot.data![index]["id"];
                                                String friendRequestId = snapshot.data![index]["id"];
                                                accepRequest(friendRequestId, sendersID, currendUserId);

                                                Navigator.pushNamed(context, '/allUsers');
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        20),
                                                    color:
                                                    Colors.green),
                                                child: Padding(
                                                  padding: EdgeInsets
                                                      .symmetric(
                                                      horizontal:
                                                      2.w,
                                                      vertical:
                                                      1.h),
                                                  child: Text(
                                                    "ACCEPT REQUEST",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .white,
                                                        fontSize: 17.sp,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 9.w,
                                            ),
                                            IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ))
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 1.h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });

                }else {
                  return const Center(
                    child: Text("Failed to fetch requests"),
                  );

                }

              }

          )
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getIncomingRequest() async {
    String loggedInUserId = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference friendRequestsRef = FirebaseFirestore.instance
        .collection("Users")
        .doc(loggedInUserId)
        .collection("FriendsRequest");

    Query query =
    friendRequestsRef.where('status', isEqualTo: 'IncomingPending');

    QuerySnapshot friendRequestsSnapshot = await query.get();

    List<Map<String, dynamic>> senderDetailsList = [];

    for (QueryDocumentSnapshot friendRequestDoc
    in friendRequestsSnapshot.docs) {
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
    return senderDetailsList;
  }

  Future<void> accepRequest(String friendRequestId, String sendersID, String currendUserId) async {
    // Add the sender to the current user's friend list
    FirebaseFirestore.instance
        .collection('Users')
        .doc(currendUserId)
        .collection('Friends')
        .doc(sendersID)
        .set({});

    // Add the receiver to the senders user's friend list
    FirebaseFirestore.instance
        .collection("Users")
        .doc(sendersID)
        .collection("Friends")
        .doc(currendUserId)
        .set({});

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

    List<String> friendIds = [];

    DocumentReference currentUserRef = FirebaseFirestore
        .instance.collection("Users").doc(currendUserId);
    CollectionReference friendsRef = currentUserRef.collection("Friends");
    QuerySnapshot friendSnapshot = await friendsRef.get();

    friendSnapshot.docs.forEach((friendDoc) {
      String friendId = friendDoc.id;
      friendIds.add(friendId);
    });

    await updateFriendsList(currendUserId, friendIds );

  }

  Future<void> updateFriendsList(String userId, List<String> friendIds) async {
    final friendsListRef = FirebaseFirestore.instance.collection('FriendsList');

    // Create or update the document for the user's friends list
    await friendsListRef.doc(userId).set({'friends': friendIds});
  }
}
