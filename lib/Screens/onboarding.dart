import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../Utils/routers.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.grey,
      body: Column(
        children: [
         // SizedBox(height: 15.h),
          Center(
            child: Image.asset(
              'assets/images/locationIcon.jpg',
              height: 200,
              width: 500,
            ),
          ),
         /* SizedBox(
            height: 10.h,
          ),*/
          const Text(
            "work in progress",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16, fontWeight: FontWeight.bold,
                decoration: TextDecoration.none),
          ),
          /*SizedBox(
            height: 3.h,
          ),

          SizedBox(
            height: 30.h,
          ),*/

          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 5,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white30,
                    radius: 5,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white30,
                    radius: 5,
                  ),
                ]
                ),
                InkWell(onTap: () {Routers.pushNamed(context, '/loginScreen');

                },
                  child: Container(height: 15, width: 50,
                    decoration: BoxDecoration(color: Colors.green,
                        borderRadius: BorderRadius.circular(15)),
                    child: const Center(
                      child: Text(
                        "Skip",
                        style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.none, fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
