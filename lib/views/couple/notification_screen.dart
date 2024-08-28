import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/services/user_api_service.dart';
import 'package:gagyebbyu_fe/models/notification_model.dart';
import 'package:intl/intl.dart';
import 'package:gagyebbyu_fe/views/couple/notification_card_screen.dart';
import 'package:gagyebbyu_fe/views/home/MainPage.dart';

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

  Future<void> deleteNotification(int notificationId) async {
    await userApiService.deleteNotification(notificationId);
    setState(() {
      _notificationsFuture = fetchNotifications();
    });
  }


  Future<void> acceptCoupleRequest(int? senderId, int? receiverId) async {
    if (senderId == null || receiverId == null) {
      return;
    }
    bool flag = await userApiService.connectCouple(senderId, receiverId);
    if (flag) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('성공'),
            content: Text('커플 연결이 완료되었습니다!'),
            actions: <Widget>[
              TextButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                  // 메인 페이지로 이동
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => MainPage()),
                        (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          );
        },
      );
    } else {
      // 실패 시 처리
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('오류'),
            content: Text('커플 연결에 실패했습니다.'),
            actions: <Widget>[
              TextButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                },
              ),
            ],
          );
        },
      );
    }
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
            return ListView.separated(
              itemCount: snapshot.data!.length,
              separatorBuilder: (context, index) => Divider(height: 1),
              itemBuilder: (context, index) {
                NotificationDto notification = snapshot.data![index];
                return NotificationCard(
                  notification: notification,
                  onDelete: () => deleteNotification(notification.notificationId!),
                  onAccept: () => acceptCoupleRequest(notification.senderId, notification.receiverId),
                );
              },
            );
          }
        },
      ),
    );
  }
}