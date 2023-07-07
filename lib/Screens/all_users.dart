

import 'package:clip/Models/user_model.dart';
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
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {

    return FutureBuilder<List<QueryDocumentSnapshot>>(
        future: fetchNonFriendUsers(),
        builder: (context, userSnapshot) {

          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.green,));
          }
          if(userSnapshot.hasData){
            List<QueryDocumentSnapshot> filteredUsers = userSnapshot.data!
                .where((snapshot) => snapshot.id != currentUserId)
                .toList();
            return GridView.builder(
                itemCount: filteredUsers.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height/1.8),
                    crossAxisCount: calculateCrossAxisCount(filteredUsers.length),),
                itemBuilder: (context, index) {
                  var documentSnapshot = filteredUsers[index];

                  return InkWell(onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context){
                      return ClientProfile(clientInfo: documentSnapshot);
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
                                documentSnapshot["profilePic"]
                            ),
                          ),

                          SizedBox(height: 1.h,),

                          Text(documentSnapshot["username"],
                            style: TextStyle(color: Colors.black, fontSize: 17.sp),),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(documentSnapshot["Location"]),
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

            return Center(child: Text("no user found"));

        }
    );

  }

  Future<List<QueryDocumentSnapshot>> fetchNonFriendUsers() async {
    final currentUserFriendsSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserId)
        .collection('Friends')
        .get();
    /*final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("Users").get();
    final filteredUsers = querySnapshot.docs
        .where((doc) => doc['friends'] == false && doc.id != currentUser)
        .toList();*/
    print(".................................$currentUser");

    final currentUserFriends = currentUserFriendsSnapshot.docs.map((doc) => doc.id).toList();

    final allUsersSnapshot = await FirebaseFirestore.instance.collection('Users').get();

    final nonFriendUsers = allUsersSnapshot.docs.where((doc) => !currentUserFriends.contains(doc.id)).toList();

    return nonFriendUsers;
  }

 int calculateCrossAxisCount(int length) {
   if (length <= 2) {
     return length;
   } else {
     return 2;
   }
  }

}