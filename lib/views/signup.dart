import 'package:chat_app/helper/helperfunction.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/chatRoomScreen.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class  SignUp extends StatefulWidget {

  final Function toggle;
  SignUp(this.toggle);

  @override
  _State createState() => _State();
}

class _State extends State<SignUp> {

  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  signMeUP(){

    if(formKey.currentState.validate()){

      Map<String, String> userInfoMap = {
        "name" : userNameTextEditingController.text,
        "email" : emailTextEditingController.text
      };

      HelperFunction.saveUserEmailSharedPreference(emailTextEditingController.text);
      HelperFunction.saveUserNameSharedPreference(userNameTextEditingController.text);



      setState(() {
        isLoading = true;
      });

      authMethods.signInWithEmailAndPassword(emailTextEditingController.text,
          passwordTextEditingController.text).then((val) {
        print("${val.uid}");
      });

      databaseMethods.uploadUserInfo(userInfoMap);
      HelperFunction.saveUserLoggedInSharedPreference(true);
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => ChatRoom()
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      ) : SingleChildScrollView(
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
                        return val.isEmpty || val.length < 2 ? "Enter valid username" : null;
                        },
                        controller: userNameTextEditingController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("username"),),
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
                    signMeUP();
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
                    child: Text("Sign Up" , style: TextStyle(
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
                  child: Text("Sign Up with Google" , style: TextStyle(
                      color: Colors.black87,
                      fontSize: 17
                  ),),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have account?  ", style: mediumTextStyle(),),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text("SignIn now", style: TextStyle(
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
