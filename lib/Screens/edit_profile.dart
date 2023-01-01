
import 'dart:io';

import 'package:clip/Models/form_model.dart';
import 'package:clip/Screens/landingPage_manager.dart';
import 'package:clip/Utils/imagePickerManager.dart';
import 'package:clip/Utils/progress_bar.dart';
import 'package:clip/Utils/routers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_svg/svg.dart';
import '../Models/form_validators.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key,}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> with FormValidators {

  final FormModel formModel = FormModel();
 CollectionReference userCollection = FirebaseFirestore.instance.collection("Users");
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  ImagePickerManager imagePickerManager = ImagePickerManager();

  bool loading = false;

  String? uid;

  User? user;

  File? profilePic;

  Future<String>? imagePath;

  Future<String>? userImage;

  var imageSnapshot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Edit Profile",
        style: TextStyle(color: Colors.green, fontSize: 20.sp )),),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Form(
                    key: formModel.editFormKey,
            child: Column(children: [
              SizedBox(height: 10.h,),
              Center(
                child: Text("Welcome${_firebaseAuth.currentUser?.email} \n Fill in your details to create your profile",
                  style: TextStyle(color: Colors.green, fontSize: 17.sp),),
              ),
              SizedBox(height: 7.h,),

              InkWell(onTap: (){ _getImage(context);},
                child: Center(
                child: Stack(
                children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(70)),
                child: profilePic != null
                ? CircleAvatar(
                radius: 70,
                backgroundImage: FileImage(profilePic!),
                backgroundColor: Colors.transparent,
              )
                  : const CircleAvatar(
              radius: 70,
              backgroundColor: Colors.transparent,
              child: Center(child: Icon(Icons.person,
                color: Colors.white, size: 100,)),),
      ),
      const Positioned(
            bottom: 12,
            right: 1,
            child: CircleAvatar(
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                )))
      ],
    ),
    ),
              ),
              SizedBox(height: 3.h,),
              TextFormField(
                textAlignVertical: TextAlignVertical.center,
                cursorColor: Colors.white,
                style: TextStyle(
                    color: Colors.white, fontSize: 18.sp),
                controller: formModel.fullnameTextModel,
                validator: validateFullname,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                            width: 1, color: Colors.grey)),
                    prefixIcon: Container(
                      padding: EdgeInsets.all(15),
                      child: SvgPicture.asset(
                        'assets/images/profile_icon.svg',
                        color: Colors.white,
                      ),
                    ),
                  //  fillColor: Colors.grey,
                    filled: true,
                    hintText: "Full Name",),
              ),

              SizedBox(height: 5.h,),

              TextFormField(
                textAlignVertical: TextAlignVertical.center,
                cursorColor: Colors.white,
                style: TextStyle(
                    color: Colors.white, fontSize: 18.sp),
                controller: formModel.usernameTextModel,
                validator: usernameValidator,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                            width: 1, color: Colors.grey)),
                    prefixIcon: Container(
                      padding: EdgeInsets.all(15),
                      child: SvgPicture.asset(
                        'assets/images/profile_icon.svg',
                        color: Colors.grey,
                      ),
                    ),

                   // fillColor: Colors.grey,
                    filled: true,
                    hintText: "username",),
              ),

              SizedBox(height: 5.h,),
              TextFormField(
                textAlignVertical: TextAlignVertical.center,
                cursorColor: Colors.white,
                style: TextStyle(
                    color: Colors.white, fontSize: 18.sp),
                controller: formModel.bioTextModel,
                validator: validateBio,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                            width: 1, color: Colors.grey)),
                    prefixIcon: Container(
                      padding: EdgeInsets.all(15),
                      child: SvgPicture.asset(
                        'assets/images/profile_icon.svg',
                        color: Colors.white,
                      ),
                    ),
                    //  fillColor: Colors.grey,
                    filled: true,
                    hintText: "Bio",),
              ),
              loading ? ProgressBar():
                  ElevatedButton(onPressed: (){

                    if(formModel.editFormKey.currentState!.validate()){
                      setState(() {
                        loading = true;
                      });
                      submitDetails();

                    }
                    else{loading = false;}

                  }, child: Text("Submit"),

                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ), primary: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h)))


            ],),
          ),
        ),
      ),
    );
  }

    Future<void> submitDetails() async {

      uploadImage();

      return userCollection.doc(_firebaseAuth.currentUser?.uid).set({"name": formModel.fullnameTextModel.text,
        "username": formModel.usernameTextModel.text,
      }).then((value) => navigateToHome())

         .catchError((error) => print("there was an error"));

  }

  navigateToHome() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
      return LandingPageManager(uid: 'uid',);
    }));
  }

  Future updateUserDetails(String uid) async {
    print("print this line inside updateuserdetails");
    print("printing uid as $uid");
    return await userCollection.doc(uid).set({
      "fullName": formModel.fullnameTextModel.text,
      "username": formModel.usernameTextModel.text
    },SetOptions(merge: true));
  }

  void _getImage(BuildContext context) async{
    try{

      imagePickerManager.pickImage(
          context: context,
          file: (file){
          setState(() {
            profilePic = file;
          });
       //   uploadPicture(image: profilePic);
          });

    }catch(e){}

  }

 Future <void> uploadImage() async {
    var imagePath = File(profilePic!.path);
   final firebaseStorage = FirebaseStorage.instance;

   if(profilePic != null){
     imageSnapshot = await firebaseStorage
         .ref(_firebaseAuth.currentUser?.uid).child("UserProfilePic").putFile(imagePath);

     print("printing this line after imagesnapshot");
     print("printing user image again as $imageSnapshot");
     print("printing user image again as ${imageSnapshot.toString()}");

   }

 }

}
