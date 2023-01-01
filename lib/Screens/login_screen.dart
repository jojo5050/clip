import 'package:clip/AuthMangers/auth_service.dart';
import 'package:clip/Models/user_model.dart';
import 'package:clip/Screens/landingPage_manager.dart';
import 'package:clip/Screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../Utils/progress_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();

  String emailField = "";
  String passField = "";
  String error = "";
  bool loading = false;
  bool _passwordVisible = false;
  final _firebaseAuth = FirebaseAuth.instance;
 final AuthService _authService = AuthService();

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
                      val!.isEmpty ? 'Email must not be empty' : null,
                      onChanged: (val) {
                        setState(() => emailField = val);
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(
                              20.0,
                            ),
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
                          suffixIcon: IconButton(icon: Icon(_passwordVisible
                              ? Icons.visibility : Icons.visibility_off
                          ), onPressed: () {  },),
                          labelText: 'Password'),

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
                  SizedBox(height: 10.sp,),
                  loading
                      ? ProgressBar()
                      : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            loading = true;
                          });
                          AuthUserModel result =
                          await _authService.signInWithEmailAndPassword(
                              emailField, passField);

                           if(_firebaseAuth.currentUser!.uid.isEmpty){
                             ScaffoldMessenger.of(context)
                                 .showSnackBar(SnackBar(content: Text("User does not exit")));
                             return;
                           }else{
                             // ignore: use_build_context_synchronously
                             Navigator.pushReplacement(
                                 context,
                                 MaterialPageRoute(
                                     builder: (context) => LandingPageManager(
                                         uid: result.uid)));
                           }

                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          primary: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          textStyle: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      child: const Text('LOGIN')),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    error,
                    style: const TextStyle(color: Colors.red, fontSize: 14.0),
                  ),
                 SizedBox(height: 5.h,),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'New User? Create Account',
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

