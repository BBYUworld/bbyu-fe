import 'package:flutter/foundation.dart';

class NotificationDto {
  final int? notificationId;
  final int? senderId;
  final String? senderName;
  final int? receiverId;
  final String? receiverName;
  final String? type;
  final String? message;
  final DateTime? createdAt;

  NotificationDto({
    this.notificationId,
    this.senderId,
    this.senderName,
    this.receiverId,
    this.receiverName,
    this.type,
    this.message,
    this.createdAt,
  });

  // CopyWith method to create a new instance with updated values
  NotificationDto copyWith({
    int? notificationId,
    int? senderId,
    String? senderName,
    int? receiverId,
    String? receiverName,
    String? type,
    String? message,
    DateTime? createdAt,
  }) {
    return NotificationDto(
      notificationId: notificationId ?? this.notificationId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      receiverId: receiverId ?? this.receiverId,
      receiverName: receiverName ?? this.receiverName,
      type: type ?? this.type,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Factory method to create an instance from JSON
  factory NotificationDto.fromJson(Map<String, dynamic> json) {
    return NotificationDto(
      notificationId: json['notificationId'] as int?,
      senderId: json['senderId'] as int?,
      senderName: json['senderName'] as String?,
      receiverId: json['receiverId'] as int?,
      receiverName: json['receiverName'] as String?,
      type: json['type'] as String?,
      message: json['message'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'senderId': senderId,
      'senderName': senderName,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'type': type,
      'message': message,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'NotificationDto{notificationId: $notificationId, senderId: $senderId, senderName: $senderName, receiverId: $receiverId, receiverName: $receiverName, type: $type, message: $message, createdAt: $createdAt}';
  }
}
