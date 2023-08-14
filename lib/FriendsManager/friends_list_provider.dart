

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Models/firestore_constants.dart';

class FriendListProvider {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firebaseFirestore;

  FriendListProvider({required this.firebaseFirestore});

  Future<void> updateDataFirestore(String collectionPath, String path, Map<String, String> dataNeedUpdate) {
    return firebaseFirestore.collection(collectionPath).doc(path).update(dataNeedUpdate);
  }

  Stream<QuerySnapshot> getStreamFireStore(int limit) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      CollectionReference friendsCollection = firebaseFirestore
          .collection("Users")
          .doc(currentUser.uid)
          .collection("Friends");
        return friendsCollection.limit(limit).snapshots();

    } else {
      // User is not logged in, return an empty stream
      return Stream<QuerySnapshot>.empty();
    }
  }


}