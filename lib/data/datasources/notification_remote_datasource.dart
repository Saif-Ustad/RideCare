import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<void> addNotification(String userId, NotificationModel notification);

  Stream<List<NotificationModel>> getNotifications(String userId);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final FirebaseFirestore firestore;

  NotificationRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> addNotification(
    String userId,
    NotificationModel notification,
  ) async {
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .add({
            'title': notification.title,
            'body': notification.body,
            'timestamp': FieldValue.serverTimestamp(),
            'isRead': false,
            'type': notification.type,
          });
    } catch (e) {
      debugPrint("Error adding notification: $e");
      rethrow;
    }
  }

  @override
  Stream<List<NotificationModel>> getNotifications(String userId) {
    try {
      return firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return NotificationModel.fromJson(doc.data());
            }).toList();
          });
    } catch (e) {
      debugPrint("Error getting notifications: $e");
      rethrow;
    }
  }
}
