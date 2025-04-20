import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  NotificationModel({
    super.id,
    required super.title,
    required super.body,
    super.timestamp,
    super.isRead,
    required super.type,
  });

  // Convert from JSON to Model
  factory NotificationModel.fromJson(Map<String, dynamic> json, String notificationId) {
    return NotificationModel(
      id: notificationId,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      timestamp:
          json['timestamp'] != null
              ? (json['timestamp'] as Timestamp).toDate()
              : null,

      isRead: json['isRead'] ?? false,
      type: json['type'] ?? '',
    );
  }

  // Convert Model to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'timestamp': timestamp,
      'isRead': isRead,
      'type': type,
    };
  }

  // Convert from Entity to Model
  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      title: entity.title,
      body: entity.body,
      timestamp: entity.timestamp,
      isRead: entity.isRead,
      type: entity.type,
    );
  }
}
