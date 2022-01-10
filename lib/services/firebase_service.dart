import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fauth;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:notify/services/classes/notify_notification.dart';
import 'package:notify/services/classes/notify_user.dart';
import 'package:notify/static_methods/combine_latest_streams.dart';
import 'package:provider/provider.dart';

/// The Service Adapter is a layer between the [fauth.FirebaseAuth] and
/// [FirebaseFirestore] services. Allows you to put the logic of operations into
/// separate functions.
class FirebaseService {
  final fauth.FirebaseAuth _firebaseAuth = fauth.FirebaseAuth.instance;

  /// Allows you to access the [FirebaseService] through the [context]
  /// Example: FirebaseService.of(context)

  static FirebaseService of(final BuildContext context) =>
      context.read<FirebaseService>();

  /// Monitors the authorization status of the current [fauth.User]
  Stream<fauth.User?> get currentUser => _firebaseAuth.authStateChanges();

  /// Authorizes the user by [email] and [password].
  /// Returns an error message if something happened, or null.
  Future<String?> signIn({
    required final String email,
    required final String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on fauth.FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  /// Allows you to authorize the user.
  /// Returns an error message if something happened, or null.
  Future<String?> signUp({
    required final String email,
    required final String password,
    required final String firstName,
    required final String lastName,
    required final Color color,
  }) async {
    try {
      final fauth.UserCredential ucred =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final DateTime dtn = DateTime.now();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(ucred.user!.uid)
          .set(<String, dynamic>{
        'first_name': firstName,
        'last_name': lastName,
        'color_r': color.red,
        'color_g': color.green,
        'color_b': color.blue,
        'status': 'Hello! I have been using notify since '
            '${DateFormat.MMMM().format(dtn)} '
            '${dtn.day}, ${dtn.year}!',
      });
      return null;
    } on fauth.FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  /// Disconnects the user from the [_firebaseAuth]
  Future<void> signOut() => _firebaseAuth.signOut();

  /// Getting user information
  Stream<NotifyUser> getInfoAboutUser(
    final String uid,
  ) =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .withConverter(
            fromFirestore: (
              final DocumentSnapshot<Map<String, dynamic>> snapshot,
              final SnapshotOptions? options,
            ) =>
                NotifyUser.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (final NotifyUser value, final SetOptions? options) =>
                value.toJson(),
          )
          .snapshots()
          .map((final DocumentSnapshot<NotifyUser> event) => event.data()!);

  /// Updating user information
  Future<void> updateInfoAboutUser(
    final Map<String, Object?> newData,
  ) =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .update(newData);

  /// Getting a list of users by having a list of their uids
  Future<List<NotifyUser>> getUsersListFromUsersUidList(
    final List<String> uids,
  ) async {
    if (uids.isEmpty) {
      return <NotifyUser>[];
    }
    final QuerySnapshot<NotifyUser> a = await FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, whereIn: uids)
        .withConverter(
          fromFirestore: (
            final DocumentSnapshot<Map<String, dynamic>> snapshot,
            final SnapshotOptions? options,
          ) =>
              NotifyUser.fromJson(snapshot.data()!, snapshot.id),
          toFirestore: (final NotifyUser value, final SetOptions? options) =>
              value.toJson(),
        )
        .get();
    return Future<List<NotifyUser>>.value(
      a.docs
          .map((final QueryDocumentSnapshot<NotifyUser> e) => e.data())
          .toList(),
    );
  }

  /// Calculates the number of subscriptions the user has
  Stream<bool> checkFollowed(final String from, final String to) {
    final Stream<bool> stream1 = FirebaseFirestore.instance
        .collection('relations')
        .where('user1', isEqualTo: from)
        .where('user2', isEqualTo: to)
        .where('user1_accept', isEqualTo: true)
        .snapshots()
        .map(
          (final QuerySnapshot<Map<String, dynamic>> event) =>
              event.docs.isNotEmpty,
        );
    final Stream<bool> stream2 = FirebaseFirestore.instance
        .collection('relations')
        .where('user1', isEqualTo: to)
        .where('user2', isEqualTo: from)
        .where('user2_accept', isEqualTo: true)
        .snapshots()
        .map(
          (final QuerySnapshot<Map<String, dynamic>> event) =>
              event.docs.isNotEmpty,
        );
    return combineLatestStreams<bool>(<Stream<bool>>[stream1, stream2]).map(
      (final List<bool> event) => event[0] || event[1],
    );
  }

  /// Getting all the uids that are subscribed to the user
  Stream<List<NotifyUser>> getFollowersFromUser(final String uid) {
    final Stream<List<String>> stream1 = FirebaseFirestore.instance
        .collection('relations')
        .where('user1', isEqualTo: uid)
        .where('user1_accept', isEqualTo: false)
        .where('user2_accept', isEqualTo: true)
        .snapshots()
        .map(
          (final QuerySnapshot<Map<String, dynamic>> event) => event.docs
              .map(
                (final QueryDocumentSnapshot<Map<String, dynamic>> e) =>
                    e['user2'] as String,
              )
              .toList(),
        );
    final Stream<List<String>> stream2 = FirebaseFirestore.instance
        .collection('relations')
        .where('user2', isEqualTo: uid)
        .where('user2_accept', isEqualTo: false)
        .where('user1_accept', isEqualTo: true)
        .snapshots()
        .map(
          (final QuerySnapshot<Map<String, dynamic>> event) => event.docs
              .map(
                (final QueryDocumentSnapshot<Map<String, dynamic>> e) =>
                    e['user1'] as String,
              )
              .toList(),
        );

    return combineLatestStreams<List<String>>(
      <Stream<List<String>>>[stream1, stream2],
    ).map((final List<List<String>> event) => event[0] + event[1]).asyncMap(
          (final List<String> event) async =>
              getUsersListFromUsersUidList(event),
        );
  }

  /// Getting all the uids that the user is subscribed to
  Stream<List<NotifyUser>> getFollowingFromUser(final String uid) {
    final Stream<List<String>> stream1 = FirebaseFirestore.instance
        .collection('relations')
        .where('user1', isEqualTo: uid)
        .where('user1_accept', isEqualTo: true)
        .where('user2_accept', isEqualTo: false)
        .snapshots()
        .map(
          (final QuerySnapshot<Map<String, dynamic>> event) => event.docs
              .map(
                (final QueryDocumentSnapshot<Map<String, dynamic>> e) =>
                    e['user2'] as String,
              )
              .toList(),
        );
    final Stream<List<String>> stream2 = FirebaseFirestore.instance
        .collection('relations')
        .where('user2', isEqualTo: uid)
        .where('user2_accept', isEqualTo: true)
        .where('user1_accept', isEqualTo: false)
        .snapshots()
        .map(
          (final QuerySnapshot<Map<String, dynamic>> event) => event.docs
              .map(
                (final QueryDocumentSnapshot<Map<String, dynamic>> e) =>
                    e['user1'] as String,
              )
              .toList(),
        );
    return combineLatestStreams<List<String>>(
      <Stream<List<String>>>[stream1, stream2],
    )
        .map((final List<List<String>> event) => event[0] + event[1])
        .asyncMap(
          (final List<String> event) async =>
              getUsersListFromUsersUidList(event),
        )
        .asBroadcastStream();
  }

  /// Getting all colleagues uids with user
  Stream<List<NotifyUser>> getColleguesFromUser(final String uid) {
    final Stream<List<String>> stream1 = FirebaseFirestore.instance
        .collection('relations')
        .where('user1', isEqualTo: uid)
        .where('user1_accept', isEqualTo: true)
        .where('user2_accept', isEqualTo: true)
        .snapshots()
        .map(
          (final QuerySnapshot<Map<String, dynamic>> event) => event.docs
              .map(
                (final QueryDocumentSnapshot<Map<String, dynamic>> e) =>
                    e['user2'] as String,
              )
              .toList(),
        );
    final Stream<List<String>> stream2 = FirebaseFirestore.instance
        .collection('relations')
        .where('user2', isEqualTo: uid)
        .where('user2_accept', isEqualTo: true)
        .where('user1_accept', isEqualTo: true)
        .snapshots()
        .map(
          (final QuerySnapshot<Map<String, dynamic>> event) => event.docs
              .map(
                (final QueryDocumentSnapshot<Map<String, dynamic>> e) =>
                    e['user1'] as String,
              )
              .toList(),
        );
    final Stream<List<String>> resultStream =
        combineLatestStreams<List<String>>(
      <Stream<List<String>>>[stream1, stream2],
    ).map((final List<List<String>> event) => event[0] + event[1]);
    return resultStream.asyncMap(
      (final List<String> event) async => getUsersListFromUsersUidList(event),
    );
  }

  /// Changing the status of a "subscription" with a user
  Future<void> followSwitch(final String to) async {
    final String from = _firebaseAuth.currentUser!.uid;
    QuerySnapshot<Map<String, dynamic>> out = await FirebaseFirestore.instance
        .collection('relations')
        .where('user1', isEqualTo: from)
        .where('user2', isEqualTo: to)
        .get();
    if (out.docs.isNotEmpty) {
      final Map<String, dynamic> data = (await FirebaseFirestore.instance
              .collection('relations')
              .doc(out.docs[0].id)
              .get())
          .data()!;
      if (data['user1_accept'] == true && data['user2_accept'] == false) {
        return FirebaseFirestore.instance
            .collection('relations')
            .doc(out.docs[0].id)
            .delete();
      }
      final bool oldValue = out.docs[0].data()['user1_accept'];
      return FirebaseFirestore.instance
          .collection('relations')
          .doc(out.docs[0].id)
          .update(<String, bool>{'user1_accept': !oldValue});
    }
    out = await FirebaseFirestore.instance
        .collection('relations')
        .where('user2', isEqualTo: from)
        .where('user1', isEqualTo: to)
        .get();
    if (out.docs.isNotEmpty) {
      final Map<String, dynamic> data = (await FirebaseFirestore.instance
              .collection('relations')
              .doc(out.docs[0].id)
              .get())
          .data()!;
      if (data['user2_accept'] == true && data['user1_accept'] == false) {
        return FirebaseFirestore.instance
            .collection('relations')
            .doc(out.docs[0].id)
            .delete();
      }
      final bool oldValue = out.docs[0].data()['user2_accept'];
      return FirebaseFirestore.instance
          .collection('relations')
          .doc(out.docs[0].id)
          .update(<String, bool>{'user2_accept': !oldValue});
    }
    await FirebaseFirestore.instance
        .collection('relations')
        .add(<String, dynamic>{
      'user1': from,
      'user1_accept': true,
      'user2': to,
      'user2_accept': false,
    });
  }

  /// Search for a user from all by [pattern]
  Future<List<String>> searchFromUsers(final String pattern) async {
    final Set<String> mainSet = <String>{};
    final Iterable<String> elements1 = (await FirebaseFirestore.instance
            .collection('users')
            .where('first_name', isGreaterThanOrEqualTo: pattern)
            .where('first_name', isLessThanOrEqualTo: '$pattern\uf8ff')
            .limit(10)
            .get())
        .docs
        .map(
          (final QueryDocumentSnapshot<Object?> e) => e.id,
        );
    mainSet.addAll(elements1);
    final Iterable<String> elements2 = (await FirebaseFirestore.instance
            .collection('users')
            .where('first_name', isGreaterThanOrEqualTo: pattern.toLowerCase())
            .where(
              'first_name',
              isLessThanOrEqualTo: '${pattern.toLowerCase()}\uf8ff',
            )
            .limit(10)
            .get())
        .docs
        .map((final QueryDocumentSnapshot<Object?> e) => e.id);
    mainSet.addAll(elements2);
    final Iterable<String> elements3 = (await FirebaseFirestore.instance
            .collection('users')
            .where('first_name', isGreaterThanOrEqualTo: pattern.toUpperCase())
            .where(
              'first_name',
              isLessThanOrEqualTo: '${pattern.toUpperCase()}\uf8ff',
            )
            .limit(10)
            .get())
        .docs
        .map((final QueryDocumentSnapshot<Object?> e) => e.id);
    mainSet.addAll(elements3);
    final Iterable<String> elements4 = (await FirebaseFirestore.instance
            .collection('users')
            .where('last_name', isGreaterThanOrEqualTo: pattern)
            .where('last_name', isLessThanOrEqualTo: '$pattern\uf8ff')
            .limit(10)
            .get())
        .docs
        .map((final QueryDocumentSnapshot<Object?> e) => e.id);
    mainSet.addAll(elements4);
    final Iterable<String> elements5 = (await FirebaseFirestore.instance
            .collection('users')
            .where('last_name', isGreaterThanOrEqualTo: pattern.toLowerCase())
            .where(
              'last_name',
              isLessThanOrEqualTo: '${pattern.toLowerCase()}\uf8ff',
            )
            .limit(10)
            .get())
        .docs
        .map((final QueryDocumentSnapshot<Object?> e) => e.id);
    mainSet.addAll(elements5);
    final List<String> elements6 = (await FirebaseFirestore.instance
            .collection('users')
            .where('last_name', isGreaterThanOrEqualTo: pattern.toUpperCase())
            .where(
              'last_name',
              isLessThanOrEqualTo: '${pattern.toUpperCase()}\uf8ff',
            )
            .limit(10)
            .get())
        .docs
        .map((final QueryDocumentSnapshot<Object?> e) => e.id)
        .toList();
    mainSet.addAll(elements6);
    return mainSet.toList();
  }

  /// A function for creating notifications.
  /// repeat:
  /// 0 - One-time
  /// 1 - Everyday
  /// 2 - Everyweek
  /// 3 - Everymonth
  /// 4 - Everyyear
  Future<void> createNotification({
    required final String title,
    required final DateTime deadline,
    required final bool priority,
    required final int repeat,
    final String description = '',
  }) async {
    final DocumentReference<dynamic> doc = await FirebaseFirestore.instance
        .collection('notifications')
        .add(<String, dynamic>{
      'title': title,
      'description': description,
      'deadline': deadline,
      'priority': priority,
      'repeat': repeat,
      'owner': _firebaseAuth.currentUser!.uid,
    });
    await FirebaseFirestore.instance
        .collection('relations_ntf_user')
        .add(<String, dynamic>{
      'user_uid': _firebaseAuth.currentUser!.uid,
      'ntf_uid': doc.id
    });
  }

  /// The function of receiving notification by id
  Future<NotifyNotification> getNotificationFromId(final String uid) async =>
      (await FirebaseFirestore.instance
              .collection('notifications')
              .withConverter(
                fromFirestore: (
                  final DocumentSnapshot<Map<String, dynamic>> snapshot,
                  final SnapshotOptions? options,
                ) =>
                    NotifyNotification.fromFirebaseDocumentSnapshot(snapshot),
                toFirestore: (
                  final NotifyNotification value,
                  final SetOptions? options,
                ) =>
                    value.toJson(),
              )
              .where(FieldPath.documentId, isEqualTo: uid)
              .get())
          .docs[0]
          .data();

  /// A function for getting all the reminders that the user can get
  Stream<List<NotifyNotification>> getMyNotificationsSnapshot() =>
      FirebaseFirestore.instance
          .collection('relations_ntf_user')
          .where('user_uid', isEqualTo: _firebaseAuth.currentUser!.uid)
          .snapshots()
          .asyncMap((final QuerySnapshot<Map<String, dynamic>> event) async {
        final List<NotifyNotification> result = <NotifyNotification>[];
        for (int i = 0; i < event.docs.length; i++) {
          result.add(
            await getNotificationFromId(
              event.docs[i].data()['ntf_uid'],
            ),
          );
        }
        return result;
      });
}
