import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebasetrial/ID/uid.dart';
import 'package:firebasetrial/UI/LoginScreen.dart';
import 'package:firebasetrial/UI/addpost.dart';
import 'package:firebasetrial/Utils/Utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final updateController=TextEditingController();
  final _auth = FirebaseAuth.instance;
  //creating the instance of the Authentication
  final uid = UId().id();
  final ref=reference().Ref;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        title: Center(
          child: Text("Post Screen",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _auth.signOut().then((value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginScreen())).onError(
                      (error, stackTrace) =>
                          Utils().toastMessage(error.toString()));
                });
              },
              icon: Icon(
                Icons.login_outlined,
                color: Colors.white,
              )),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(
                query: ref,
            itemBuilder: (context,snapshot,animation,index){
                  return ListTile(
                    trailing: PopupMenuButton(
                        icon: Icon(Icons.more_vert),
                        itemBuilder: (context)=>[
                      PopupMenuItem(

                          child: ListTile(
                            onTap: (){
                              Navigator.pop(context);
                              showdialogue(snapshot.child("title").value.toString(),snapshot.child("id").value.toString());
                            },
                            leading: Icon(Icons.edit),
                            title: Text("Update"),

                      ))
                    ]),
                    title:Text(snapshot.child("title").value.toString()) ,
                  );
            }),
          )

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddPost()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
  Future<void> showdialogue(String title,String id) {
    updateController.text=title.toString();
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Update"),
        content: Container(
          child: TextField(
            controller: updateController,
            decoration: InputDecoration(
              hintText: "Edit",
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("Cancel")),
          TextButton(onPressed: (){
            ref.child(id).update({
              "title":updateController.text.toString(),
            });
            Navigator.pop(context);
          }, child: Text("Update"),)
        ],

      );
    });

  }
}
