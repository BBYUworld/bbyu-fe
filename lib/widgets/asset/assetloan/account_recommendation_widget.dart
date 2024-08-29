import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:gagyebbyu_fe/models/account/account_recommendation.dart';

class AccountSelectionWidget extends StatefulWidget {
  final AccountRecommendation recommendations;

  const AccountSelectionWidget({Key? key, required this.recommendations}) : super(key: key);

  @override
  _AccountSelectionWidgetState createState() => _AccountSelectionWidgetState();
}

class _AccountSelectionWidgetState extends State<AccountSelectionWidget> {
  int _currentDepositIndex = 0;
  int _currentSavingsIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        _buildCarousel('예금 추천', widget.recommendations.depositAccounts, _currentDepositIndex, (index) => setState(() => _currentDepositIndex = index)),
        SizedBox(height: 20),
        _buildCarousel('적금 추천', widget.recommendations.savingsAccounts, _currentSavingsIndex, (index) => setState(() => _currentSavingsIndex = index)),
      ],
    );
  }

  Widget _buildCarousel(String title, List<RecommendedAccount> items, int currentIndex, Function(int) onPageChanged) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        CarouselSlider(
          options: CarouselOptions(
            height: 300.0,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) => onPageChanged(index),
          ),
          items: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${index + 1}. ${item.accountDto.name} ',
                          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text('은행: ${item.accountDto.bankName}'),
                      Text('금리: ${item.accountDto.interestRate}%'),
                      Text('기간: ${item.accountDto.termMonths}개월'),
                      Text('최소 금액: ${item.accountDto.minAmount}원'),
                      Text('최대 금액: ${item.accountDto.maxAmount}원'),
                      Text('이자 지급 방식: ${item.accountDto.interestPaymentMethod}'),
                      SizedBox(height: 10),
                      Text('추천 점수: ${(item.pred * 100).toStringAsFixed(2)}%',
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text(item.accountDto.description, style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ),
        SizedBox(height: 10),
        DotsIndicator(
          dotsCount: items.length,
          position: currentIndex.toDouble(),
          decorator: DotsDecorator(
            activeColor: Colors.blue,
            size: const Size.square(9.0),
            activeSize: const Size(18.0, 9.0),
            activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          ),
        ),
      ],
    );
  }
}