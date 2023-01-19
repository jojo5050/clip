import 'package:clip/Models/user_model.dart';
import 'package:clip/Utils/authResultStatus.dart';
import 'package:clip/Utils/localStorage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Utils/authExceptionHandler.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthUserModel? userFromFirebase(User? user){
    if (user != null){
      return AuthUserModel(uid: user.uid);
    }
    else {
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

    } on FirebaseAuthException catch(e){
        var errorMsg = "An error has occurred";
        switch(e.code){
          case "email-already-in-use":
            errorMsg = "The Email Address already exist pls";
            break;

          case "operation-not-allowed":
            errorMsg = "The User Account is not enabled";
            break;

          case "invalid-email":
            errorMsg = "The Email Address is not valid";
            break;
        }
        rethrow;
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

    } on FirebaseAuthException catch(e){

      var errMssg = "An error has occurred ";
      switch(e.code){
        case "invalid-email":
          errMssg = "the email address is invalid";
          break;

        case "user-disabled":
          errMssg = "the user has been disabled";
          break;

        case "wrong-password":
          errMssg = "You entered a wrong password";
          break;

        case "user-not-found":
          errMssg = "No user found for the given credentials";
          break;
      }
      rethrow;
    }
  }
}