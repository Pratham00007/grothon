import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShopKeeperAuthenticationService {
  // for storing data in cloud
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // for auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // for signup
  Future<String> SignupShop({
    required String email,
    required String password,
    required String shopName,
    required String shopAddress,
    required String phone_num,
  }) async {
    String res = "Some Error Occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          shopName.isNotEmpty ||
          shopAddress.isNotEmpty ||
          phone_num.isNotEmpty) {
        // register with email and password
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        // add user to cloud
        await _firestore.collection("shopkeeper").doc(credential.user!.uid).set({
          'name': shopName,
          'email': email,
          'pass': password,
          'address': shopAddress,
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

  Future<String> loginShopkeeper({
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
