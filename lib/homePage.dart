import 'package:auth_firebase/google_sign_in.dart';
import 'package:auth_firebase/start.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isloggedin = false;
  late User user;
  checkAuthentification() async{
    _auth.authStateChanges().listen((user) {
      if(user == null){
        print('user does not exist');
        Navigator.push(context, MaterialPageRoute(builder:(context)=>Start()));
      }
    });
  }
  getUser()async{
    User? firebaseUser = await _auth.currentUser;
    await firebaseUser!.reload();
    firebaseUser = (await _auth.currentUser)!;
    if (firebaseUser!=null){
      setState(() {
        this.user=firebaseUser!;
        this.isloggedin=true;
      });
    }
  }
  // signOut() async {
  //   _auth.signOut();
  //
  //   final googleSignIn = GoogleSignIn();
  //   await googleSignIn.signOut();
  // }

  @override
  void initState(){
    super.initState();
    //this.checkAuthentification();
    this.getUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
          child:  !isloggedin?CircularProgressIndicator():Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              //SizedBox(height: 30.0,),
              Container(height: 300.0,
                child: Image.asset('images/welcome.jpg'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                child: Container(
                  child: Text(
                    'Hello! ${user.displayName} \n You are Logged in as ${user.email}',textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0,),
                  ),
                ),
              ),
              ElevatedButton(
                  style:ElevatedButton.styleFrom(primary: Colors.orange,elevation: 5,shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
                  onPressed: (){
                    final provider= Provider.of<GoogleSignInProvider>(context,listen:false);
                    provider.logout();
                    _auth.signOut();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Start()));
                  }, child: Text('LOGOUT',style: TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.bold),)),

            ],
          )
      ),
    );
  }
}
