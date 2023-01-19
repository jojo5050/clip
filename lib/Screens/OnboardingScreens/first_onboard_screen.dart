import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../Utils/routers.dart';

class FirstOnboardScreen extends StatelessWidget {
  const FirstOnboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Routers.pushNamed(context, '/loginScreen');
                      },
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ))
                ],
              ),
              // SizedBox(height: 15.h),

              Container(
                child: Image.asset(
                    'assets/images/locationIcon.jpg',
                    height: 200,
                    width: 500,
                  ),
              ),

              SizedBox(
                height: 5.h,
              ),

           Container(
             child: const Text(
                    "Some text here",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none),
                  ),
           ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Row(children: const [
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
                  ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
