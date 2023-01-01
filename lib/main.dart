import 'package:clip/AuthMangers/auth_service.dart';
import 'package:clip/Models/user_model.dart';
import 'package:clip/Screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'Utils/routes.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  // This widget is the root of your application.
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

