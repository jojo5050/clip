import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/firestore_constants.dart';

class UserChatModel {
  final String id;
  final String photoUrl;
  final String name;
  final String location;


  const UserChatModel({required this.id, required this.photoUrl, required this.location,
    required this.name, });

  Map<String, String> toJson() {
    return {
      FirestoreConstants.name: name,
      FirestoreConstants.photoUrl: photoUrl,
      FirestoreConstants.location: location,
    };
  }

  factory UserChatModel.fromDocument(DocumentSnapshot doc) {
    String photoUrl = "";
    String name = "";
    String location = "";

    try {
      photoUrl = doc.get(FirestoreConstants.photoUrl);
    } catch (e) {}
    try {
      name = doc.get(FirestoreConstants.name);
      location = doc.get(FirestoreConstants.location);
    } catch (e) {}
    return UserChatModel(
      id: doc.id,
      photoUrl: photoUrl,
      name: name,
      location: location

    );
  }
}