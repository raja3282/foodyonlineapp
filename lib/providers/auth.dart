import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Authentication with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  DocumentSnapshot snapshot;

  createUserRecord(email, name, password) {
    try {
      db
          .collection('onlineusers')
          .doc(email)
          .set({'name': name, 'email': email, 'password': password});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<DocumentSnapshot> getUsereDtails() async {
    DocumentSnapshot result =
        await db.collection('onlineusers').doc(_auth.currentUser.email).get();
    this.snapshot = result;
    notifyListeners();

    return result;
  }
}
