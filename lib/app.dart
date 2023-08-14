import 'package:clip/FriendsManager/friends_list_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'AuthMangers/auth_service.dart';
import 'ChatManager/chat_list_provider.dart';
import 'ChatManager/chat_provider.dart';
import 'Constants/colors.dart';
import 'Models/user_model.dart';
import 'OnboardingScreens/splash_screen.dart';
import 'Utils/routes.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<AuthUserModel?>.value(
          value: AuthService().onAuthStateChange,
          initialData: null,
        ),

        Provider<ChatProvider>(
          create: (_) => ChatProvider(
            firebaseFirestore: this.firebaseFirestore,
            firebaseStorage: this.firebaseStorage,
          ),
        ),
        Provider<ChatListProvider>(
          create: (_) => ChatListProvider(
            firebaseFirestore: this.firebaseFirestore,
          ),
        ),
        Provider<FriendListProvider>(
          create: (_) => FriendListProvider(
            firebaseFirestore: this.firebaseFirestore,
          ),
        ),
      ],
      child: MaterialApp(
        title: "Clip",
        theme: ThemeData(
          fontFamily: 'Interfont',
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: AppColors.primary,
          ),
        ),

        home: ResponsiveSizer(
          builder: (context, orientation, screenType) {
            return const SplashScreen();
          },
        ),
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
