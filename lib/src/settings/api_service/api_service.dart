import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notify/src/models/notify_folder_detailed.dart';
import 'package:notify/src/models/notify_notification_detailed.dart';
import 'package:notify/src/models/notify_notification_quick.dart';
import 'package:notify/src/models/notify_user_detailed.dart';
import 'package:notify/src/models/notify_user_quick.dart';
import 'package:notify/src/models/repeat_mode.dart';
import 'package:notify/src/settings/api_service/config.dart';
import 'package:notify/src/settings/api_service/middleware/errors_handler_middleware.dart';
import 'package:notify/src/settings/api_service/requests/folders_requests.dart';
import 'package:notify/src/settings/api_service/requests/notifications_requests.dart';
import 'package:notify/src/settings/api_service/requests/search_requests.dart';
import 'package:notify/src/settings/api_service/requests/user_requests.dart';
import 'package:notify/src/settings/api_service/requests/users_requests.dart';

class ApiService {
  static _ApiServiceUser get user => _ApiServiceUser();
  static _ApiServiceUsers get users => _ApiServiceUsers();
  static _ApiServiceSearch get search => _ApiServiceSearch();
  static _ApiServiceNotifications get notifications =>
      _ApiServiceNotifications();
  static _ApiServiceFolders get folders => _ApiServiceFolders();
}

class _ApiServiceUser {
  Future<NotifyUserDetailed> post({
    required String firstname,
    required String lastname,
    required String status,
    Color? color,
  }) async {
    color ??= Colors.primaries[Random().nextInt(Colors.primaries.length)];
    var res = await errorsHandlerMiddlware(
        callback: UserResponses.post(
            firstname: firstname,
            lastname: lastname,
            status: status,
            color: color,
            token: await ApiServiceConfig.token));
    return NotifyUserDetailed.fromJson(jsonDecode(res.body));
  }

  Future<NotifyUserDetailed> get() async {
    var res = await errorsHandlerMiddlware(
        callback: UserResponses.get(token: await ApiServiceConfig.token));
    return NotifyUserDetailed.fromJson(jsonDecode(res.body));
  }

  Future<NotifyUserDetailed> put({
    required String firstname,
    required String lastname,
    required String status,
    required Color color,
  }) async {
    var res = await errorsHandlerMiddlware(
      callback: UserResponses.put(
          firstname: firstname,
          lastname: lastname,
          status: status,
          color: color,
          token: await ApiServiceConfig.token),
    );
    return NotifyUserDetailed.fromJson(jsonDecode(res.body));
  }

  Future<List<NotifyUserQuick>> subscriptions() async {
    var res = await errorsHandlerMiddlware(
      callback:
          UserResponses.subscriptions(token: await ApiServiceConfig.token),
    );
    List<NotifyUserQuick> list = [];
    for (var item in jsonDecode(res.body)) {
      list.add(NotifyUserQuick.fromJson(item));
    }
    return list;
  }

  Future<List<NotifyUserQuick>> subscribers() async {
    var res = await errorsHandlerMiddlware(
      callback: UserResponses.subscribers(token: await ApiServiceConfig.token),
    );
    List<NotifyUserQuick> list = [];
    for (var item in jsonDecode(res.body)) {
      list.add(NotifyUserQuick.fromJson(item));
    }
    return list;
  }

  Future<void> changeSubscription(String uuid) async {
    await errorsHandlerMiddlware(
      callback: UserResponses.changeSubscription(
          token: await ApiServiceConfig.token, uuid: uuid),
    );
  }
}

class _ApiServiceUsers {
  Future<NotifyUserDetailed> get(String uuid) async {
    var res = await errorsHandlerMiddlware(
      callback: UsersResponses.get(
        token: await ApiServiceConfig.token,
        uuid: uuid,
      ),
    );
    return NotifyUserDetailed.fromJson(jsonDecode(res.body));
  }

  Future<List<NotifyUserQuick>> subscribers(String uuid) async {
    var res = await errorsHandlerMiddlware(
      callback: UsersResponses.subscribers(
          token: await ApiServiceConfig.token, uuid: uuid),
    );
    List<NotifyUserQuick> list = [];
    for (var item in jsonDecode(res.body)) {
      list.add(NotifyUserQuick.fromJson(item));
    }
    return list;
  }

  Future<List<NotifyUserQuick>> subscriptions(String uuid) async {
    var res = await errorsHandlerMiddlware(
      callback: UsersResponses.subscriptions(
          token: await ApiServiceConfig.token, uuid: uuid),
    );
    List<NotifyUserQuick> list = [];
    for (var item in jsonDecode(res.body)) {
      list.add(NotifyUserQuick.fromJson(item));
    }
    return list;
  }
}

class _ApiServiceSearch {
  Future<List<NotifyUserDetailed>> fromUsers({
    required String pattern,
    int? limit,
    int? offset,
  }) async {
    var res = await errorsHandlerMiddlware(
      callback: SearchResponses.fromUsers(
        pattern: pattern,
        limit: limit,
        offset: offset,
        token: await ApiServiceConfig.token,
      ),
    );
    List<NotifyUserDetailed> list = [];
    for (var item in jsonDecode(res.body)) {
      list.add(NotifyUserDetailed.fromJson(item));
    }
    return list;
  }

  Future<List<NotifyNotificationQuick>> fromNotifications({
    required String pattern,
    int? limit,
    int? offset,
  }) async {
    var res = await errorsHandlerMiddlware(
      callback: SearchResponses.fromNotifications(
        pattern: pattern,
        limit: limit,
        offset: offset,
        token: await ApiServiceConfig.token,
      ),
    );
    List<NotifyNotificationQuick> list = [];
    for (var item in jsonDecode(res.body)) {
      list.add(NotifyNotificationQuick.fromJson(item));
    }
    return list;
  }

  Future<List<NotifyFolderDetailed>> fromFolders({
    required String pattern,
    int? limit,
    int? offset,
  }) async {
    var res = await errorsHandlerMiddlware(
      callback: SearchResponses.fromFolders(
        pattern: pattern,
        limit: limit,
        offset: offset,
        token: await ApiServiceConfig.token,
      ),
    );
    List<NotifyFolderDetailed> list = [];
    for (var item in jsonDecode(res.body)) {
      list.add(NotifyFolderDetailed.fromJson(item));
    }
    return list;
  }
}

class _ApiServiceNotifications {
  Future<List<NotifyNotificationQuick>> get() async {
    var res = await errorsHandlerMiddlware(
      callback:
          NotificationsResponses.getAll(token: await ApiServiceConfig.token),
    );
    List<NotifyNotificationQuick> list = [];
    for (var item in jsonDecode(res.body)) {
      list.add(NotifyNotificationQuick.fromJson(item));
    }
    return list;
  }

  Future<NotifyNotificationDetailed> post({
    required String title,
    required String description,
    required DateTime deadline,
    RepeatMode repeatMode = RepeatMode.none,
    bool important = false,
  }) async {
    var res = await errorsHandlerMiddlware(
      callback: NotificationsResponses.post(
          title: title,
          description: description,
          repeatMode: repeatMode,
          important: important,
          deadline: deadline,
          token: await ApiServiceConfig.token),
    );
    return NotifyNotificationDetailed.fromJson(jsonDecode(res.body));
  }

  Future<NotifyNotificationDetailed> getById(String uuid) async {
    var res = await errorsHandlerMiddlware(
      callback: NotificationsResponses.getById(
          token: await ApiServiceConfig.token, uuid: uuid),
    );
    return NotifyNotificationDetailed.fromJson(jsonDecode(res.body));
  }

  Future<void> delete({required String uuid}) async {
    await errorsHandlerMiddlware(
      callback: NotificationsResponses.delete(
        token: await ApiServiceConfig.token,
        uuid: uuid,
      ),
    );
  }

  Future<NotifyNotificationDetailed> put({
    required String title,
    required String description,
    required DateTime deadline,
    required String uuid,
    RepeatMode repeatMode = RepeatMode.none,
    bool important = false,
  }) async {
    var res = await errorsHandlerMiddlware(
      callback: NotificationsResponses.put(
          title: title,
          description: description,
          repeatMode: repeatMode,
          imporant: important,
          deadline: deadline,
          uuid: uuid,
          token: await ApiServiceConfig.token),
    );
    return NotifyNotificationDetailed.fromJson(jsonDecode(res.body));
  }

  Future<List<NotifyUserQuick>> byIdParticipants({required String uuid}) async {
    var res = await errorsHandlerMiddlware(
      callback: NotificationsResponses.byIdParticipants(
          uuid: uuid, token: await ApiServiceConfig.token),
    );
    List<NotifyUserQuick> list = [];
    for (var item in jsonDecode(res.body)) {
      list.add(NotifyUserQuick.fromJson(item));
    }
    return list;
  }

  Future<void> invite({
    required String uuid,
    required String inviteUserId,
  }) async {
    await errorsHandlerMiddlware(
      callback: NotificationsResponses.invite(
        uuid: uuid,
        inviteUserId: inviteUserId,
        token: await ApiServiceConfig.token,
      ),
    );
  }

  Future<void> exclude({
    required String uuid,
    required String excludeUserId,
  }) async {
    await errorsHandlerMiddlware(
      callback: NotificationsResponses.exclude(
        uuid: uuid,
        excludeUserId: excludeUserId,
        token: await ApiServiceConfig.token,
      ),
    );
  }
}

class _ApiServiceFolders {
  Future<List<NotifyFolderDetailed>> get() async {
    var res = await errorsHandlerMiddlware(
      callback: FoldersRequests.getAll(token: await ApiServiceConfig.token),
    );
    List<NotifyFolderDetailed> list = [];
    for (var item in jsonDecode(res.body)) {
      list.add(NotifyFolderDetailed.fromJson(item));
    }
    return list;
  }

  Future<NotifyFolderDetailed> post({
    required String title,
    required String description,
  }) async {
    var res = await errorsHandlerMiddlware(
      callback: FoldersRequests.post(
          title: title,
          description: description,
          token: await ApiServiceConfig.token),
    );
    return NotifyFolderDetailed.fromJson(jsonDecode(res.body));
  }

  Future<NotifyFolderDetailed> getById(String uuid) async {
    var res = await errorsHandlerMiddlware(
      callback: FoldersRequests.getById(
          token: await ApiServiceConfig.token, uuid: uuid),
    );
    return NotifyFolderDetailed.fromJson(jsonDecode(res.body));
  }

  Future<void> delete({required String uuid}) async {
    await errorsHandlerMiddlware(
      callback: FoldersRequests.delete(
        token: await ApiServiceConfig.token,
        uuid: uuid,
      ),
    );
  }

  Future<NotifyFolderDetailed> put({
    required String title,
    required String description,
    required String uuid,
  }) async {
    var res = await errorsHandlerMiddlware(
      callback: FoldersRequests.put(
          title: title,
          description: description,
          uuid: uuid,
          token: await ApiServiceConfig.token),
    );
    return NotifyFolderDetailed.fromJson(jsonDecode(res.body));
  }

  Future<List<NotifyUserQuick>> byIdParticipants({required String uuid}) async {
    var res = await errorsHandlerMiddlware(
      callback: FoldersRequests.byIdParticipants(
          uuid: uuid, token: await ApiServiceConfig.token),
    );
    List<NotifyUserQuick> list = [];
    for (var item in jsonDecode(res.body)) {
      list.add(NotifyUserQuick.fromJson(item));
    }
    return list;
  }

  Future<List<NotifyNotificationQuick>> byIdNotifications(
      {required String uuid}) async {
    var res = await errorsHandlerMiddlware(
      callback: FoldersRequests.byIdParticipants(
          uuid: uuid, token: await ApiServiceConfig.token),
    );
    List<NotifyNotificationQuick> list = [];
    for (var item in jsonDecode(res.body)) {
      list.add(NotifyNotificationQuick.fromJson(item));
    }
    return list;
  }

  Future<void> invite({
    required String uuid,
    required String inviteUserId,
  }) async {
    await errorsHandlerMiddlware(
      callback: FoldersRequests.invite(
        uuid: uuid,
        inviteUserId: inviteUserId,
        token: await ApiServiceConfig.token,
      ),
    );
  }

  Future<void> exclude({
    required String uuid,
    required String excludeUserId,
  }) async {
    await errorsHandlerMiddlware(
      callback: FoldersRequests.exclude(
        uuid: uuid,
        excludeUserId: excludeUserId,
        token: await ApiServiceConfig.token,
      ),
    );
  }

  Future<void> addNotification({
    required String uuid,
    required String excludeUserId,
    required String folderId,
    String? ntfId,
    List<String>? listIds,
  }) async {
    await errorsHandlerMiddlware(
      callback: FoldersRequests.addNotification(
        uuid: uuid,
        folderId: folderId,
        listIds: listIds,
        ntfId: ntfId,
        token: await ApiServiceConfig.token,
      ),
    );
  }

  Future<void> removeNotification({
    required String uuid,
    required String excludeUserId,
    required String folderId,
    String? ntfId,
    List<String>? listIds,
  }) async {
    await errorsHandlerMiddlware(
      callback: FoldersRequests.removeNotification(
        uuid: uuid,
        folderId: folderId,
        listIds: listIds,
        ntfId: ntfId,
        token: await ApiServiceConfig.token,
      ),
    );
  }
}
