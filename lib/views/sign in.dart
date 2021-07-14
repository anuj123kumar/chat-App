import 'package:chat_app/helper/helperfunction.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chatRoomScreen.dart';

class SignIn extends StatefulWidget {

  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;

  signIn(){
    if(formKey.currentState.validate()) {
      HelperFunction.saveUserEmailSharedPreference(
          emailTextEditingController.text);

      databaseMethods.getUserByUserEmail(emailTextEditingController.text)
          .then((val){
        snapshotUserInfo = val;
        HelperFunction
            .saveUserNameSharedPreference(snapshotUserInfo.docs[0]["name"]);
      });

      setState(() {
        isLoading = true;
      });

      authMethods.signInWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text)
      .then((val) {
        if (val != null) {
          HelperFunction.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => ChatRoom()
          ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 60,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val){
                          return RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val) ? null : "Enter a valid email Id";
                        },
                        controller: emailTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("email"),
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (val){
                          return val.length > 6 ? null : "Please provide password 6+ character ";
                        },
                        controller: passwordTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("password"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: Text("forget password?", style: simpleTextStyle(),),
                  ),
                ),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: (){
                    signIn();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xff007EF4),
                          const Color(0xff2A75BC)
                        ]
                      ),
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: Text("Sign In" , style: TextStyle(
                      color: Colors.white,
                      fontSize: 17
                    ),),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text("Sign In with Google" , style: TextStyle(
                      color: Colors.black87,
                      fontSize: 17
                  ),),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have account?  ", style: mediumTextStyle(),),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text("Register now", style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          decoration: TextDecoration.underline
                        ),),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 60,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

