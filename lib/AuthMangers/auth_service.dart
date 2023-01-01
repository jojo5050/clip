import 'package:clip/Models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  BuildContext? context;

  AuthUserModel? userFromFirebase(User? user){

    if (user != null){

      return AuthUserModel(uid: user.uid);
    }else{
      return null;
    }
  }

  Stream<AuthUserModel?> get onAuthStateChange{
      return _firebaseAuth.authStateChanges().map(userFromFirebase);

  }

  Future regWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = (await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password));
      User? user = result.user;
      return userFromFirebase(user);

    } on FirebaseAuthException catch (e) {
      if(e.code == "email-already-in-use"){
        ScaffoldMessenger.of(context!)
            .showSnackBar(const SnackBar(content: Text("The Email Already Exist") ));
      }
      return null;
    }
    catch(e){
      debugPrint(e.toString());
      return null;
    }


  }

  // signin with email and password
  Future signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = (await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password));
      User? user = result.user;
      return userFromFirebase(user);

    } catch (e, str) {
      print("Bug: $str");
      return null;
    }
  }

}