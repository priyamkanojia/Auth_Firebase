import 'package:auth_firebase/homePage.dart';
import 'package:auth_firebase/login.dart';
import 'package:auth_firebase/start.dart';
import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  //late String _email, _password, _name ;
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _name = TextEditingController();


  signUp() async{
    if(_formkey.currentState!.validate())
    {
      print('Successfull');
      print(_email.text);
      print(_password.text);
      _formkey.currentState!.save();
      try{
        final newUser = await _auth.createUserWithEmailAndPassword(email: _email.text, password: _password.text);
        if (newUser != null) {
          print('New user created');
          await _auth.currentUser!.updateDisplayName(_name.text);
          Navigator.push(context, MaterialPageRoute(builder: (context) =>HomePage()));
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
  void alreadyHaveAcc(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>Login()));
  }
  Future<void> sendOTP() async {
    EmailAuth.sessionName ='Test Session';
    var res = await EmailAuth.sendOtp(receiverMail: _email.text);
    if(res){
      print('OTP Send');
    }else{
      print('We could not send OTP');
      Alert(context: context, title:'Unable To Send OTP',desc: 'Please enter a valid email').show();
    }
  }
  void verifyOTP(){
    var res = EmailAuth.validate(receiverMail: _email.text, userOTP:_otpController.text);
    if(res){
      print('OTP Verified');
    }
    else{
      print('Invalid OTP');
      Alert(context: context, title:'Invalid OTP',desc: 'Please enter a valid OTP').show();

    }
}
  @override
  void initState() {
    super.initState();
    //this.checkAuthentication();
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
              SizedBox(height:15.0,),
              Form(
                  key: _formkey,
                  child:Column(
                    children: <Widget>[
                      Container(
                        width: 300.0,
                        child: TextFormField(
                          controller: _name,
                          decoration: InputDecoration(
                              labelText: 'Name',
                              prefixIcon: Icon(Icons.person),
                          ),

                          validator: (String? input)
                          {
                            if(input!.isEmpty){
                              return "Enter Name.";
                            }
                            // setState(() {
                            //   _name=input;
                            // });
                            // //return null;
                          },
                        ),
                      ),
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
                              ),
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
                      SizedBox(height:15.0,),
                      ElevatedButton(
                          style:ElevatedButton.styleFrom(primary: Colors.orange,elevation: 5,shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0))),
                          onPressed: (){
                            signUp();
                          }, child: Text('Sign Up',style: TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.bold),)),
                      SizedBox(height:15.0,),
                      GestureDetector(
                        child: Text('Already have an account ?',style: TextStyle(fontWeight:FontWeight.bold),),
                        onTap:alreadyHaveAcc,
                      ),
                      SizedBox(height:30.0,),

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
