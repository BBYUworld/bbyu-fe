import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../models/loan/loan.dart';

class RecommendedLoanCard extends StatelessWidget {
  final Loan loan;

  RecommendedLoanCard({required this.loan});

  @override
  Widget build(BuildContext context) {
    // 캐러셀에 표시할 이미지 목록
    final List<String> imageList = [
      'assets/loan_image/loan_info1.png',
      'assets/loan_image/loan_info2.png',
      'assets/loan_image/noimage.png',
    ];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('나에게 맞는 대출은 무엇일까요?',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600])
            ),
            Text('대출 추천 받기',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
            ),
            SizedBox(height: 16),
            Container(
              color: Colors.white,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 400,
                  aspectRatio: 16/9,
                  viewportFraction: 1.0,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 7),
                  autoPlayAnimationDuration: Duration(milliseconds: 900),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: false,
                  scrollDirection: Axis.horizontal,
                ),
                items: imageList.map((item) => Container(
                  width: double.infinity,
                  child: Image.asset(
                    item,
                    fit: BoxFit.fill,
                  ),
                )).toList(),
              ),
            ),
            SizedBox(height: 16),

            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}