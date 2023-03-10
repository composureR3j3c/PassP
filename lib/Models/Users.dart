import 'package:firebase_database/firebase_database.dart';

class UserModel{

  String? id;
  String? email;
  String? name;
  String? lname;
  String? phone;

   UserModel({  this.id, this.lname, this.email, this.name, this.phone});

   UserModel.fromSnapshot(DataSnapshot dataSnapshot){
     id=dataSnapshot.key!;
     email=(dataSnapshot.value as dynamic)["email"];
     name=(dataSnapshot.value as dynamic)["name"];
     phone=(dataSnapshot.value as dynamic)["phone"];
   }

}