import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/firestore_constants.dart';

class FriendsModel {
  final String id;
  final String photoUrl;
  final String name;
  final String username;
  final String location;


  const FriendsModel({required this.id, required this.username,
    required this.photoUrl, required this.location,
    required this.name, });

  Map<String, String> toJson() {
    return {
      FirestoreConstants.name: name,
      FirestoreConstants.photoUrl: photoUrl,
      FirestoreConstants.location: location,
      FirestoreConstants.username: username,
    };
  }

  factory FriendsModel.fromDocument(DocumentSnapshot doc) {
    String photoUrl = "";
    String name = "";
    String location = "";
    String username = "";

    try {
      photoUrl = doc.get(FirestoreConstants.photoUrl);
    } catch (e) {}
    try {
      name = doc.get(FirestoreConstants.name);
      username = doc.get(FirestoreConstants.username);
      location = doc.get(FirestoreConstants.location);
    } catch (e) {}
    return FriendsModel(
        id: doc.id,
        photoUrl: photoUrl,
        name: name,
        location: location,
        username: username

    );
  }
}