import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/models/fund/fund_overview.dart';

class EmergencyCard extends StatelessWidget {
  final FundOverview fundOverview;

  EmergencyCard({required this.fundOverview});

  // Toss-style colors
  final Color _primaryColor = Color(0xFFFF6B6B);
  final Color _backgroundColor = Color(0xFFF9FAFB);
  final Color _cardColor = Colors.white;
  final Color _textColor = Color(0xFF191F28);
  final Color _subTextColor = Color(0xFF8B95A1);
  final Color _warningColor = Color(0xFFFF3B30);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '비상금 사용 현황',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            SizedBox(height: 16),
            _buildEmergencyStatusRow(),
            SizedBox(height: 12),
            _buildEmergencyCountRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyStatusRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('사용 여부', style: TextStyle(fontSize: 16, color: _subTextColor)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: fundOverview.isEmergencyUsed > 0
                ? _warningColor.withOpacity(0.1)
                : _primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            fundOverview.isEmergencyUsed > 0 ? '사용함' : '사용 안함',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: fundOverview.isEmergencyUsed > 0 ? _warningColor : _primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmergencyCountRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('비상금 사용 횟수', style: TextStyle(fontSize: 16, color: _subTextColor)),
        Text(
          '${fundOverview.emergencyCount}회',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _textColor,
          ),
        ),
      ],
    );
  }
}