// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fauth;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:notify/services/classes/notify_notification.dart';
import 'package:notify/services/classes/notify_user.dart';
import 'package:notify/services/notifications_service.dart';

/// The Service Adapter is a layer between the [fauth.FirebaseAuth] and
/// [FirebaseFirestore] services. Allows you to put the logic of operations into
/// separate functions.
class FirebaseService {
  factory FirebaseService() => instance;
  const FirebaseService._();
  static const FirebaseService instance = FirebaseService._();
  static fauth.FirebaseAuth auth = fauth.FirebaseAuth.instance;
  static FirebaseFirestore store = FirebaseFirestore.instance;
  static String get currentUserId => auth.currentUser!.uid;

  /// Monitors the authorization status of the current [fauth.User]
  Stream<fauth.User?> get currentUser => auth.authStateChanges();

  /// Authorizes the user by [email] and [password].
  /// If something goes wrong, function to throw
  /// an [fauth.FirebaseAuthException].
  static Future<void> signIn({
    required final String email,
    required final String password,
  }) async =>
      auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

  /// Allows you to authorize the user.
  /// If something goes wrong, function to throw
  /// an [fauth.FirebaseAuthException].
  static Future<void> signUp({
    required final String email,
    required final String password,
    required final String firstName,
    required final String lastName,
    required final Color color,
  }) async {
    final fauth.UserCredential ucred =
        await auth.createUserWithEmailAndPassword(
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
      'notification_ids': <String>[],
    });
  }

  /// Disconnects the user from the [auth].
  static Future<void> signOut() => auth.signOut();

  /// Getting the user's model by its uid.
  static DocumentReference<NotifyUser> selectUser([final String? uid]) =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid ?? currentUserId)
          .withConverter(
            fromFirestore: (
              final DocumentSnapshot<Map<String, dynamic>> snapshot,
              final SnapshotOptions? _,
            ) =>
                NotifyUser.fromFirebaseDocumentSnapshot(snapshot),
            toFirestore: (
              final NotifyUser value,
              final SetOptions? _,
            ) =>
                value.toJson(),
          );

  /// Getting a list of users by list of their uids
  static Future<List<NotifyUser>> getUsersListFromUsersUidList(
    final List<String> uids,
  ) async {
    final List<NotifyUser> result = <NotifyUser>[];
    for (final String uid in uids) {
      result.add(
        await selectUser(uid)
            .get()
            .then((final DocumentSnapshot<NotifyUser> value) => value.data()!),
      );
    }
    return result;
  }

  /// The function allows you to find out whether the user
  /// is subscribed to the another user (with uid = [to])
  static Future<bool> checkFollowed(final String to) async {
    final String from = currentUserId;
    final bool check1 = (await FirebaseFirestore.instance
            .collection('relations')
            .where('user1', isEqualTo: from)
            .where('user2', isEqualTo: to)
            .where('user1_accept', isEqualTo: true)
            .get())
        .docs
        .isNotEmpty;
    if (check1) {
      return true;
    }
    final bool check2 = (await FirebaseFirestore.instance
            .collection('relations')
            .where('user1', isEqualTo: to)
            .where('user2', isEqualTo: from)
            .where('user2_accept', isEqualTo: true)
            .get())
        .docs
        .isNotEmpty;
    if (check2) {
      return true;
    }
    return false;
  }

  /// Getting all the uids that are subscribed to the user
  static Future<List<NotifyUser>> getFollowersFromUser(final String uid) async {
    final List<String> query1 = (await FirebaseFirestore.instance
            .collection('relations')
            .where('user1', isEqualTo: uid)
            .where('user1_accept', isEqualTo: false)
            .where('user2_accept', isEqualTo: true)
            .get())
        .docs
        .map(
          (final QueryDocumentSnapshot<Object?> e) => e['user2'] as String,
        )
        .toList();

    final List<String> query2 = (await FirebaseFirestore.instance
            .collection('relations')
            .where('user2', isEqualTo: uid)
            .where('user2_accept', isEqualTo: false)
            .where('user1_accept', isEqualTo: true)
            .get())
        .docs
        .map(
          (final QueryDocumentSnapshot<Map<String, dynamic>> e) =>
              e['user1'] as String,
        )
        .toList();

    return getUsersListFromUsersUidList(query1 + query2);
  }

  /// Getting all the uids that the user is subscribed to
  static Future<List<NotifyUser>> getFollowingFromUser(final String uid) async {
    final List<String> query1 = (await FirebaseFirestore.instance
            .collection('relations')
            .where('user1', isEqualTo: uid)
            .where('user1_accept', isEqualTo: true)
            .where('user2_accept', isEqualTo: false)
            .get())
        .docs
        .map(
          (final QueryDocumentSnapshot<Map<String, dynamic>> e) =>
              e['user2'] as String,
        )
        .toList();

    final List<String> query2 = (await FirebaseFirestore.instance
            .collection('relations')
            .where('user2', isEqualTo: uid)
            .where('user2_accept', isEqualTo: true)
            .where('user1_accept', isEqualTo: false)
            .get())
        .docs
        .map(
          (final QueryDocumentSnapshot<Map<String, dynamic>> e) =>
              e['user1'] as String,
        )
        .toList();

    return getUsersListFromUsersUidList(query1 + query2);
  }

  /// Getting all colleagues uids with user
  static Future<List<NotifyUser>> getColleguesFromUser(final String uid) async {
    final List<String> query1 = (await FirebaseFirestore.instance
            .collection('relations')
            .where('user1', isEqualTo: uid)
            .where('user1_accept', isEqualTo: true)
            .where('user2_accept', isEqualTo: true)
            .get())
        .docs
        .map(
          (final QueryDocumentSnapshot<Map<String, dynamic>> e) =>
              e['user2'] as String,
        )
        .toList();

    final List<String> query2 = (await FirebaseFirestore.instance
            .collection('relations')
            .where('user2', isEqualTo: uid)
            .where('user2_accept', isEqualTo: true)
            .where('user1_accept', isEqualTo: true)
            .get())
        .docs
        .map(
          (final QueryDocumentSnapshot<Map<String, dynamic>> e) =>
              e['user1'] as String,
        )
        .toList();
    return getUsersListFromUsersUidList(query1 + query2);
  }

  /// Changing the status of a "subscription" with a user
  static Future<void> followSwitch(final String to) async {
    final String from = auth.currentUser!.uid;
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
  static Future<List<String>> searchFromUsers(final String pattern) async {
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
  static Future<void> createNotification({
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
      'owner': currentUserId,
      'id': Random().nextInt(2147483648),
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .update(<String, dynamic>{
      'notification_ids': FieldValue.arrayUnion(<String>[doc.id]),
    });
  }

  /// The function of receiving notification by id
  static DocumentReference<NotifyNotification> selectNotification(
    final String uid,
  ) =>
      FirebaseFirestore.instance
          .collection('notifications')
          .doc(uid)
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
          );

  /// A method that will send absolutely all the notifications that the user has
  static Stream<List<NotifyNotification>> getMyNotifications() => selectUser()
          .snapshots()
          .asyncMap((final DocumentSnapshot<NotifyUser> doc) async {
        final NotifyUser user = doc.data()!;
        await NotificationService().clearAllNotification();
        final List<NotifyNotification> ntfs = <NotifyNotification>[];
        for (final String id in user.notificationIds) {
          final DocumentSnapshot<NotifyNotification> doc =
              await selectNotification(id).get();
          final NotifyNotification ntf = doc.data()!;
          ntfs.add(ntf);
          if (ntf.deadline.isAfter(DateTime.now())) {
            await NotificationService().schedule(ntf);
          }
        }
        ntfs.sort(
          (
            final NotifyNotification a,
            final NotifyNotification b,
          ) =>
              b.deadline.compareTo(a.deadline),
        );
        return ntfs;
      });

  /// Deletes the notification.
  /// If the current user is the owner, then the notification will be deleted
  /// from all users, otherwise only the current one.
  static Future<void> deleteNotification(final NotifyNotification ntf) async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(ntf.uid)
        .delete();
    if (ntf.owner == currentUserId) {
      final List<String> userIds = (await FirebaseFirestore.instance
              .collection('users')
              .where('notification_ids', arrayContains: ntf.uid)
              .get())
          .docs
          .map((final QueryDocumentSnapshot<dynamic> e) => e.id)
          .toList();
      for (final String userId in userIds) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update(<String, dynamic>{
          'notification_ids': FieldValue.arrayRemove(<String>[ntf.uid])
        });
      }
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .update(<String, dynamic>{
        'notification_ids': FieldValue.arrayRemove(<String>[ntf.uid])
      });
    }
  }
}
