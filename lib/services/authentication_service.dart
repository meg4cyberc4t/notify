import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fauth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AuthenticationService {
  final fauth.FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);

  Stream<fauth.User?> get currentUser => _firebaseAuth.authStateChanges();

  Future<String?> signIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return null;
    } on fauth.FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required Color color,
  }) async {
    try {
      fauth.UserCredential ucred = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      FirebaseFirestore store = FirebaseFirestore.instance;
      DateTime dtn = DateTime.now();
      await store.collection('users').doc(ucred.user!.uid).set({
        'first_name': firstName,
        'last_name': lastName,
        'color_r': color.red,
        'color_g': color.green,
        'color_b': color.blue,
        'status':
            "Hello! I have been using notify since  ${DateFormat.MMMM().format(dtn)} ${dtn.day}, ${dtn.year}!",
      });
      return null;
    } on fauth.FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> signOut() async => await _firebaseAuth.signOut();
}
