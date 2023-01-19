import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({Key? key}) : super(key: key);

  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
         body: Padding(
           padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
           child: Container(
             child: StreamBuilder<QuerySnapshot>(
               stream: FirebaseFirestore.instance.collection("Users").snapshots(),
               builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> usersSnapshot) {
                dynamic usersMap = usersSnapshot.data!.docs;
                print(usersMap);

                if(usersSnapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator(color: Colors.black,
                  ));
                }
                else {
                  return GridView.builder(
                      itemCount: usersSnapshot.data?.docs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height/1.7),
                          crossAxisCount: 2),
                      itemBuilder: (context, index) {
                         return Card(
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
                                     usersMap[index]["profilePic"]
                                 ),
                               ),

                               SizedBox(height: 1.h,),

                               Text(usersMap[index]["name"],
                                 style: TextStyle(color: Colors.black, fontSize: 17.sp),),

                               SizedBox(height: 1.h,),

                               Text(usersMap[index]["username"],
                                 style: TextStyle(color: Colors.black, fontSize: 17.sp),)

                             ],),
                           ),


                         );
                      });

                }

               }
             ),
           ),
         ),
    );
  }
}