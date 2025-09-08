import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shiv/consts/consts.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  Future<UserCredential?> loginMethod(context) async {
    UserCredential? userCredential;

    try {
      userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passController.text);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    if (userCredential != null) {
      currentUser = userCredential.user;
    }
    return userCredential;
  }

  Future<UserCredential?> signUpMethod({context, email, password}) async {
    UserCredential? userCredential;

    try {
      userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    currentUser = userCredential!.user;
    return userCredential;
  }

  storeUserData({name, password, email, uid}) async {
    DocumentReference store = firestore.collection(usersCollection).doc(uid);
    store.set({
      "id": uid,
      "name": name,
      "email": email,
      "password": password,
      "imageUrl": "",
      "cart_count": "0",
      "order_count": "0",
      "wishlist_count": "0",
    });
  }

  signOutMethod(context) async {
    try {
      await auth.signOut();
      currentUser = null;
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  getUserType(uid) async {
    return firestore.collection(usersCollection).doc(uid).get();
  }
}
