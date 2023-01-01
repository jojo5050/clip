import 'package:clip/Models/user_model.dart';
import 'package:clip/Screens/edit_profile.dart';
import 'package:clip/Screens/email_verification_screen.dart';
import 'package:clip/Screens/landingPage_manager.dart';
import 'package:clip/Screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../AuthMangers/auth_service.dart';
import '../Utils/progress_bar.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  String emailField = "";
  String passField = "";
  String confirmPassField = "";
  String error = "";
  String successMssg = "";
  bool loading = false;
  String roleField = 'normal_user';
  bool isVisible = false;
  final _firebaseAuth = FirebaseAuth.instance;

  String? m;

  bool _passwordVisible =false;

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
                      validator: (val) =>
                      val!.isEmpty ? 'Enter Your Email Address' : null,
                      onChanged: (val) {
                        setState(() => emailField = val);
                      },
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
                      validator: (val) => val!.length < 6
                          ? 'Password should be at least six characters'
                          : null,
                      onChanged: (val) {
                        setState(() => passField = val);
                      },
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
                              : Icons.visibility_off, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },),

                          labelText: 'Password'),
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15, bottom: 0),
                    child: TextFormField(
                      // ignore: unrelated_type_equality_checks
                      validator: (val) =>
                      val != passField ? 'Password not match' : null,
                      onChanged: (val) {
                        setState(() => confirmPassField = val);
                      },
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
                              color: Colors.red
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
                  Visibility(
                      visible: isVisible, child: Text('Role:' + (roleField))),
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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });

                          AuthUserModel result =
                          await _authService.regWithEmailAndPassword(
                            emailField,
                            passField,
                          );

                          if (result.uid.isEmpty) {
                            setState(() {
                              error = "please enter your details properly";
                              loading = false;
                            });
                          } else {
                            _firebaseAuth.currentUser?.sendEmailVerification();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content:
                              Text("A verifycation link has been send to your mail"),),);

                            User? user;
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const EmailVerificationScreen()));
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          primary: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          textStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      child: const Text('SIGN UP')),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
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
}
