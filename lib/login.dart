import 'package:auth_firebase/signUp.dart';
import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'homePage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  //late String _email, _password;
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();


  checkAuthentification () async{
    _auth.authStateChanges().listen((user) {
      if(user!=null){
        Navigator.push(context, MaterialPageRoute(builder:(context)=>HomePage()));
      }
    });
  }

  Future<void> sendOTP() async {
    EmailAuth.sessionName ='Test Session';
    var res = await EmailAuth.sendOtp(receiverMail: _email.text);
    if(res){
      print('OTP Send');
      Alert(context: context, title:'Please Check Your ${_email.text} Inbox').show();
    }else{
      print('We could not send OTP');
      Alert(context: context, title:'Unable To Send OTP',desc: 'Please enter a valid email').show();
    }
  }
   verifyOTP(){
    var res = EmailAuth.validate(receiverMail: _email.text, userOTP:_otpController.text);
    if(res){
      print('OTP Verified');
      Alert(context: context, title:'OTP Verified').show();
    }
    else{
      print('Invalid OTP');
      Alert(context: context, title:'Invalid OTP',desc: 'Please enter a valid OTP').show();

    }
  }

login() async{
    if(_formkey.currentState!.validate())
      {
        print('Successfull');
        print(_email);
        print(_password);
        _formkey.currentState!.save();
        try{
          final user =  await _auth.signInWithEmailAndPassword(email: _email.text, password: _password.text);
          if (user != null) {
            print('Logged In');
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
          }
          }
        catch(e){
          showError(e.toString());
          print(e);
        }
      }
    else
      print('Unsuccessfull');
}
showError(String errormessage){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
          title:Text('Error'),
          content: Text(errormessage),
          actions: <Widget>[
            TextButton(onPressed: () {
              print('showError');
              Navigator.of(context).pop();
            },
            child: Text('OK'))
      ],
      );
    }
    );
}
void doNotHaveAcc(){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUp()));
}
void resetPassword(){
    _auth.sendPasswordResetEmail(email: _email.text);
    Alert(context: context, title:'Please check ${_email.text} Inbox for password reset link').show();
}
  @override
  void initState(){
    super.initState();
    //this.checkAuthentification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(height:30.0,),
              Container(
                height: 300.0,
                child: Image.asset('images/login.jpg'),
              ),
              SizedBox(height:30.0,),
              Form(
                key: _formkey,
                  child:Column(
                    children: <Widget>[
                      Container(
                        width: 300.0,
                        child: TextFormField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            suffixIcon: TextButton(
                              onPressed: (){sendOTP();},
                              child: Text('Send OTP'),
                            ),
                          ),
                          validator: (String? input)
                            {
                              if(input!.isEmpty){
                                return "Enter Email.";
                              }
                              if(!RegExp('^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]').hasMatch(input)){
                                //print(input);
                                return'Please enter a valid email';
                              }
                              // setState(() {
                              //   _email=input;
                              // });
                              // //return null;
                            },
                        ),
                      ),
                      Container(
                        width: 300.0,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _otpController,
                          decoration: InputDecoration(
                              labelText: 'Email OTP',
                              prefixIcon: Icon(Icons.password),
                              suffixIcon: TextButton(
                                onPressed: (){verifyOTP();},
                                child: Text('Verify OTP'),
                              )
                          ),
                              validator: (String? input)
                              {
                                if(input!.length <6){
                                return "Invalid OTP";}
                              }
                        ),
                      ),
                      Container(
                        width: 300.0,
                        child: TextFormField(
                            controller: _password,
                            obscureText: true,
                            decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock)
                            ),
                            validator: (String? input)
                            {
                              if(input!.length <6){
                                return "Minimum 6 char password.";
                              }
                              // setState(() {
                              //   _password=input;
                              // });
                              // //return null;
                            },
                        ),
                      ),
                      SizedBox(height:8.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: resetPassword,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Text('Forgot Password',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),textAlign:TextAlign.left,),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height:20.0,),
                      ElevatedButton(
                          style:ElevatedButton.styleFrom(primary: Colors.orange,elevation: 5,shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
                          onPressed: (){
                            login();
                          }, child: Text('Login',style: TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.bold),)),
                      SizedBox(height:20.0,),
                      GestureDetector(
                        child: Text('Create an account ?',style: TextStyle(fontWeight:FontWeight.bold),),
                        onTap:doNotHaveAcc,
                      ),
                      SizedBox(height:30.0,)
                    ],
              )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
