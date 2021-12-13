import "dart:async";
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fauth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:notify/services/notify_user.dart';
import 'package:async/async.dart' show StreamZip;

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

  Stream<List<NotifyUser>> getUsersListFromUsersUidList(List<String> uids) {
    if (uids.isEmpty) {
      return Stream.value([]);
    }
    return FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, whereIn: uids)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((e) {
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
            }).toList());
  }

  Stream<List<String>> getFollowersFromUser(String uid) {
    Stream<List<String>> stream1 = FirebaseFirestore.instance
        .collection('relations')
        .where('user1', isEqualTo: uid)
        .where('user1_accept', isEqualTo: false)
        .where('user2_accept', isEqualTo: true)
        .snapshots()
        .map((event) => event.docs.map((e) => e['user2'] as String).toList());
    Stream<List<String>> stream2 = FirebaseFirestore.instance
        .collection('relations')
        .where('user2', isEqualTo: uid)
        .where('user2_accept', isEqualTo: false)
        .where('user1_accept', isEqualTo: true)
        .snapshots()
        .map((event) => event.docs.map((e) => e['user1'] as String).toList());
    return StreamZip([stream1, stream2]).map((event) => event[0] + event[1]);
  }

  Stream<List<String>> getFollowingFromUser(String uid) {
    Stream<List<String>> stream1 = FirebaseFirestore.instance
        .collection('relations')
        .where('user1', isEqualTo: uid)
        .where('user1_accept', isEqualTo: true)
        .where('user2_accept', isEqualTo: false)
        .snapshots()
        .map((event) => event.docs.map((e) => e['user2'] as String).toList());
    Stream<List<String>> stream2 = FirebaseFirestore.instance
        .collection('relations')
        .where('user2', isEqualTo: uid)
        .where('user2_accept', isEqualTo: true)
        .where('user1_accept', isEqualTo: false)
        .snapshots()
        .map((event) => event.docs.map((e) => e['user1'] as String).toList());
    return StreamZip([stream1, stream2]).map((event) => event[0] + event[1]);
  }

  Stream<List<String>> getColleguesFromUser(String uid) {
    Stream<List<String>> stream1 = FirebaseFirestore.instance
        .collection('relations')
        .where('user1', isEqualTo: uid)
        .where('user1_accept', isEqualTo: true)
        .where('user2_accept', isEqualTo: true)
        .snapshots()
        .map((event) => event.docs.map((e) => e['user2'] as String).toList());
    Stream<List<String>> stream2 = FirebaseFirestore.instance
        .collection('relations')
        .where('user2', isEqualTo: uid)
        .where('user2_accept', isEqualTo: true)
        .where('user1_accept', isEqualTo: true)
        .snapshots()
        .map((event) => event.docs.map((e) => e['user1'] as String).toList());
    return StreamZip([stream1, stream2]).map((event) => event[0] + event[1]);
  }
}
