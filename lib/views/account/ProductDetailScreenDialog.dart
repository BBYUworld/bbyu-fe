import 'package:flutter/material.dart';

class ProductDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> account;
  final Color primaryColor = Color(0xFFFF6B6B);
  final Color backgroundColor = Colors.white;
  final Color textColor = Color(0xFF333333);

  ProductDetailsDialog({required this.account});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.0,
            offset: Offset(0.0, 4.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '계좌 상세 정보',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
          ),
          SizedBox(height: 20),
          _buildDetailItem('은행', account['bankName']),
          _buildDetailItem('계좌번호', account['accountNo']),
          _buildDetailItem('계좌명', account['accountName']),
          _buildDetailItem('계좌 유형', account['accountTypeName']),
          _buildDetailItem('생성일', account['accountCreatedDate']),
          _buildDetailItem('만료일', account['accountExpiryDate']),
          _buildDetailItem('일일 이체 한도', '${account['dailyTransferLimit']}원'),
          _buildDetailItem('1회 이체 한도', '${account['oneTimeTransferLimit']}원'),
          _buildDetailItem('잔액', '${account['accountBalance']}원'),
          _buildDetailItem('통화', account['currency']),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('닫기'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: textColor.withOpacity(0.6))),
          Text(value.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
        ],
      ),
    );
  }
}
