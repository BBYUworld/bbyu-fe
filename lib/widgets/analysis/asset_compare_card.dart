import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:gagyebbyu_fe/models/analysis/analysis_asset.dart';
import '../../utils/currency_formatting.dart';

class AssetCompareCard extends StatelessWidget {
  final AssetResultDto assetResult;

  AssetCompareCard({required this.assetResult});

  @override
  Widget build(BuildContext context) {
    // Calculate the percentage change
    double percentageChange = _calculatePercentageChange(
      assetResult.currentAsset,
      assetResult.anotherAssetsAvg,
    );

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '자산 분석',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            RichText(
              text: TextSpan(
                text: '또래 대비 자산 보유 ',
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(
                    text: '${percentageChange > 0 ? '+' : ''}${percentageChange.toStringAsFixed(1)}%',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.0),
            Row(
              children: [
                _buildTag('${assetResult.startAge}대'),
                SizedBox(width: 8.0),
                _buildTag('${assetResult.startIncome}만원대'), // Displaying income as "백만원대"
              ],
            ),
            SizedBox(height: 12.0),
            Divider(),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildComparisonColumn('또래 평균', '${formatCurrency(assetResult.anotherAssetsAvg)} 만원'), // Displaying as integer with "만원"
                Text('VS', style: TextStyle(fontSize: 16, color: Colors.grey)),
                _buildComparisonColumn('나의 금융자산', '${formatCurrency(assetResult.currentAsset)} 만원'), // Displaying as integer with "만원"
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _calculatePercentageChange(int currentAsset, int anotherCoupleAssetAvg) {
    if (anotherCoupleAssetAvg == 0) return 0;
    return ((currentAsset - anotherCoupleAssetAvg) / anotherCoupleAssetAvg) * 100;
  }

  Widget _buildTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.black, fontSize: 12.0),
      ),
    );
  }

  Widget _buildComparisonColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        SizedBox(height: 4.0),
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
