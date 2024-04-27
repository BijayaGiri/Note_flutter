import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasetrial/Button/RoundButton.dart';
import 'package:firebasetrial/UI/PostScreen.dart';
import 'package:firebasetrial/UI/SignUpScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Utils/Utilities.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final EmailController=TextEditingController();
  final PasswordController=TextEditingController();
  bool loading=false;
  final _auth=FirebaseAuth.instance;//creting the instance of the firebase
  final _formkey=GlobalKey<FormState>();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    EmailController.dispose();
    PasswordController.dispose();
  }

  void login(){
    setState(() {
      loading=true;
    });
  _auth.signInWithEmailAndPassword(email: EmailController.text.toString(), password: PasswordController.text.toString()).then((value) {
    setState(() {
      loading=false;
    });
    Utils().toastMessage(value.user!.email.toString());
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>PostScreen()));
  }).onError((error, stackTrace) {
    setState(() {
      loading=false;
    });
    Utils().toastMessage(error.toString());
  });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        title: Center(
          child: Text("Login Screen",style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:20),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           SizedBox(
             height: 50,
           ),
           CircleAvatar(
             maxRadius: 50,
             child: Image.asset("assets/images/img.png"),
           ),
            SizedBox(
              height: 70,
            ),

            Form(
                key: _formkey,
                child: Column(children: [
                  TextFormField(
                    controller: EmailController,
                    decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return "Enter Email";
                      }
                      return null;
                    },

                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: PasswordController,
                    decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: Icon(Icons.security),
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return "Enter password";
                      }
                      return null;
                    },
                  ),

                  SizedBox(
                    height: 50,
                  ),
                  RoundButton(
                      loading: loading,
                      title: "Login", onTap:(){
                        if(_formkey.currentState!.validate()){
                          login();
                        }
                  })


            ],)),
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Text("Dont have an account:"),
             TextButton(onPressed: (){
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
             }, child: Text("Signup")),
             ],
           )

          ],
        ),
      ),
      
    );
  }
}
