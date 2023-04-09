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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Routers.pushNamed(context, '/loginScreen');
                    },
                    child: Text(
                      "Skip",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.sp),
                    ))
              ],
            ),
            SizedBox(height: 5.h),

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

            SizedBox(height: 20.h,),

            Center(
              child: Row(children:  [
                const CircleAvatar(
                  backgroundColor: Colors.white30,
                  radius: 5,
                ),
                SizedBox(
                  width: 2.w,
                ),
                const CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 5,
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
