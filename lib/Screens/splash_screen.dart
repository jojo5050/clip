import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../AuthMangers/auth_checker.dart';
import 'landing.dart';
import 'landingPage_manager.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? _user;
  late String uid;

  @override
  void initState() {
    delayAndNavigate();
    /* uid = _user.toString();
    initialiseUser();
    super.initState();
    navigate();*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/locationIcon.jpg',
                    height: 150,
                  ))
            ],
          )),
      backgroundColor: Colors.amberAccent,
    );
  }

  void navigate() {
    if (_firebaseAuth.currentUser != null) {
      Timer(
          Duration(seconds: 3),
              () =>
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) =>
                          LandingPageManager(
                            uid: uid
                          )),
                      (route) => false));
    } else {
      Timer(
          Duration(seconds: 3),
              () =>
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  )));
    }
  }

  Future initialiseUser() async {
    await Firebase.initializeApp();
    User? firebaseUser = await FirebaseAuth.instance.currentUser;
    await firebaseUser!.reload();
    _user = await _firebaseAuth.currentUser;
  }

  void delayAndNavigate() {
    Timer(Duration(seconds: 4), () =>
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context){return AuthChecker();
        })));
  }
}
