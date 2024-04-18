import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebasetrial/Button/RoundButton.dart';
import 'package:firebasetrial/Utils/Utilities.dart';
import 'package:flutter/material.dart';
class AddPost extends StatefulWidget {

  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool loading=false;
  final PostController=TextEditingController();
  final auth=FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(child: Text("Add Post",style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            TextFormField(
              controller: PostController,
              maxLines: 4,
                decoration: InputDecoration(
                hintText: "Enter the Post",
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RoundButton(
                loading:loading,
                title: "Post", onTap: (){
                  setState(() {
                    loading=true;
                  });
              final user=auth.currentUser;
              final uid=user!.uid;
              final databaseref=FirebaseDatabase.instance.ref(uid);
              String id=DateTime.now().millisecondsSinceEpoch.toString();
              databaseref.child(id).set({
                "title":PostController.text.toString(),
                "id":id,
              }).then((value) {
                setState(() {
                  loading=false;
                });
                Utils().toastMessage("Post Added Successfully");

              }).onError((error, stackTrace) {
                setState(() {
                  loading=false;
                });
                Utils().toastMessage(error.toString());
              });


            })

          ],
        ),
      ),
    );
  }
}
