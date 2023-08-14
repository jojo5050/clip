
import 'package:clip/AuthMangers/auth_service.dart';
import 'package:clip/Models/user_model.dart';
import 'package:clip/Screens/login_screen.dart';
import 'package:clip/Utils/full_image_viewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:video_player/video_player.dart';

import '../Utils/video_player_page.dart';




class LogedUserProfile extends StatefulWidget {
  final String documentID;

  const LogedUserProfile({Key? key, required this.documentID})
      : super(key: key);

  @override
  _LogedUserProfileState createState() => _LogedUserProfileState();
}

class _LogedUserProfileState extends State<LogedUserProfile> {
  CollectionReference usersRef = FirebaseFirestore.instance.collection("Users");
  CollectionReference imageRef = FirebaseFirestore.instance.collection("user_images");
  User? currentuser = FirebaseAuth.instance.currentUser;
  final firebaseStorage = FirebaseStorage.instance;
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  VideoPlayerController? _videoController;


  dynamic imageFile;
  Future<String>? profilePicUrl;

  String? imageData;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
              child: FutureBuilder<DocumentSnapshot>(
            future: usersRef.doc(currentuser?.uid).get(),
            builder:
                (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              dynamic data = snapshot.data?.data();
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(color: Colors.transparent,));
              }
              if (snapshot.connectionState == ConnectionState.done) {
                if(!snapshot.hasData){
                  return Container(child: Center(child: Text("User Not Found")),);

                }
                return Padding(
                  padding: EdgeInsets.only(left: 3.w, top: 4.h, right: 3.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Container(
                         child: Row(mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: NetworkImage(data["profilePic"]),
                                ),SizedBox(width: 2.w,),
                             Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: <Widget>[
                               Text(
                                 "${data["name"]}",
                                 style: TextStyle(color: Colors.black,
                                   fontWeight: FontWeight.bold, fontSize: 17.sp, ),
                               ),
                               SizedBox(
                                 height: 1.h,
                               ),
                               Text("${data['Location'] ?? ""} ",  style: TextStyle(
                                   color: Colors.black, fontSize: 15.sp, fontStyle: FontStyle.italic),),


                             ],)
                           ],
                         ),
                       ),

                      Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(15)),
                            child: PopupMenuButton(
                                color: Colors.black,
                                elevation: 20,
                                shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                onSelected: (val){
                                  switch (val){
                                    case 1: Navigator.pushNamed(context, '/incoming_request');
                                    break;
                                    case 2:  Navigator.pushNamed(context, '/sent_friend_request');
                                    break;
                                    case 4:  signOut();
                                    break;
                                  }

                                },
                                itemBuilder: (context) => [
                                      PopupMenuItem(
                                    value: 1,
                                    child: Container(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.mobile_friendly,
                                              color: Colors.green,
                                              size: 20.sp,
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              "Friends Request",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                    ),
                                  ),
                                      PopupMenuItem(
                                    value: 2,
                                    child: Container(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.send_to_mobile,
                                              color: Colors.green,
                                              size: 20.sp,
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              "Sent Request",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                    ),
                                  ),
                                      PopupMenuItem(
                                        value: 3,
                                        child: Container(
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.group,
                                                  color: Colors.green,
                                                  size: 20.sp,
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  "My Friends",
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 16.sp,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                        ),
                                      ),
                                     PopupMenuItem(
                                    value: 4,
                                    child: Container(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.logout,
                                              color: Colors.red,
                                              size: 20.sp,
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              "LogOut",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                    ),
                                  ),
                                    ]),
                          ),

                    ],
                  ),
                );

              }

              return Container(
                child: Text(
                  "No Data",
                  style: TextStyle(color: Colors.green),
                ),);
              },
            )

          ),
          SizedBox(height: 2.h,),
          Divider(
            thickness: 2, color: Colors.black,
          ),
          Expanded(
            child: FutureBuilder<List<UserMedia>>(
              future: getImagesForUser(currentUserId),
              builder: (BuildContext context,  snapshot) {
                print("FutureBuilder triggered");
                   List<UserMedia>? test  = snapshot.data;
                   print("..........>>>>>>>>>>>>>>> $test");

                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Container(
                    child: const Text(
                      "Error fetching images",
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Column(
                      children: [
                        SizedBox(height: 20.h,),
                        Text("No Media files yet", style: TextStyle(color: Colors.black),),
                        Text("Your images will display here", style: TextStyle(color: Colors.black)),
                        Text("When you upload", style: TextStyle(color: Colors.black)),
                        Icon(Icons.image, color: Colors.grey, size: 100,)
                      ],
                    );
                }

                List<UserMedia> mediaFiles = snapshot.data!;
                return buildMediaListView(mediaFiles);
              },
            ),
          ),
        ],
      ),
    );
  }

  void signOut() {
    usersRef.doc(_firebaseAuth.currentUser!.uid).update({
      "status": "Offline"
    });

    _firebaseAuth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (route) => false);
  }

  Future<void> acceptRequest(String clientString) async {

    String recipientUid = FirebaseAuth.instance.currentUser!.uid;
    // Update friend request status in sender's subcollection
    await FirebaseFirestore.instance.collection("Users").
        doc(clientString)
        .collection("FriendsRequest")
        .doc(recipientUid)
        .update({"status": "Accepted"});

    await FirebaseFirestore.instance.collection("Users").
    doc(recipientUid)
        .collection("FriendsRequest")
        .doc(clientString)
        .update({"status": "Accepted"});

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(clientString)
        .collection('friends')
        .doc(recipientUid)
        .set({});

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(recipientUid)
        .collection('friends')
        .doc(clientString)
        .set({});
  }

  Future<List<QueryDocumentSnapshot>> fetchNonFriendUsers() async {
    final currentUserFriendsSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserId)
        .collection('Friends')
        .get();
    final currentUserFriends = currentUserFriendsSnapshot.docs.map((doc) => doc.id).toList();

    final allUsersSnapshot = await FirebaseFirestore.instance.collection('Users').get();

    final nonFriendUsers = allUsersSnapshot.docs.where((doc) => !currentUserFriends.contains(doc.id)).toList();

    return nonFriendUsers;
  }

  Future<List<UserMedia>> getImagesForUser(String userId) async {
    try {
      // Fetch the documents from Firestore that match the userId
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('user_media')
          .where('userId', isEqualTo: userId)
          .get();


      List<UserMedia> mediaList = [];
      querySnapshot.docs.forEach((doc) {
        final data = doc.data() as Map<String, dynamic>;

        if (data.containsKey('imageUrls')) {
          List<dynamic> imageUrls = doc['imageUrls'];

          imageUrls.forEach((url) {
            mediaList.add(UserMedia(url: url, type: MediaType.image));
          });
        }


        if(data.containsKey('mediaType')){
          String mediaType = data['mediaType'];

          if (mediaType == MediaType.video.toString()) {
            String videoUrl = doc['videoUrl'];
            if (videoUrl.isNotEmpty) {
              mediaList.add(UserMedia(url: videoUrl, type: MediaType.video));
            }
          }
        }
      });

      return mediaList;

    } catch (e) {
      print('Error getting images for user from Firestore: $e');
      return []; // Return an empty list if there's an error
    }
  }

  Widget buildMediaListView(List<UserMedia> mediaList) {
    return GridView.builder(
      itemCount: mediaList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 1.5),
      ),
      itemBuilder: (context, index) {
        UserMedia media = mediaList[index];
        print("..................... $media");
        return GestureDetector(
          onTap: () {
            if (media.type == MediaType.video) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChewieVideoPlayer(
                    videoUrl: media.url,
                  ),
                ),
              );

            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageSliderPage(
                    imageUrls: mediaList,
                    initialIndex: index,
                  ),
                ),
              );
            }
          },
          child: Container(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.5.w, vertical: 0.5.h),
                child: media.type == MediaType.video
                    ? AspectRatio(
                  aspectRatio: MediaQuery.of(context).size.width /
                      MediaQuery.of(context).size.height,
                  child: Stack(
                    children: [
                      ChewieVideoPlayer(
                            videoUrl: media.url,
                      ),
                      Positioned(top: 10, left: 10,
                          child: Icon(Icons.play_circle_fill_sharp, color: Colors.black,))

                    ],
                  ),
                )
                    : Stack(
                      children: <Widget> [
                        LayoutBuilder(
                          builder: (BuildContext context, BoxConstraints constraints) {
                            return Container(
                                height: constraints.maxHeight,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            media.url ?? ""),
                                        fit: BoxFit.cover)
                                ),);
                          }
                        ),
                        Positioned(top: 10, right: 10,
                            child: Icon(Icons.image, color: Colors.black,))
                      ],
                    ),
              ),
            ),
          ),
        );
      },
    );

  }

}


