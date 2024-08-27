import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/services/user_api_service.dart';
import 'package:gagyebbyu_fe/models/notification_model.dart';
import 'package:intl/intl.dart';

class NotificationCard extends StatelessWidget {
  final NotificationDto notification;
  final VoidCallback onDelete;
  final VoidCallback onAccept;

  const NotificationCard({
    Key? key,
    required this.notification,
    required this.onDelete,
    required this.onAccept,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: InkWell(
        onLongPress: () => _showDeleteDialog(context),
        onTap: () => _showAcceptDialog(context),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.message ?? '알림 내용 없음',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      notification.createdAt != null
                          ? DateFormat('yyyy-MM-dd').format(notification.createdAt!)
                          : '',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('알림 삭제'),
          content: Text('이 알림을 삭제하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
                onDelete();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAcceptDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('커플 요청'),
          content: Text('커플 요청을 수락하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('수락'),
              onPressed: () {
                Navigator.of(context).pop();
                onAccept();
              },
            ),
          ],
        );
      },
    );
  }
}