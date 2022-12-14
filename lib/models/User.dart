import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class GoogleUser with ChangeNotifier {
  final googleAuthentiction = GoogleSignIn();

  GoogleSignInAccount? _googleUser;

  User? _user;

  GoogleSignInAccount get googleUser => _googleUser!;

  User get user => _user!;


  Future googleLogin() async {

    final googleUser = await googleAuthentiction.signIn();

    if (googleUser == null) return;

    _googleUser = googleUser;

    final googleAuth = await googleUser.authentication;
    print(googleUser.id);

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    _user = userCredential.user!;

    print(_user!.displayName);
    print(_user!.email);
    print(_user!.photoURL);
    print(_user!.uid);
    print(_user!.emailVerified);
    notifyListeners();
  }
}
