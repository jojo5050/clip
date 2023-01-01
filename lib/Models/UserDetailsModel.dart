import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetailsModel {
  String uid;
  String userName;
  String name;


  UserDetailsModel({required this.uid, required this.userName, required this.name});


  factory UserDetailsModel.fromMap(map){
    return UserDetailsModel(
      uid: map['uid'],
      userName: map['username'],
      name: map['name'],
    );
  }

  // sending data to firebase server
  Map<String, dynamic> toMap(){
    return{
      'uid':uid,
      'userName':userName,
      'name':name,
    };
  }

}