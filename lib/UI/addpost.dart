import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebasetrial/Button/RoundButton.dart';
import 'package:firebasetrial/Utils/Utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
class AddPost extends StatefulWidget {

  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  String? category;
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
         Text("Select the Mode You want to post the data",style: TextStyle(
           color: Colors.blueGrey,
           fontWeight: FontWeight.bold,
           fontSize:15,
         ),),
       Column(
         children: [
           ListTile(
             title: Text("Public"),
             leading: Radio(
                 value: "public",
                 groupValue: category,
                 onChanged: (value){
                   setState(() {
                     category=value.toString();
                   });
                 }),
           ),
           ListTile(
             title: Text("Private"),
             leading: Radio(
                 value: "private",
                 groupValue: category,
                 onChanged: (value){
                   setState(() {
                     category=value.toString();
                   });
                 }),
           )
         ],
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
             if(category=="private"){
               final user=auth.currentUser;
               final uid=user!.uid;
               final databaseref=FirebaseDatabase.instance.ref(uid);
               String id=DateTime.now().millisecondsSinceEpoch.toString();
               databaseref.child(id).set({
                 "title":PostController.text.toString(),
                 "id":id,
                 "time":DateTime.now().toString(),
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
             }
             else{
               final databaseref=FirebaseDatabase.instance.ref("Public");//creating the refefrence of the database
               String id=DateTime.now().millisecondsSinceEpoch.toString();
               databaseref.child(id).set({
                 "title":PostController.text.toString(),
                 "id":id,
                 "time":DateTime.now().toString(),
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

             }


            })

          ],
        ),
      ),
    );
  }
}
