import 'package:circle_bottom_navigation_bar/circle_bottom_navigation_bar.dart';
import 'package:circle_bottom_navigation_bar/widgets/tab_data.dart';
import 'package:clip/Screens/landing.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'loged_user_profile.dart';

class LandingPageManager extends StatefulWidget {
  const LandingPageManager({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  _LandingPageManagerState createState() => _LandingPageManagerState();
}

class _LandingPageManagerState extends State<LandingPageManager> {

  int selectedIndex = 0;
  double bottomNavBarHeight = 60;

  static const List<Widget> _pages = <Widget>[
  Landing(uid: "uid"),
  LogedUserProfile(documentID: 'documentID',),


];



@override
  Widget build(BuildContext context) {

  final size = MediaQuery.of(context).size;
  final viewPadding = MediaQuery.of(context).viewPadding;
  double barHeight;
  double barHeightWithNotch = 67;
  double arcHeightWithNotch = 67;

  if (size.height > 900) {
    barHeight = 40;
  } else {
    barHeight = size.height * 0.11;
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
        // circleOutline: 15.0,
        shadowAllowance: 0.0,
        circleSize: 60.0,
        blurShadowRadius: 50.0,
        circleColor: Colors.green,
        activeIconColor: Colors.white,
        inactiveIconColor: Colors.grey,
        textColor: Colors.grey,

        barBackgroundColor: Colors.black.withOpacity(0.9),
        tabs: getTabsData(),
        onTabChangedListener: (index) => setState(() => selectedIndex = index),
      ),
    );
  }

  List<TabData> getTabsData() {
      return [
        TabData(
          icon: Icons.home,
          iconSize: 25.0,
          title: 'Home',
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
        ),
        TabData(
          icon: Icons.person,
          iconSize: 25,
          title: 'Profile',
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
        ),
      ];
  }
}
