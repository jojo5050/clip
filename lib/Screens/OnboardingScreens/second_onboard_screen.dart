import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../Utils/routers.dart';

class SecondOnboardScreen extends StatelessWidget {
  const SecondOnboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(

          children: [
            SizedBox(height: 10.h,),
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
            InkWell(
              onTap: () {
                Routers.pushNamed(context, '/loginScreen');
              },
              child: Center(
                child: Container(
                  height: 25,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(15)),
                  child: const Center(
                    child: Text(
                      "Get Started",
                      style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
