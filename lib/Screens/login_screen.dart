import 'package:clip/AuthMangers/auth_service.dart';
import 'package:clip/Models/form_validators.dart';
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

class _LoginScreenState extends State<LoginScreen> with FormValidators {

  final _formKey = GlobalKey<FormState>();
  TextEditingController emailFieldController = TextEditingController();
  TextEditingController passFieldController = TextEditingController();

  String emailField = "";
  String passField = "";
  String error = "";
  bool loading = false;
  bool _passwordVisible = false;
  final _firebaseAuth = FirebaseAuth.instance;
 final AuthService _authService = AuthService();

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
                     controller: passFieldController,
                     // validator: passwordValidator,
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
                            icon: Icon(_passwordVisible
                              ? Icons.visibility : Icons.visibility_off
                          ), onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                          },),
                          labelText: 'Password'),

                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                    },
                    child: const Text(
                      'Forgot Password',
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  loading
                      ? ProgressBar()
                      : ElevatedButton(
                      onPressed: () {
                        logUserIn();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          primary: Colors.green,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.w, vertical: 2.h),
                          textStyle: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.bold)),
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
                        color: Colors.black,
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

  Future logUserIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });

      try{
        AuthUserModel? result =
        await _authService.signInWithEmailAndPassword(
            emailFieldController.text,
            passFieldController.text);

        if(result != null){
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Login Successful")));

          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => LandingPageManager(
                      uid: result.uid)));
                     return;
        }else{
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

