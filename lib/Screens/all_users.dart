

import 'package:clip/Screens/client_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({Key? key}) : super(key: key);

  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  List<QueryDocumentSnapshot<Object?>>? usersMap;
  User? currentUser = FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {

    if(usersMap != null){

      return Container();

    }

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Users").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> usersSnapshot) {
          usersMap = usersSnapshot.data?.docs;

          if(usersSnapshot.hasData){

            return GridView.builder(
                itemCount: usersSnapshot.data?.docs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height/1.8),
                    crossAxisCount: 2),
                        itemBuilder: (context, index) {
                            var documentId  =  usersSnapshot.data?.docs[index];
                  if(documentId?.id == currentUser?.uid) {
                    return Container(height: 0,);
                  }
                  return InkWell(onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context){
                      return ClientProfile(clientInfo: usersMap![index]);
                    }));
                  },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.grey,

                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                        child: Column(children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                                usersMap![index]["profilePic"]
                            ),
                          ),

                          SizedBox(height: 1.h,),

                          Text(usersMap![index]["username"],
                            style: TextStyle(color: Colors.black, fontSize: 17.sp),),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Text(usersMap![index]["Location"]),
                            SizedBox(width: 0.5.w,),
                            Text(","),
                            SizedBox(width: 2.w,),
                            const Text("25", style: TextStyle(color: Colors.black),)
                          ],),
                          SizedBox(height: 0.5.h,),

                          Text("Sex",
                            style: TextStyle(color: Colors.black, fontSize: 17.sp),),

                        ],),
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

        }
    );

  }
}