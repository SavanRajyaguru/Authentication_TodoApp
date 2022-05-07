import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todoapp/Screen/HomeScreen.dart';
import 'package:todoapp/Screen/Login.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter auth Demo',
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData || snapshot.data != null) {
            return HomeScreen();
          } else if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.cyan,),);
          }
          else if(snapshot.hasError) {
            return Center(
              child: Text("Restart Your App!", style: TextStyle(fontSize: 42.0, color: Colors.red),),
            );
          } else {
            return Login();
          }
        },
      ),
    );
  }
}