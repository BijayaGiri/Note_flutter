import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
final _auth=FirebaseAuth.instance;
class UId{
  String id(){
    final uid=_auth.currentUser!.uid;
    return uid;
  }
}
class reference{

  final Ref=FirebaseDatabase.instance.ref(_auth.currentUser!.uid);
  final usernameRef=FirebaseDatabase.instance.ref(_auth.currentUser!.uid+"username");

}
