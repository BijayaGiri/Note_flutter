import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '../ID/uid.dart';
class privatenotes extends StatefulWidget {
  const privatenotes({super.key});

  @override
  State<privatenotes> createState() => _privatenotesState();
}

class _privatenotesState extends State<privatenotes> {
  final updateController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  //creating the instance of the Authentication
  final uid = UId().id();
  final ref = reference().Ref;
  final user = reference().usernameRef;
  final databaseref=reference().publicref;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(child: Text("Private Notes",style: TextStyle(
          color: Colors.white,
            fontWeight: FontWeight.bold,
        ),)),
      ),
      body:Column(
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
                    subtitle: Text(snapshot.child("time").value.toString()),
                  );
                }),
          )

        ],
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
