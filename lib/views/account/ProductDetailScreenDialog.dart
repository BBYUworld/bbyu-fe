import 'package:flutter/material.dart';

class TossStyleAccountDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> account;
  final Color primaryColor = Color(0xFF3182F6);
  final Color backgroundColor = Color(0xFFF9FAFB);

  TossStyleAccountDetailsDialog({required this.account});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20, top: 65, right: 20, bottom: 20),
          margin: EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                account['bankName'],
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 15),
              _buildDetailItem('계좌번호', account['accountNo'], Icons.credit_card),
              _buildDetailItem('계좌명', account['accountName'], Icons.account_balance_wallet),
              _buildDetailItem('계좌 유형', account['accountTypeName'], Icons.category),
              _buildDetailItem('생성일', account['accountCreatedDate'], Icons.date_range),
              _buildDetailItem('만료일', account['accountExpiryDate'], Icons.event),
              _buildDetailItem('일일 이체 한도', '${account['dailyTransferLimit']}원', Icons.refresh),
              _buildDetailItem('1회 이체 한도', '${account['oneTimeTransferLimit']}원', Icons.arrow_forward),
              _buildDetailItem('잔액', '${account['accountBalance']}원', Icons.account_balance),
              _buildDetailItem('통화', account['currency'], Icons.monetization_on),
              SizedBox(height: 22),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('닫기', style: TextStyle(fontSize: 18, color: primaryColor)),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          child: CircleAvatar(
            backgroundColor: primaryColor,
            radius: 45,
            child: Icon(
              Icons.account_balance,
              color: Colors.white,
              size: 50,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, dynamic value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: primaryColor, size: 24),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                SizedBox(height: 4),
                Text(value.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}