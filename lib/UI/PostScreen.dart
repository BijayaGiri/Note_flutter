import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebasetrial/Button/RoundButton.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final updateController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  //creating the instance of the Authentication
  final uid = UId().id();
  final ref = reference().Ref;
  final user = reference().usernameRef;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
        leading: IconButton(onPressed: (){
          _scaffoldKey.currentState?.openDrawer();
        }, icon:Icon(Icons.person,color: Colors.white,)),
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
      drawer:SafeArea(
        child: Drawer(
          backgroundColor: Colors.blue.shade400,
          child: FirebaseAnimatedList(query: user, itemBuilder: (context,snapshot,animation,index){
            return Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                CircleAvatar(
                  maxRadius: 50,
                  child: Image.asset("assets/images/img.png"),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(snapshot
                    .child("UserName")
                    .value
                    .toString(),style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),

              ],
            );
        
          }),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(
              defaultChild: Center(child: CircularProgressIndicator(
                strokeWidth: 4,
              )),
                query: ref,
                itemBuilder: (context, snapshot, animation, index) {
                  return ListTile(
                    trailing: PopupMenuButton(
                        icon: Icon(Icons.more_vert),
                        itemBuilder: (context) =>
                        [
                          PopupMenuItem(
                              child: ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  showdialogue(snapshot
                                      .child("title")
                                      .value
                                      .toString(), snapshot
                                      .child("id")
                                      .value
                                      .toString());
                                },
                                leading: Icon(Icons.edit),
                                title: Text("Update"),

                              )),
                          PopupMenuItem(child:ListTile(
                            onTap: (){
                              Navigator.pop(context);
                             ref.child(snapshot.child("id").value.toString()).remove();
                            },
                            leading:Icon(Icons.delete),
                            title: Text("Delete"),
                          ))
                        ]),
                    title: Text(snapshot
                        .child("title")
                        .value
                        .toString()),
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

  Future<void> showdialogue(String title, String id) {
    updateController.text = title.toString();
    return showDialog(context: context, builder: (BuildContext context) {
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
          TextButton(onPressed: () {
            Navigator.pop(context);
          }, child: Text("Cancel")),
          TextButton(onPressed: () {
            ref.child(id).update({
              "title": updateController.text.toString(),
            });
            Navigator.pop(context);
          }, child: Text("Update"),)
        ],

      );
    });
  }
}


