import 'package:clip/FriendsManager/friend_client_page.dart';
import 'package:clip/FriendsManager/friends_list_provider.dart';
import 'package:clip/Models/friends_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FriendsList extends StatefulWidget {
  const FriendsList({Key? key}) : super(key: key);

  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  final int _limit = 10;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String currentUsrId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: Provider.of<FriendListProvider>(context).getStreamFireStore(
          _limit
        ),
         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
           if (snapshot.connectionState == ConnectionState.waiting) {
             return Center(
               child: CircularProgressIndicator(
                 color: Colors.green,
               ),
             );
           }else if(snapshot.hasError){
             print('Error fetching Friends: ${snapshot.error}');
             return Center(
               child: Text('Error fetching Friends'),
             );
           }else if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
             return Center(
               child: Text('No users'),
             );

           }else{
             return GridView.builder(
                 itemCount: snapshot.data?.docs.length ,
                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                   crossAxisCount: 2,
                   childAspectRatio: MediaQuery.of(context).size.width /
                       (MediaQuery.of(context).size.height/1.5),
                 ),
                     itemBuilder: (context, index) => buildFriendList(
                           context, snapshot.data?.docs[index],
                           Provider.of<FriendListProvider>(context)));
                    }

         } ,


      ) ,);
  }

  buildFriendList(BuildContext context, QueryDocumentSnapshot<Object?>? doc,
      FriendListProvider friendListProvider) {

    if (doc != null) {
      FriendsModel friendsModel = FriendsModel.fromDocument(doc);

      if (friendsModel.id == currentUsrId) {
        return SizedBox.shrink();
      } else {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w,),
          child: InkWell(onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => FriendsClientProfile(
              arguments: FriendsScreenArgs(
                  peerId: friendsModel.id,
                  peerName: friendsModel.name,
                  peerAvatar: friendsModel.photoUrl,
                  peerLocation: friendsModel.location,
                  peerUserName: friendsModel.username


              ),
            )));
          },
            child: Container(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.5.w, vertical: 0.5.h),
                    child:
                    Stack(
                      children: <Widget>[
                        LayoutBuilder(
                          builder: (BuildContext context, BoxConstraints constraints) {
                            return Container(
                              height: constraints.maxHeight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                            image: NetworkImage(
                            friendsModel.photoUrl ?? ""),
                                fit: BoxFit.cover)
                            ),);
                          },

                        ),
                        SizedBox(width: 3.w,),
                        Positioned(
                          bottom: 0,
                          left: 2,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${friendsModel.name}", style: TextStyle(
                                    color: Colors.black87, fontSize: 18.sp, fontWeight: FontWeight.bold),),
                                SizedBox(height: 0.5.h,),
                                Text("${friendsModel.location}", style: TextStyle(
                                    color: Colors.black87, fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic),),

                              ],
                            ),
                          ),
                        )
                      ],
                    )
                ),),
            ),
          ),
        );
      }
    } else {
      return SizedBox.shrink();
    }

  }

}


