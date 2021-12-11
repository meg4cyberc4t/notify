import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fauth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:notify/services/notify_user.dart';

class FirebaseService {
  final fauth.FirebaseAuth _firebaseAuth;
  FirebaseService(this._firebaseAuth);

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

  Future<void> signOut() => _firebaseAuth.signOut();

  Stream<DocumentSnapshot<Map<String, dynamic>>> getInfoAboutUser(String uid) =>
      FirebaseFirestore.instance.collection('users').doc(uid).snapshots();

  Future<void> updateInfoAboutUser(String uid, Map<String, Object?> data) =>
      FirebaseFirestore.instance.collection('users').doc(uid).update(data);

  Future<List<NotifyUser>> getUsersListFromUsersUidList(
      List<String> uids) async {
    if (uids.isEmpty) {
      return Future.value([]);
    }
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, whereIn: uids)
        .get();
    return Future.value(snapshot.docs.map((e) {
      Map<String, dynamic> data = e.data() as Map<String, dynamic>;
      return NotifyUser(
        uid: e.id,
        firstName: data['first_name'],
        lastName: data['last_name'],
        color: Color.fromRGBO(
          data['color_r'],
          data['color_g'],
          data['color_b'],
          1,
        ),
        status: data['status'],
      );
    }).toList());
  }

  Future<List<NotifyUser>> getFollowersFromUser(String uid) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('relations')
        .where("to", isEqualTo: uid)
        .get();
    return getUsersListFromUsersUidList(
        snapshot.docs.map((e) => e['from'] as String).toList());
  }

  Future<List<NotifyUser>> getFollowingFromUser(String uid) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('relations')
        .where("from", isEqualTo: uid)
        .get();
    return getUsersListFromUsersUidList(
        snapshot.docs.map((e) => e['to'] as String).toList());
  }

  Future<List<NotifyUser>> getColleguesFromUser(String uid) async {
    var followers = await getFollowersFromUser(uid);
    var following = await getFollowingFromUser(uid);
    List<NotifyUser> answers = <NotifyUser>[];
    for (var user1 in following) {
      for (var user2 in followers) {
        if (user1.uid == user2.uid) {
          answers.add(user1);
        }
      }
    }
    return Future.value(answers);
  }
}
