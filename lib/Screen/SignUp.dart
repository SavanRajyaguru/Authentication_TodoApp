import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/Model/authentication.dart';
import 'package:todoapp/Screen/Login.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool _obscureText = true;
  bool _obscureText1 = true;
  bool agree = false;
  String? password;
  String? email;
  // final pass = new TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey.shade900,
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerRight,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  backgroundColor: Colors.cyan,
                  child: Icon(Icons.arrow_back_outlined),
                ),
              ),
              Text(
                'Sign Up',
                style: TextStyle(fontSize: 48.0, color: Colors.white),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: emailController,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some email';
                  }
                  return null;
                },
                onSaved: (val) {
                  email = val;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: Colors.white70,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  label: Text(
                    "Email",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
              SizedBox(height: 20.0),

              // password
              TextFormField(
                controller: passController,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                textInputAction: TextInputAction.next,
                obscureText: _obscureText,
                onSaved: (val) {
                  password = val;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: Colors.white70,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white70,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  label: Text(
                    "Password",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
              SizedBox(height: 20.0),

              // confirm password
              TextFormField(
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                textInputAction: TextInputAction.next,
                obscureText: _obscureText1,
                validator: (value) {
                  if (value != passController.text){
                    return 'password not match';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: Colors.white70,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText1 = !_obscureText1;
                      });
                    },
                    child: Icon(
                      _obscureText1 ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white70,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  label: Text(
                    "Confirm Password",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
              SizedBox(height: 30.0),

              // signUp button
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.cyan,
                    minimumSize: Size.fromHeight(50),

                    // maximumSize: Size.fromHeight(50),
                  ),
                  onPressed: () async {
                    if(_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      await AuthenticationServices(_auth).signUp(
                        emailController.text.trim(),
                        passController.text.trim(),
                      ).then((result) async {
                        if (result == "Sign Up") {
                          var snackBar = SnackBar(
                            content: Text('Sign Up Successful!'),
                            backgroundColor: Colors.cyan,
                            duration: Duration(seconds: 2),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);

                          // store user uid and email in firestore
                          try {
                            String uid = await AuthenticationServices(_auth).getUser()!.uid;
                            await FirebaseFirestore.instance.collection("Users").doc(uid).set({
                              'email': '${emailController.text.trim()}',
                              'content': <String>[]
                            }).then((value) {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) => Login()));
                              print("uid: "+uid);
                            });
                          } catch(e) {
                            print(e);
                          }
                        }
                        else {
                          var snackBar = SnackBar(
                            content: Text(result!),
                            backgroundColor: Colors.cyan,
                            duration: Duration(seconds: 2),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      });
                    }
                  },
                  icon: Icon(
                    Icons.lock_open,
                    size: 30,
                  ),
                  label: Text('Sign Up')),
            ],
          ),
        ),
      ),
    );
  }
}
