import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gagyebbyu_fe/services/user_api_service.dart';
import 'package:gagyebbyu_fe/models/notification_model.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late Future<List<NotificationDto>> _notificationsFuture;
  late UserApiService userApiService;

  @override
  void initState() {
    super.initState();
    userApiService = UserApiService(context);
    _notificationsFuture = fetchNotifications();
  }

  Future<List<NotificationDto>> fetchNotifications() async {
    return userApiService.findAllNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('알림'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<List<NotificationDto>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('알림이 없습니다.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                NotificationDto notification = snapshot.data![index];
                return ListTile(
                  title: Text(notification.message ?? '알림 내용 없음'),
                  subtitle: Text('From: ${notification.senderName ?? '알 수 없음'}'),
                  trailing: Text(notification.createdAt?.toString() ?? ''),
                );
              },
            );
          }
        },
      ),
    );
  }
}