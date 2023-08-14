import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../Utils/progress_bar.dart';
// import 'broadcast_page.dart';

class GoLivePage extends StatefulWidget {
  const GoLivePage({Key? key}) : super(key: key);

  @override
  State<GoLivePage> createState() => _GoLivePageState();
}


class _GoLivePageState extends State<GoLivePage> {

  bool loading = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;


  var userName;
  var userProfilePic;

  ImagePicker imgPicker = ImagePicker();

  List<XFile>? imageFileList = [];
  List<List<XFile>> imageGroups = [];

  XFile? _video;

  VideoPlayerController? _videoController;

  @override
  void initState() {
    getLogedUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willPopControll,
      child: Scaffold(backgroundColor: Colors.transparent,
        appBar: (AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 3.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(onPressed: (){
                  Navigator.of(context).pop();
                }, icon: Icon(Icons.clear, color: Colors.white,)),

                Container(
                  width: 20.w,
                  child: imageFileList!.isNotEmpty
                      ? loading
                      ? ProgressBar()
                      : TextButton(
                      onPressed: () {
                        setState(() {
                          loading = true;
                        });
                        handleImageUpload();
                        // uploadImageFile(imageFileList!);
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            color: Colors.green, fontSize: 17.sp),
                      ))
                      : Container(height: 0, width: 0),
                ),

                Container(
                  width: 20.w,
                  child: _video != null
                      ? loading
                      ? ProgressBar()
                      : TextButton(
                      onPressed: () {
                        setState(() {
                          loading = true;
                        });

                        uploadVideoFile(_video);
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold),
                      ))
                      : Container(height: 0, width: 0),
                ),


                //  Container(child: Image.asset("assets/images/camera.png")),
              ],
            ),
          ),
        )),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: ElevatedButton(
                        onPressed: () {
                          getImage();
                        },
                        child: Text(
                          "Share Image",
                          style: TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 1.h),
                            textStyle: TextStyle(
                                fontSize: 19.sp, fontWeight: FontWeight.bold))),
                  ),
                  Container(
                    child: ElevatedButton(
                        onPressed: () {
                          getVideo();
                        },
                        child: Text(
                          "Share Video",
                          style: TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 1.h),
                            textStyle: TextStyle(
                                fontSize: 19.sp, fontWeight: FontWeight.bold))),
                  ),
                ],
              ),
            ),
            Center(
              child: Text(
                "You can upload multiple images at a time",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp),
              ),
            ),
            SizedBox(height:  2.h,),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: GridView.builder(
                    itemCount: imageFileList?.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height * 0.6),
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Stack(
                        children: [
                          Card(
                              child: Image.file(File(imageFileList![index].path),
                                  fit: BoxFit.cover)),
                          Positioned(
                            top: -3,
                            right: 16,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  imageFileList!.removeAt(index);
                                });
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          )
                        ],
                      );
                    }),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _videoController!.value.isPlaying
                      ? _videoController?.pause()
                      : _videoController?.play();
                });
              },
              child: Container(
                height: 15.h,
                width: 60.w,
                child: _videoController != null
                    ? Stack(
                    children: [ AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    ),
                      Positioned(
                        top: -2,
                        right: 12,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _videoController = null;
                              _video = null;
                            });
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      )
                    ]
                )
                    : Container(),
              ),
            ),
            loading ? ProgressBar()
                : Expanded(
              child: Align(alignment: FractionalOffset.bottomCenter,
                child: ElevatedButton(
                  onPressed: () => onStartStream(isBroadcaster: true),
                  child: Text("Start Live Stream"),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 2.h),
                      textStyle: TextStyle(
                          fontSize: 19.sp, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            SizedBox(height: 2.h,),
          ],
        ),
      ),
    );
  }

  Future<void> onStartStream({required bool isBroadcaster}) async {

    await [Permission.camera, Permission.microphone].request();

  /*  Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => BroadCastPage(
            userId: _firebaseAuth.currentUser!.uid,
            userName: userName,
            userImage: userProfilePic,
            isBroadcaster: isBroadcaster
        )));*/

  }

  Future<void> getLogedUser() async {
    String userID = _firebaseAuth.currentUser!.uid;
    DocumentSnapshot snapshot = await firebaseFirestore.collection('Users').doc(userID).get();
    if (snapshot.exists) {
      Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;
      if (userData != null) {
        userName = userData['username'];
        userProfilePic = userData['profilePic'];

        print("username assssssss...............$userName");
        print("userpic assssssss...............$userProfilePic");

      }
    }
  }

  Future<bool> willPopControll() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        //  title: new Text('Are you sure?'),
        content: new Text('Do you want to exit the App'),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () => exitApp(),
                child: new Text('Yes'),
              ),
            ],
          ),
        ],
      ),
    )) ??
        false;
  }

  exitApp() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    });
  }

  void getImage() async {
    List<XFile>? pickedImages = await imgPicker.pickMultiImage();

    if (pickedImages.isNotEmpty) {
      setState(() {
        imageFileList!.addAll(pickedImages);
      });
    }
  }

  void getVideo() async {
    try {
      XFile? pickedVideos =
      await ImagePicker().pickVideo(source: ImageSource.gallery);
      _video = pickedVideos;
      _videoController = VideoPlayerController.file(File(_video!.path))
        ..initialize().then((_) {
          _videoController?.value.isInitialized;
          //  _videoController?.play();
          setState(() {});
          // _videoController?.play();
        });
      if (pickedVideos != null) {}
    } catch (e) {}
    return null;
  }

  Future<void> uploadVideoFile(XFile? video) async {
    if(_video != null){
      String? currentUserID = _firebaseAuth.currentUser?.uid;

      String videoFileName = video!.path.split('/').last;
      firebase_storage.Reference ref =
      firebase_storage.FirebaseStorage.instance.ref().child("$currentUserID/$videoFileName");

      final File file = File(video.path);
      await ref.putFile(file);
      String downloadUrl = await ref.getDownloadURL();

      try {
        await FirebaseFirestore.instance.collection('user_media').add({
          'videoUrl': downloadUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });

      } catch (e) {
        print('Error storing video URLs in Firestore: $e');
      }
      showSuccess();
      setState(() {
        loading = false;
      });


    }
  }

  Future<void> uploadImageFile(List<XFile> imageList) async {
    String? currentUserID = _firebaseAuth.currentUser?.uid;
    List<String> imageUrls = [];

    for (var imageFile in imageList) {
      String imageFileName = imageFile.path.split('/').last;
      firebase_storage.Reference ref =
      firebase_storage.FirebaseStorage.instance.ref().child("$currentUserID/$imageFileName");
      final File file = File(imageFile.path);
      await ref.putFile(file);
      String downloadUrl = await ref.getDownloadURL();
      imageUrls.add(downloadUrl);

    }

    try {
      await FirebaseFirestore.instance.collection('user_media').add({
        'imageUrls': imageUrls,
        'timestamp': FieldValue.serverTimestamp(),
      });

    } catch (e) {
      print('Error storing image URLs in Firestore: $e');
    }
    showSuccess();
    setState(() {
      loading = false;
    });

  }


  Future<void> handleImageUpload() async {
    if(imageFileList != null && imageFileList!.isNotEmpty){

      await uploadImageFile(imageFileList!);
      setState(() {
        imageFileList!.clear();
      });

    }

  }

  void showSuccess() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        duration: Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Text(
          "image uploades",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
    );
  }

  void showError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        duration: Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Text(
          "unable to upload",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
    );
  }
}