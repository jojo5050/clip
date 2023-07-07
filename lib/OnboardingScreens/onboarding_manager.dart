
import 'package:clip/OnboardingScreens/second_onboard_screen.dart';
import 'package:flutter/material.dart';

import 'first_onboard_screen.dart';

class OnboardManager extends StatelessWidget {
  final pageController = PageController(initialPage: 0);

  OnboardManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PageView(controller: pageController,
        children:<Widget> [
          FirstOnboardScreen(),
          SecondOnboardScreen()

        ],
        ),
      ),
    );
  }
}
