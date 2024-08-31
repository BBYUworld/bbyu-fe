import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/utils/currency_formatting.dart';
import 'package:intl/intl.dart'; // 통화 포맷을 위해 추가
import '../../models/analysis/analysis_asset.dart';

class TotalAssetsCard extends StatelessWidget {
  final Future<AssetResultDto> futureAssetResult;

  TotalAssetsCard({required this.futureAssetResult});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '총자산',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            FutureBuilder<AssetResultDto>(
              future: futureAssetResult,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final result = snapshot.data!;
                  final currentAssetText = '${formatCurrency(result.currentAsset)}원';
                  final lastYearAsset = result.lastYearAsset;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentAssetText,
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      if (lastYearAsset != null) ...[
                        _buildComparisonRow(result, lastYearAsset),
                      ] else ...[
                        Text(
                          '지난해 자산 데이터가 없습니다.',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ],
                  );
                } else {
                  return Text('데이터를 불러오지 못했습니다.');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonRow(AssetResultDto result, int lastYearAsset) {
    final difference = result.currentAsset - lastYearAsset;
    final symbol = difference >= 0 ? '▲' : '▼';
    final displayAmount = formatCurrency(difference.abs());

    return Row(
      children: [
        Text(
          '$symbol $displayAmount원',
          style: TextStyle(
            color: difference >= 0 ? Colors.red : Colors.blue,
            fontSize: 16,
          ),
        ),
        SizedBox(width: 10),
        Text(
          '${DateTime.now().year - 1}년 기준',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}
