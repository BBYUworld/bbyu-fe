import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class RecommendedLoanCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> imageList = [
      'assets/loan_image/loan_info1.png',
      'assets/loan_image/loan_info2.png',
      'assets/loan_image/noimage.png',
    ];

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 16),
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
            CarouselSlider(
              options: CarouselOptions(
                height: 300,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 7),
                autoPlayAnimationDuration: Duration(milliseconds: 900),
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
              ),
              items: imageList.map((item) => Container(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  item,
                  fit: BoxFit.cover,
                ),
              )).toList(),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}