
import 'package:clip/Models/user_model.dart';
import 'package:clip/Screens/landingPage_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../OnboardingScreens/onboarding_manager.dart';


class AuthChecker extends StatelessWidget {
  AuthChecker({Key? key}) : super(key: key);
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool? isEmailVerify = false;



  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<AuthUserModel?>(context);

    if(userModel == null){
      return OnboardManager();
    }
    else{
      return LandingPageManager(uid: _firebaseAuth.currentUser!.uid);
    }
  }
}