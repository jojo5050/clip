import 'dart:ffi';
import 'dart:io';
import 'package:clip/AuthMangers/auth_service.dart';
import 'package:clip/Screens/chart_screen.dart';
import 'package:clip/Screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';




class ChatUserList extends StatefulWidget {
  const ChatUserList({Key? key}) : super(key: key);


  @override
  _ChatUserListState createState() => _ChatUserListState();
}

class _ChatUserListState extends State<ChatUserList> {

  User? currentUser = FirebaseAuth.instance.currentUser;

  List<QueryDocumentSnapshot<Object?>>? usersMap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding:
          const EdgeInsets.only(right: 20, left: 20, top: 50, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const <Widget>[
              Icon(Icons.arrow_back, color: Colors.white,),

              Text("Users",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),

              Icon(Icons.more_vert, color: Colors.white,),
            ],
          ),
        ),
      ),

     body: _body(),
    );
  }

  Widget _body() {

    if(usersMap != null){
      return Container();
    }
    
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Users").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> usersSnapshot){
          usersMap = usersSnapshot.data?.docs;
          
          if(usersSnapshot.hasData){
            return ListView.builder(
                itemCount: usersSnapshot.data?.docs.length,
                itemBuilder: (context, index){
                  var documentId  =  usersSnapshot.data?.docs[index];
                  if(documentId?.id == currentUser?.uid){
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: InkWell(onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(
                        arguments: ChatScreenArgs(
                            peerAvatar:  usersMap![index]["profilePic"],
                            peerName: usersMap![index]["username"],
                            peerId: usersMap![index]["userID"]

                        )

                      ) ));

                    },
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                    usersMap![index]["profilePic"]
                                ),
                              ),
                              SizedBox(width: 2.w,),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(usersMap![index]["username"],),

                                  SizedBox(height: 0.5.h,),
                                  Text(usersMap![index]["Location"],),
                                ],
                              )

                            ],

                          ),
                        ),

                      ),
                    ),
                  );

                });
            
          }
          else {
            return Center(
              child: CircularProgressIndicator(color: Colors.green,),
            );

          }
          
        });

  }
}
