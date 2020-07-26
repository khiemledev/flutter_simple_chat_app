import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;

  static Future<FirebaseUser> signIn({String email, String password}) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  static Future<FirebaseUser> currentUser() async {
    return await _auth.currentUser();
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static Future signUp({
    @required String email,
    @required String displayName,
    @required String password,
  }) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = result.user;

    final userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = displayName;
    await user.updateProfile(userUpdateInfo);

    return user;
  }
}
