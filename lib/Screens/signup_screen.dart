
import 'package:clip/Models/form_validators.dart';
import 'package:clip/Models/user_model.dart';
import 'package:clip/Screens/edit_profile.dart';
import 'package:clip/Screens/email_verification_screen.dart';
import 'package:clip/Screens/landingPage_manager.dart';
import 'package:clip/Screens/login_screen.dart';
import 'package:clip/Utils/authExceptionHandler.dart';
import 'package:clip/Utils/authResultStatus.dart';
import 'package:clip/Utils/localStorage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../AuthMangers/auth_service.dart';
import '../Models/global_variables.dart';
import '../Utils/progress_bar.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with FormValidators {

  TextEditingController emailFieldController = TextEditingController();
  TextEditingController passFieldController = TextEditingController();
  TextEditingController comfirmPassFieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final AuthService _authService = AuthService();
  bool loading = false;
  String roleField = 'normal_user';
  bool isVisible = false;

  final _firebaseAuth = FirebaseAuth.instance;
  bool _passwordVisible =false;

  String? message;

  FirebaseAuthException? msg;

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                  width: 200.0,
                  height: 150.0,
                  child: Image.asset('assets/images/locationIcon.jpg'),
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      controller: emailFieldController,
                      validator: emailValidator,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(20.0),
                            borderSide:
                            BorderSide(width: 2, color: Colors.pink),
                          ),
                          labelText: 'Email'),
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15, bottom: 0),
                    child: TextFormField(

                      controller: passFieldController,
                      validator: passwordValidator,
                      obscureText: !_passwordVisible,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(20.0),
                            borderSide:
                            BorderSide(width: 2, color: Colors.pink),
                          ),
                          suffixIcon: IconButton(icon: Icon(_passwordVisible ? Icons.visibility
                              : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },),

                          labelText: 'Password'),
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  SizedBox(height: 1.h,),
                   Center(
                     child: Padding(
                       padding: EdgeInsets.symmetric(horizontal: 10.w),
                       child: Text("Password should be at least 6 Characters,"
                          " Should contain at least 1 UpperCase ",
                        style: TextStyle(color: Colors.black, fontSize: 14.sp),),
                     ),
                   ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15, bottom: 0),
                    child: TextFormField(

                      validator: confirmPassValidator,
                      // ignore: unrelated_type_equality_checks
                      controller: comfirmPassFieldController,
                      obscureText: !_passwordVisible,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(20.0),
                            borderSide:
                            BorderSide(width: 2, color: Colors.pink),
                          ),

                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          labelText: 'Confirm Password'),
                      style: TextStyle(fontSize: 15),
                    ),
                  ),

                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(color: Colors.blue, fontSize: 15),
                    ),
                  ),
                  SizedBox(height: 7.h,),
                  loading ? ProgressBar()
                      : ElevatedButton(
                      onPressed: () {
                        createUser();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          primary: Colors.green,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.w, vertical: 2.h),
                          textStyle: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.bold)),
                      child: const Text('SIGN UP')),
                  SizedBox(
                    height: 12,
                  ),
                  SizedBox(height: 7.h,),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen(
                              //title: 'SIGN UP HERE',
                            )),
                      );
                    },
                    child: const Text(
                      'Existing User? Login Here',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*Future _showAlertDialog(errorMsg) {
    return showDialog(context: context, builder: (buildContext){
      return AlertDialog(
        title: Text("SignUp Faild",
          style: TextStyle(fontSize: 18.sp, color: Colors.black,
              fontWeight: FontWeight.bold),),
        content: Text("$errorMsg", style: TextStyle(color: Colors.black, fontSize: 15.sp),),
      );
    });

  }*/

  String? confirmPassValidator(String? value) {
    if(value != passFieldController.text) {
      return "pasword did not match";
    }
    return null;
  }

  Future createUser() async {
     if (_formKey.currentState!.validate()) {
            setState(() {
              loading = true;
            });

            try{
              AuthUserModel? result =
              await _authService.regWithEmailAndPassword(
                emailFieldController.text,
                passFieldController.text,
              );

              if (result != null) {
                _firebaseAuth.currentUser?.sendEmailVerification();
                /*ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(duration: Duration(seconds: 5), content:
                  Text("A verifycation link has been send to your mail"),),);*/
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const EmailVerificationScreen()));
              } else {
                setState(() {
                  loading = false;
                });

              }

            } on FirebaseAuthException catch(exception){

              setState(() {
                msg = exception;
                loading = false;
              });

              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(msg!.message.toString()),));
            }
                    return;
          }

  }
}

