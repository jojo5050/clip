import 'package:circle_bottom_navigation_bar/circle_bottom_navigation_bar.dart';
import 'package:circle_bottom_navigation_bar/widgets/tab_data.dart';
import 'package:clip/Screens/chat_user_list.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'all_users.dart';
import 'find_users.dart';
import 'go_live.dart';
import 'loged_user_profile.dart';

class LandingPageManager extends StatefulWidget {
  const LandingPageManager({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  _LandingPageManagerState createState() => _LandingPageManagerState();
}

class _LandingPageManagerState extends State<LandingPageManager> {

  int selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
 // Landing(uid: "uid"),
    LogedUserProfile(documentID: 'documentID',),
  AllUsers(),
    ChatUserList(),
  FindUsers(),
    GoLive(),


];



@override
  Widget build(BuildContext context) {

  final size = MediaQuery.of(context).size;
  final viewPadding = MediaQuery.of(context).viewPadding;
  double barHeight;
  double barHeightWithNotch = 67;
  double arcHeightWithNotch = 67;

  if (size.height > 700) {
    barHeight = 62;
  } else {
    barHeight = size.height * 0.1;
  }

  if (viewPadding.bottom > 0) {
    barHeightWithNotch = (size.height * 0.07) + viewPadding.bottom;
    arcHeightWithNotch = (size.height * 0.075) + viewPadding.bottom;
  }


    return Scaffold(
      body: _pages[selectedIndex],
      bottomNavigationBar: CircleBottomNavigationBar(
        initialSelection: selectedIndex,
        barHeight: viewPadding.bottom > 0 ? barHeightWithNotch : barHeight,
        arcHeight: viewPadding.bottom > 0 ? arcHeightWithNotch : barHeight,
        itemTextOff: viewPadding.bottom > 0 ? 0 : 1,
        itemTextOn: viewPadding.bottom > 0 ? 0 : 1,
         circleOutline: 15.0,
        shadowAllowance: 0.0,
        circleSize: 50.0,
        blurShadowRadius: 50.0,
        circleColor: Colors.white,
        activeIconColor: Colors.black,
        inactiveIconColor: Colors.grey,
        textColor: Colors.black,
        hasElevationShadows: true,

        barBackgroundColor: Colors.white,
        tabs: getTabsData(),
        onTabChangedListener: (index) => setState(() => selectedIndex = index),
      ),
    );
  }

  List<TabData> getTabsData() {
      return [
        TabData(
          icon: Icons.person,
          iconSize: 20.0,
          title: 'Profile',
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
        ),
        TabData(
          icon: Icons.group,
          iconSize: 20.0,
          title: 'All Users',
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
        ),
        TabData(
          icon: Icons.chat,
          iconSize: 20.0,
          title: 'Chat',
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
        ),
        TabData(
          icon: Icons.search,
          iconSize: 20.0,
          title: 'Find User',
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
        ),
        TabData(
          icon: Icons.live_tv,
          iconSize: 20,
          title: 'Go Live',
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
        ),
      ];
  }
}
