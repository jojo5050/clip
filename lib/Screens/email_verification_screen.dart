import 'package:clip/Screens/edit_profile.dart';
import 'package:clip/Utils/progress_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool loading = false;

  TextEditingController verifyEmailController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final inputeKey = GlobalKey<FormState>();

  bool? isEmailVerify = false;
  bool loading1 = false;

  @override
  void initState() {
    isEmailVeriFied();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          Text(
            "A verification link has be sent to ",
            style: TextStyle(fontSize: 16.sp),
          ),
          Text(
            "${_firebaseAuth.currentUser!.email}",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "Click on the link to activate your account",
            style: TextStyle(fontSize: 16.sp),
          ),
          SizedBox(
            height: 20.h,
          ),

          Text(
            "Already verified your Email ? ",
            style: TextStyle(color: Colors.green, fontSize: 20.sp),
          ),
          SizedBox(
            height: 2.h,
          ),
          loading
              ? ProgressBar()
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      primary: Colors.green,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 3.h)),
                  onPressed: () {
                    setState(() {
                      loading = true;
                    });
                    isEmailVeriFied();
                  },
                  child: Text(
                    "Continue",
                    style: TextStyle(color: Colors.white),
                  )),

          Center(child: loading1 ? ProgressBar():
          TextButton(onPressed: (){
            setState(() {
              loading1 = true;
            });
            resendVerifycationLink();
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(duration: const Duration(seconds: 5),
                    content: Text("A Link has been sent to "
                    "${_firebaseAuth.currentUser?.email},"
                    " Click on the link to activate your account")));
            setState(() {
              loading1 = false;
            });
          },
              child: const Text("Resend", style: TextStyle(color: Colors.green),)))
        ],
      ),
    );
  }

  void isEmailVeriFied() async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVerify = FirebaseAuth.instance.currentUser?.emailVerified;
    });

    if (isEmailVerify!) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email has been verified")));
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => EditProfile()),
          (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 5),
          content: Text("Email has not been verified yet,"
              " please verify your email to continue")));
      setState(() {
        loading = false;
      });
    }
  }

  void resendVerifycationLink() async {
    _firebaseAuth.currentUser?.sendEmailVerification();
  }
}
