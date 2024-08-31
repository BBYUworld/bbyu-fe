import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/services/user_api_service.dart';
import 'package:gagyebbyu_fe/models/notification_model.dart';
import 'package:intl/intl.dart';

class NotificationCard extends StatelessWidget {
  final NotificationDto notification;
  final VoidCallback onDelete;
  final VoidCallback onAccept;

  NotificationCard({
    Key? key,
    required this.notification,
    required this.onDelete,
    required this.onAccept,
  }) : super(key: key);

  final Color _primaryColor = Color(0xFFFF6B6B);
  final Color _backgroundColor = Color(0xFFF9FAFB);
  final Color _textColor = Color(0xFF191F28);
  final Color _subTextColor = Color(0xFF8B95A1);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: _primaryColor.withOpacity(0.1)),
      ),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onLongPress: () => _showDeleteDialog(context),
        onTap: () => _showAcceptDialog(context),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _primaryColor,
                ),
                margin: EdgeInsets.only(top: 6, right: 12),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.message ?? '알림 내용 없음',
                      style: TextStyle(fontSize: 16, color: _textColor, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 8),
                    Text(
                      notification.createdAt != null
                          ? DateFormat('yyyy년 MM월 dd일').format(notification.createdAt!)
                          : '',
                      style: TextStyle(fontSize: 12, color: _subTextColor),
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
          title: Text('알림 삭제', style: TextStyle(color: _textColor, fontWeight: FontWeight.bold)),
          content: Text('이 알림을 삭제하시겠습니까?', style: TextStyle(color: _textColor)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actions: <Widget>[
            TextButton(
              child: Text('취소', style: TextStyle(color: _subTextColor)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('삭제', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
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
          title: Text('커플 요청', style: TextStyle(color: _textColor, fontWeight: FontWeight.bold)),
          content: Text('커플 요청을 수락하시겠습니까?', style: TextStyle(color: _textColor)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actions: <Widget>[
            TextButton(
              child: Text('취소', style: TextStyle(color: _subTextColor)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('수락', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
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