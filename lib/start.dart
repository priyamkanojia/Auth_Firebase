import 'package:auth_firebase/google_sign_in.dart';
import 'package:auth_firebase/homePage.dart';
import 'package:auth_firebase/login.dart';
import 'package:auth_firebase/signUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Future<UserCredential> googleSignIn() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (googleAuth.idToken != null && googleAuth.accessToken != null) {
        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

        final UserCredential user = await _auth.signInWithCredential(credential);

        //await Navigator.pushReplacementNamed(context, "/");

        return user;
      } else {
        throw StateError('Missing Google Auth Token');
      }
    } else
      throw StateError('Sign in Aborted');
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting){
        return Center(child: CircularProgressIndicator());
        }else if(snapshot.hasError){
          return Center(child: Text('Something Went Wrong'));
        }else if(snapshot.hasData){
          return HomePage();
        }else{
          return Scaffold(
            body: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 25.0,),
                  Container(
                    height: 300.0,
                    child: Image.asset('images/start.jpg'),
                  ),
                  SizedBox(height: 15.0,),
                  RichText(text: TextSpan(
                      text: 'Welcome to ' , style: TextStyle(fontSize:25.0,fontWeight:FontWeight.bold,color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                            text:'X Groceries',style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold,color: Colors.orange)
                        )
                      ]
                  )),
                  SizedBox(height: 10.0),
                  Text('Fresh Groceries At Your Doorstep'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: ElevatedButton(
                            style:ElevatedButton.styleFrom(primary: Colors.orange,elevation: 5,shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                            }, child: Text('LOGIN',style: TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.bold),)),
                      ),
                      SizedBox(width: 10.0),
                      Padding(
                        padding:EdgeInsets.all(15.0),
                        child: ElevatedButton(
                            style:ElevatedButton.styleFrom(primary: Colors.orange,elevation: 5,shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
                            }, child: Text('REGISTER',style: TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.bold),)),
                      ),
                    ],
                  ),
                  //SizedBox(height: 20.0,),
                  SignInButton(
                    Buttons.GoogleDark,
                    onPressed:(){
                      final provider = Provider.of<GoogleSignInProvider>(context,listen: false);
                      provider.googleLogin();
                      //_showButtonPressDialog(context, 'Google (dark)');
                    },
                    text: 'Sign up with Google',
                  ),

                ],
              ),
            ),
          );
        }

      }
    );
  }
}
