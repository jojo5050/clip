
import 'dart:io';
import 'dart:typed_data';

import 'package:clip/AuthMangers/auth_service.dart';
import 'package:clip/Models/form_model.dart';
import 'package:clip/Screens/landingPage_manager.dart';
import 'package:clip/Utils/imagePickerManager.dart';
import 'package:clip/Utils/localStorage.dart';
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
import 'loged_user_profile.dart';
import 'package:intl/intl.dart';

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
  User? currentuser = FirebaseAuth.instance.currentUser;

  bool loading = false;

  String? uid;

  User? user;

  File? profilePic;

  String firstDropValue = "Abia";

  var items = ['Abia', 'Adamawa', 'Akwa Ibom', 'Anambra', 'Bauchi', 'Bayelsa', 'Benue', 'Borno', 'Cross River', 'Delta',
    'Ebonyi', 'Edo', 'Ekiti', 'Enugu', 'Gombe', 'Imo', 'Jigawa', 'Kaduna', 'Kano', 'Katsina', 'Kebbi', 'Kogi',
    'Kwara', 'Lagos', 'Nasarawa', 'Niger', 'Ogun', 'Ondo', 'Osun', 'Oyo', 'Plateau', 'Rivers', 'Sokoto', 'Taraba',
    'Yobe', 'Zamfara'];

  String? image;

  String? imageLink;

  String? imageString;

  String? downloadUrl;

  String? a;

  TaskSnapshot? imageSnapshot;

  String initialValue = "Male";
  var sexValue = ['Male', 'Female'];

  TextEditingController dateController =  TextEditingController();

  @override
  void initState() {
    dateController.text = "";
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      backgroundColor: Colors.black,
      title: Text("Edit Profile",
        style: TextStyle(color: Colors.white, fontSize: 20.sp )),),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
          child: Form(
                    key: formModel.editFormKey,
            child: Column(children: [
              SizedBox(height: 3.h,),
              Center(
                child: Text("Welcome",
                  style: TextStyle(color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.bold),),
              ),
              SizedBox(height: 1.h,),
              Center(
                child: Text("Fill in your details to create your profile",
                  style: TextStyle(color: Colors.black, fontSize: 17.sp,),),
              ),
              SizedBox(height: 4.h,),

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
                cursorColor: Colors.black,
                style: TextStyle(
                    color: Colors.black, fontSize: 18.sp),
                controller: formModel.fullnameTextModel,
                validator: validateFullname,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                            width: 1, color: Colors.grey)),
                    hintText: "Full Name",),
              ),

              SizedBox(height: 2.h,),

              TextFormField(
                textAlignVertical: TextAlignVertical.center,
                cursorColor: Colors.black,
                style: TextStyle(
                    color: Colors.black, fontSize: 18.sp),
                controller: formModel.usernameTextModel,
                validator: usernameValidator,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                            width: 1, color: Colors.grey)),
                  //  filled: true,
                    hintText: "username",),
              ),
              SizedBox(height: 2.h),
              Row(children: [
                Text("Sex:", style: TextStyle(color: Colors.black, fontSize: 20.sp)),
                SizedBox(width: 4.w,),

                DropdownButton<String>(
                    value: initialValue,
                    style: TextStyle(color: Colors.black, fontSize: 18.sp, fontWeight: FontWeight.bold),
                    items: sexValue.map((String itemData) {
                      return DropdownMenuItem(value: itemData, child: Text(itemData));

                    }).toList(), onChanged: (newValue) {
                  setState(() {
                    initialValue = newValue!;
                  });
                }),

              ],),

              SizedBox(height: 2.h,),

              TextFormField(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1960),
                      lastDate: DateTime(2025));
                  if (pickedDate != null) {
                    print("..........................$pickedDate");
                    String formatDate =
                    DateFormat("yyyy-MM-DD").format(pickedDate);
                    setState(() {
                      dateController.text = formatDate;
                    });
                  } else {
                    print("...............Date is empty");
                  }
                },
                controller: dateController,
                style: TextStyle(color: Colors.black, fontSize: 18.sp),
                decoration: const InputDecoration(
                    suffixIcon: Icon(
                      Icons.calendar_today,
                      color: Colors.black,
                    ),
                    hintText: "Date",
                    hintStyle: TextStyle(color: Colors.black)),
                readOnly: true,
              ),

              Row(children: [
                Text("Location:", style: TextStyle(color: Colors.black, fontSize: 20.sp)),
                SizedBox(width: 4.w,),

                DropdownButton<String>(
                    value: firstDropValue,
                    style: TextStyle(color: Colors.black, fontSize: 18.sp, fontWeight: FontWeight.bold),
                    items: items.map((String itemData) {
                      return DropdownMenuItem(value: itemData, child: Text(itemData));

                    }).toList(), onChanged: (newValue) {
                  setState(() {
                    firstDropValue = newValue!;
                  });
                }),

              ],),

              SizedBox(height: 2.h,),
              TextFormField(
                textAlignVertical: TextAlignVertical.center,
                cursorColor: Colors.black,
                style: TextStyle(
                    color: Colors.black, fontSize: 18.sp),
                controller: formModel.bioTextModel,
                validator: validateBio,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                            width: 1, color: Colors.grey)),
                    hintText: "Bio",),
              ),
              SizedBox(height: 4.h,),
              loading ? ProgressBar():
                  ElevatedButton(onPressed: (){

                    if(formModel.editFormKey.currentState!.validate()){
                      setState(() {
                        loading = true;
                      });
                      uploadImage();

                    }
                    else{
                      loading = false;
                    }

                  },

                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ), primary: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 2.h)),
                      child: const Text("Submit",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),))


            ],),
          ),
        ),
      ),
    );
  }

    Future<void> submitDetails() async {
       return userCollection.doc(_firebaseAuth.currentUser?.uid).set({
        "name": formModel.fullnameTextModel.text,
        "username": formModel.usernameTextModel.text,
        "Location": firstDropValue,
        "Bio": formModel.bioTextModel.text,
         "profilePic": downloadUrl,
         "userID": currentuser?.uid,
         "DOB": dateController.text

       }).then((value) => navigateToHome())
        .catchError((error) => print(error));

    }

  navigateToHome() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
      return const LandingPageManager(uid: "uid",);
    }));
  }

  /*Future updateUserDetails(String uid) async {
    print("print this line inside updateuserdetails");
    print("printing uid as $uid");
    return await userCollection.doc(uid).set({
      "fullName": formModel.fullnameTextModel.text,
      "username": formModel.usernameTextModel.text
    },SetOptions(merge: true));
  }*/

  void _getImage(BuildContext context) async{
    try{

      imagePickerManager.pickImage(
          context: context,
          file: (file){
          setState(() {
            profilePic = file;
          });

          });

    }catch(e){}

  }

 Future<void> uploadImage() async {
    var imagePath = File(profilePic!.path);
   final firebaseStorage = FirebaseStorage.instance;

   if(profilePic != null){

     imageSnapshot = await firebaseStorage.ref(_firebaseAuth.currentUser?.uid).putFile(imagePath);

     }else{
     print("error image is empty");
   }

    downloadUrl = await (await imageSnapshot)?.ref.getDownloadURL();

    submitDetails();

    }

}
