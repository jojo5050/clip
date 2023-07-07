import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'package:clip/AuthMangers/auth_service.dart';
import 'package:clip/ChatManager/chart_screen.dart';
import 'package:clip/ChatManager/chat_list_provider.dart';
import 'package:clip/ChatManager/chat_user_error.dart';
import 'package:clip/ChatManager/user_chat_model.dart';
import 'package:clip/Models/firestore_constants.dart';
import 'package:clip/Screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../Utils/debouncer.dart';
import '../Utils/progress_bar.dart';




class ChatUserList extends StatefulWidget {
  const ChatUserList({Key? key}) : super(key: key);


  @override
  _ChatUserListState createState() => _ChatUserListState();
}

class _ChatUserListState extends State<ChatUserList> {

  User? currentUser = FirebaseAuth.instance.currentUser;
  late final ChatListProvider chatListProvider = context.read<ChatListProvider>();

  List<QueryDocumentSnapshot<Object?>>? usersMap;
  final Debouncer searchDebouncer = Debouncer(milliseconds: 300);
  final StreamController<bool> btnClearController = StreamController<bool>();

  final int _limit = 20;

   String _textSearch = "";

  bool isLoading = false;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
   String currentUsrId = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController searchBarTec = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: SafeArea(child: Stack(children: [
       Column(children: [
         SizedBox(height: 2.h,),
        builSearchBar(),

         Expanded(
             child: StreamBuilder<QuerySnapshot>(
               stream: Provider.of<ChatListProvider>(context).getStreamFireStore(
                 _limit, _textSearch,
               ),
               builder: (BuildContext context,
                   AsyncSnapshot<QuerySnapshot> snapshot) {
                 if (snapshot.connectionState == ConnectionState.waiting) {
                   return Center(
                     child: CircularProgressIndicator(
                       color: Colors.green,
                     ),
                   );
                 }else if(snapshot.hasError){
                   print('Error fetching users: ${snapshot.error}');
                   return Center(
                     child: Text('Error fetching users'),
                   );
                 }else if(!snapshot.hasData || snapshot.data!.docs.isEmpty){
                   return Center(
                     child: Text('No users'),
                   );

                 }else{
                 return ListView.builder(
                         itemCount: snapshot.data?.docs.length,
                         itemBuilder: (context, index) => buildItem(
                             context, snapshot.data?.docs[index],
                             Provider.of<ChatListProvider>(context)));
                 }
               },
             ))
       ],),

       Positioned(child: isLoading ? ProgressBar() : SizedBox.shrink(),)

     ],),)
    );
  }

  Widget buildItem(BuildContext context, QueryDocumentSnapshot<Object?>? doc,
      ChatListProvider chatListProvider) {
    if (doc != null) {
      UserChatModel userChatModel = UserChatModel.fromDocument(doc);

      if (userChatModel.id == currentUsrId) {
        return SizedBox.shrink();
      } else {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w,),
          child: InkWell(onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(
              arguments: ChatScreenArgs(
                  peerId: userChatModel.id,
                  peerName: userChatModel.name,
                  peerAvatar: userChatModel.photoUrl,
                  peerLocation: userChatModel.location

              ),

            )));
          },
            child: Container(
              height: 10.h,
              child: Card(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                    child:
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(
                              userChatModel.photoUrl ?? ""),),
                        SizedBox(width: 3.w,),
                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${userChatModel.name}", style: TextStyle(
                                color: Colors.black87, fontSize: 18.sp, fontWeight: FontWeight.bold),),
                            SizedBox(height: 0.5.h,),
                            Text("${userChatModel.location}", style: TextStyle(
                                color: Colors.black87, fontSize: 18.sp, fontStyle: FontStyle.italic),),

                          ],
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

  Widget builSearchBar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.search, color: Colors.grey, size: 20),
          SizedBox(width: 5),
          Expanded(
            child: TextFormField(
              textInputAction: TextInputAction.search,
              controller: searchBarTec,
              onChanged: (value) {
                searchDebouncer.run(() {
                  if (value.isNotEmpty) {
                    btnClearController.add(true);
                    setState(() {
                      _textSearch = value;
                    });
                  } else {
                    btnClearController.add(false);
                    setState(() {
                      _textSearch = "";
                    });
                  }
                });
              },
              decoration: const InputDecoration.collapsed(
                hintText: 'Search name, Type exact keyword',
                hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
              ),
              style: TextStyle(fontSize: 15),
            ),
          ),
          StreamBuilder<bool>(
              stream: btnClearController.stream,
              builder: (context, snapshot) {
                return snapshot.data == true
                    ? GestureDetector(
                    onTap: () {
                      searchBarTec.clear();
                      btnClearController.add(false);
                      setState(() {
                        _textSearch = "";
                      });
                    },
                    child: Icon(Icons.clear_rounded, color: Colors.grey, size: 20))
                    : SizedBox.shrink();
              }),
        ],
      ),
    );
  }

}

class ChatPageArgument {
  final String peerId;
  final String peerName;
  final String peerAvatar;

  ChatPageArgument({required this.peerId, required this.peerName, required this.peerAvatar});

}
