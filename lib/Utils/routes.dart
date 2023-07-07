

import 'package:clip/Screens/all_users.dart';
import 'package:clip/Screens/edit_profile.dart';
import 'package:clip/ChatManager/chat_user_list.dart';
import 'package:clip/Screens/incoming_request.dart';
import 'package:clip/Screens/sent_friends_request.dart';
import 'package:clip/Screens/landingPage_manager.dart';
import 'package:clip/Screens/loged_user_profile.dart';
import 'package:clip/Screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../OnboardingScreens/splash_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {

    case '/loginScreen':
      return MaterialPageRoute(builder: (_) => LoginScreen());

    case '/splash-screen':
      return MaterialPageRoute(builder: (_) => SplashScreen());

    case '/landing':
      return MaterialPageRoute(builder: (_) => ChatUserList());

    case '/edit_profile':
      return MaterialPageRoute(builder: (_) => EditProfile());

    case '/sent_friend_request':
      return MaterialPageRoute(builder: (_) => SentFriendsRequest());

    case '/incoming_request':
      return MaterialPageRoute(builder: (_) => IncomingRequest());
    case '/allUsers':
      return MaterialPageRoute(builder: (_) => AllUsers());

    case '/sentFriendsRequest':
      return MaterialPageRoute(builder: (_) => SentFriendsRequest());

    case '/logedUserProfile':
      return MaterialPageRoute(builder: (_) => LogedUserProfile(documentID: 'documentID',));

    case '/LandipageManager':
      return MaterialPageRoute(builder: (_) => LandingPageManager(uid: 'uid',));

    default:
      return MaterialPageRoute(builder: (_) => Container());
  }
}