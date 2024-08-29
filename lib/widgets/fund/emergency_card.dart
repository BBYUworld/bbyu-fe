// emergency_card.dart
import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/models/fund/fund_overview.dart';

class EmergencyCard extends StatelessWidget {
  final FundOverview fundOverview;

  EmergencyCard({required this.fundOverview});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Color(0xFFFFCDD0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('비상금 사용 현황', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Row(
              children: [
                Text('사용 여부: ', style: TextStyle(fontSize: 16)),
                Text(
                  fundOverview.isEmergencyUsed > 0 ? '사용함' : '사용 안함',
                  style: TextStyle(
                    fontSize: 16,
                    color: fundOverview.isEmergencyUsed > 0 ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('비상금 사용 횟수: ${fundOverview.emergencyCount}회', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
