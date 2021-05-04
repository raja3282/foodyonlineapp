import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Authentication with ChangeNotifier {
  String uid;

  String get getUid => uid;

  final _auth = FirebaseAuth.instance;

  final db = FirebaseFirestore.instance;
  DocumentSnapshot snapshot;
  Future loginIntoAccount(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    User user = userCredential.user;
    uid = user.uid;
    print('This is user uid => $getUid');
    notifyListeners();
  }

  Future creteNewAccount(String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User user = userCredential.user;
    uid = user.uid;
    print('This is user uid => $getUid');
    notifyListeners();
  }

  createUserRecord(email, name, password) {
    try {
      db
          .collection('onlineusers')
          .doc(getUid)
          .set({'name': name, 'email': email, 'password': password});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<DocumentSnapshot> getUsereDtails() async {
    DocumentSnapshot result =
        await db.collection('onlineusers').doc(_auth.currentUser.uid).get();
    this.snapshot = result;
    notifyListeners();

    return result;
  }
}
