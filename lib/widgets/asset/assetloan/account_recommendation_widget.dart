import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:gagyebbyu_fe/models/account/account_recommendation.dart';
import 'package:intl/intl.dart';
import 'package:gagyebbyu_fe/views/account/account_create_detail_widget.dart';

class AccountSelectionWidget extends StatefulWidget {
  final AccountRecommendation recommendations;

  const AccountSelectionWidget({Key? key, required this.recommendations}) : super(key: key);

  @override
  _AccountSelectionWidgetState createState() => _AccountSelectionWidgetState();
}

class _AccountSelectionWidgetState extends State<AccountSelectionWidget> {
  int _currentDepositIndex = 0;
  int _currentSavingsIndex = 0;

  final Color primaryColor = Color(0xFFFF6B6B);
  final Color backgroundColor = Color(0xFFF9FAFB);
  final Color cardColor = Colors.white;
  final Color textColor = Color(0xFF191F28);
  final Color subtextColor = Color(0xFF8B95A1);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCarousel('예금 추천', widget.recommendations.depositAccounts, _currentDepositIndex, (index) => setState(() => _currentDepositIndex = index)),
        SizedBox(height: 30),
        _buildCarousel('적금 추천', widget.recommendations.savingsAccounts, _currentSavingsIndex, (index) => setState(() => _currentSavingsIndex = index)),
      ],
    );
  }

  Widget _buildCarousel(String title, List<RecommendedAccount> items, int currentIndex, Function(int) onPageChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
        ),
        SizedBox(height: 15),
        CarouselSlider(
          options: CarouselOptions(
            height: 240.0,  // 높이를 조정했습니다
            enlargeCenterPage: true,
            onPageChanged: (index, reason) => onPageChanged(index),
            viewportFraction: 0.85,
          ),
          items: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return GestureDetector(
              onTap: () {
                // Navigator를 사용하여 DetailPage로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(
                      accountDto: item.accountDto,
                      isSavings: title == '적금 추천', // 적금인 경우 true를 전달
                    ),
                  ),
                );
              },
              child: Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item.accountDto.name,
                                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: textColor),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                item.accountDto.bankName,
                                style: TextStyle(fontSize: 12, color: subtextColor),
                              ),
                            ],
                          ),
                          Divider(height: 16),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildInfoRow('금리', '${item.accountDto.interestRate}%'),
                                  _buildInfoRow('기간', '${item.accountDto.termMonths}개월'),
                                  _buildInfoRow('최소 금액', _formatCurrency(item.accountDto.minAmount * 10000)),
                                  _buildInfoRow('최대 금액', _formatCurrency(item.accountDto.maxAmount * 10000)),
                                  _buildInfoRow('최대 금액', '${item.accountDto.accountTypeUniqueNo}'),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '추천 점수: ${(item.pred * 100).toStringAsFixed(0)}%',
                              style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 15),
        Center(
          child: DotsIndicator(
            dotsCount: items.length,
            position: currentIndex.toDouble(),
            decorator: DotsDecorator(
              activeColor: primaryColor,
              color: subtextColor.withOpacity(0.3),
              size: const Size.square(8.0),
              activeSize: const Size(24.0, 8.0),
              activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: subtextColor, fontSize: 12)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 12)),
        ],
      ),
    );
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat('#,###');
    return '${formatter.format(amount)}원';
  }
}