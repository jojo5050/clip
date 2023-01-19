import 'dart:io';

import 'package:clip/AuthMangers/auth_service.dart';
import 'package:clip/Models/user_model.dart';
import 'package:clip/Screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'Utils/routes.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  initialize();
  runApp(const MyApp());
}

void initialize() async {
  var path = Directory.current.path;
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<AuthUserModel?>.value(
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'CLIP',
          theme: ThemeData(

            primarySwatch: Colors.blue,
          ),
          home: ResponsiveSizer(builder: (context , Orientation , ScreenType ) {
            return SplashScreen();
          },),
          onGenerateRoute: generateRoute,
        );
      }, value: AuthService().onAuthStateChange,
          initialData: null
    );
  }
}

