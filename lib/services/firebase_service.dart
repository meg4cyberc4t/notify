import "dart:async";
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fauth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:notify/components/methods/combine_latest_streams.dart';
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

  Stream<bool> checkFollowed(String from, String to) {
    Stream<bool> stream1 = FirebaseFirestore.instance
        .collection('relations')
        .where('user1', isEqualTo: from)
        .where('user2', isEqualTo: to)
        .where('user1_accept', isEqualTo: true)
        .snapshots()
        .map((event) => event.docs.isNotEmpty);
    Stream<bool> stream2 = FirebaseFirestore.instance
        .collection('relations')
        .where('user1', isEqualTo: to)
        .where('user2', isEqualTo: from)
        .where('user2_accept', isEqualTo: true)
        .snapshots()
        .map((event) => event.docs.isNotEmpty);
    return combineLatestStreams([stream1, stream2])
        .map((event) => event[0] || event[1]);
  }

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
    return combineLatestStreams([stream1, stream2])
        .map((event) => event[0] + event[1]);
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
    return combineLatestStreams([stream1, stream2])
        .map((event) => event[0] + event[1]);
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
    return combineLatestStreams([stream1, stream2])
        .map((event) => event[0] + event[1]);
  }

  Future<void> followSwitch(String to) async {
    String from = _firebaseAuth.currentUser!.uid;
    QuerySnapshot<Map<String, dynamic>> out = await FirebaseFirestore.instance
        .collection('relations')
        .where('user1', isEqualTo: from)
        .where('user2', isEqualTo: to)
        .get();
    if (out.docs.isNotEmpty) {
      Map<String, dynamic> data = (await FirebaseFirestore.instance
              .collection('relations')
              .doc(out.docs[0].id)
              .get())
          .data() as Map<String, dynamic>;
      if (data['user1_accept'] == true && data['user2_accept'] == false) {
        return FirebaseFirestore.instance
            .collection('relations')
            .doc(out.docs[0].id)
            .delete();
      }
      return FirebaseFirestore.instance
          .collection('relations')
          .doc(out.docs[0].id)
          .update({"user1_accept": !out.docs[0].data()["user1_accept"]});
    }
    out = await FirebaseFirestore.instance
        .collection('relations')
        .where('user2', isEqualTo: from)
        .where('user1', isEqualTo: to)
        .get();
    if (out.docs.isNotEmpty) {
      Map<String, dynamic> data = (await FirebaseFirestore.instance
              .collection('relations')
              .doc(out.docs[0].id)
              .get())
          .data() as Map<String, dynamic>;
      if (data['user2_accept'] == true && data['user1_accept'] == false) {
        return FirebaseFirestore.instance
            .collection('relations')
            .doc(out.docs[0].id)
            .delete();
      }
      return FirebaseFirestore.instance
          .collection('relations')
          .doc(out.docs[0].id)
          .update({"user2_accept": !out.docs[0].data()["user2_accept"]});
    }
    FirebaseFirestore.instance.collection('relations').add({
      "user1": from,
      "user1_accept": true,
      "user2": to,
      "user2_accept": false,
    });
  }

  Future<List<String>> searchFromUsers(String pattern) async {
    Set<String> mainSet = <String>{};
    var elements1 = (await FirebaseFirestore.instance
            .collection('users')
            .where('first_name', isGreaterThanOrEqualTo: pattern)
            .where('first_name', isLessThanOrEqualTo: pattern + "\uf8ff")
            .limit(10)
            .get())
        .docs
        .map((QueryDocumentSnapshot e) => e.id)
        .toList();
    mainSet.addAll(elements1);
    if (mainSet.length >= 10) {
      return mainSet.toList();
    }
    var elements2 = (await FirebaseFirestore.instance
            .collection('users')
            .where('first_name', isGreaterThanOrEqualTo: pattern.toLowerCase())
            .where('first_name',
                isLessThanOrEqualTo: pattern.toLowerCase() + "\uf8ff")
            .limit(10)
            .get())
        .docs
        .map((QueryDocumentSnapshot e) => e.id)
        .toList();
    mainSet.addAll(elements2);
    if (mainSet.length >= 10) {
      return mainSet.toList();
    }
    var elements3 = (await FirebaseFirestore.instance
            .collection('users')
            .where('first_name', isGreaterThanOrEqualTo: pattern.toUpperCase())
            .where('first_name',
                isLessThanOrEqualTo: pattern.toUpperCase() + "\uf8ff")
            .limit(10)
            .get())
        .docs
        .map((QueryDocumentSnapshot e) => e.id)
        .toList();
    mainSet.addAll(elements3);
    if (mainSet.length >= 10) {
      return mainSet.toList();
    }
    var elements4 = (await FirebaseFirestore.instance
            .collection('users')
            .where('last_name', isGreaterThanOrEqualTo: pattern)
            .where('last_name', isLessThanOrEqualTo: pattern + "\uf8ff")
            .limit(10)
            .get())
        .docs
        .map((QueryDocumentSnapshot e) => e.id)
        .toList();
    mainSet.addAll(elements4);
    if (mainSet.length >= 10) {
      return mainSet.toList();
    }
    var elements5 = (await FirebaseFirestore.instance
            .collection('users')
            .where('last_name', isGreaterThanOrEqualTo: pattern.toLowerCase())
            .where('last_name',
                isLessThanOrEqualTo: pattern.toLowerCase() + "\uf8ff")
            .limit(10)
            .get())
        .docs
        .map((QueryDocumentSnapshot e) => e.id)
        .toList();
    mainSet.addAll(elements5);
    if (mainSet.length >= 10) {
      return mainSet.toList();
    }
    var elements6 = (await FirebaseFirestore.instance
            .collection('users')
            .where('last_name', isGreaterThanOrEqualTo: pattern.toUpperCase())
            .where('last_name',
                isLessThanOrEqualTo: pattern.toUpperCase() + "\uf8ff")
            .limit(10)
            .get())
        .docs
        .map((QueryDocumentSnapshot e) => e.id)
        .toList();
    mainSet.addAll(elements6);
    return mainSet.toList();
  }
}
