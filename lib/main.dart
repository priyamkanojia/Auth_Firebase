import 'package:auth_firebase/google_sign_in.dart';
import 'package:auth_firebase/homePage.dart';
import 'package:auth_firebase/login.dart';
import 'package:auth_firebase/signUp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'start.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context)=> GoogleSignInProvider(),
          child: MaterialApp(
            color: Colors.white,
            debugShowCheckedModeBanner: false,
            home: Start(),
  )
  );
}