import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserAuthenticationService {
  // for storing data in cloud
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // for auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // for signup
  Future<String> SignupUser({
    required String email,
    required String password,
    required String Name,
    required String Address,
    required String phone_num,
  }) async {
    String res = "Some Error Occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          Name.isNotEmpty ||
          Address.isNotEmpty ||
          phone_num.isNotEmpty) {
        // register with email and password
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        // add user to cloud
        await _firestore.collection("users").doc(credential.user!.uid).set({
          'name': Name,
          'email': email,
          'pass': password,
          'address': Address,
          'phone_num': phone_num,
          'uid': credential.user!.uid,
        });
        res = "Success";
      }
    } catch (e) {
      return e.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some Error Ouccured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // login user with email and password
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "Success";
      } else {
        res = "Please Enter All Fields";
      }
    } catch (e) {
      return e.toString();
    }
    return res;
  }

  // for Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
