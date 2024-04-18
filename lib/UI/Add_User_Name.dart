import 'package:firebasetrial/Button/RoundButton.dart';
import 'package:firebasetrial/ID/uid.dart';
import 'package:firebasetrial/UI/LoginScreen.dart';
import 'package:firebasetrial/Utils/Utilities.dart';
import 'package:flutter/material.dart';
class AddUserName extends StatefulWidget {
  const AddUserName({super.key});

  @override
  State<AddUserName> createState() => _AddUserNameState();
}

class _AddUserNameState extends State<AddUserName> {
  String id=DateTime.now().millisecondsSinceEpoch.toString();
  final username=TextEditingController();
  final phonenumber=TextEditingController();
  final uid=UId().id();//getting the user id
  final ref=reference().usernameRef;//creating the reference of the database
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,

        title: Center(child: Text("User Credentials",style: TextStyle(
          color: Colors.white,
          fontWeight:FontWeight.bold,
        ),)),

      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
           // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
              ),
              CircleAvatar(
                maxRadius: 50,
                child:Image(image:AssetImage("assets/images/img.png"))),
              SizedBox(
                height: 50,
              ),
              TextField(
                controller: username,
                decoration: InputDecoration(
                  hintText: "Enter the Name",
                  prefixIcon: Icon(Icons.person),
                  //border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20,

              ),
              TextFormField(
                controller:phonenumber,
                decoration: InputDecoration(
                  hintText: "Enter the Phone Number",
                  prefixIcon: Icon(Icons.phone),

                 // border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 50,
              ),

              RoundButton(
                  title: "Create", onTap:(){
                ref.child(id).set({
                  "UserName":username.text.toString(),
                  "phoneNumber":phonenumber.text.toString(),
                  "id":id,
                }).then((value) {
                  Utils().toastMessage("User Credentials Will be applied soon!");
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));

                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              } )
            ],
          ),
        ),
      ),

    );
  }
}
