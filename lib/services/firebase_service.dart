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
      return Future.value(<NotifyUser>[]);
    }
    return (await FirebaseFirestore.instance
            .collection('users')
            .where(FieldPath.documentId, whereIn: uids)
            .get())
        .docs
        .map((e) {
      Map<String, dynamic> data = e.data();
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
    }).toList();
  }

  Stream<List<String>> getFollowersFromUser(String uid) {
    return FirebaseFirestore.instance
        .collection('relations')
        .where('to', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((e) => e['from'] as String).toList();
    });
  }

  Stream<List<String>> getFollowingFromUser(String uid) {
    return FirebaseFirestore.instance
        .collection('relations')
        .where('from', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((e) => e['to'] as String).toList();
    });
  }

  Stream<Stream<List<String>>> getColleguesFromUser(String uid) {
    return getFollowersFromUser(uid).map((followers) {
      return getFollowingFromUser(uid).map((following) {
        List<String> answer = [];
        for (var user1 in followers) {
          for (var user2 in following) {
            if (user1 == user2 && !answer.contains(user1)) {
              answer.add(user1);
            }
          }
        }
        return answer;
      });
    });
  }
}
