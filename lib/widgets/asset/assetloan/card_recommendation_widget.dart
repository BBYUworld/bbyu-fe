import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';

class CardSelectionWidget extends StatefulWidget {
  @override
  _CardSelectionWidgetState createState() => _CardSelectionWidgetState();
}

class _CardSelectionWidgetState extends State<CardSelectionWidget> {
  int _currentIndex = 0;
  List<CardItem> cardItems = [
    CardItem(name: 'Deep Dream 신용카드', color: Colors.blue),
    CardItem(name: 'Sky High 체크카드', color: Colors.green),
    CardItem(name: 'Ocean Wave 신용카드', color: Colors.teal),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('우리의 소비 기반의'),
        Text('카드 추천',style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),),
        SizedBox(height: 20,),
        CarouselSlider(
          options: CarouselOptions(
            height: 200.0,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: cardItems.map((item) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: item.color,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      item.name,
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        SizedBox(height: 20),
        DotsIndicator(
          dotsCount: cardItems.length,
          position: _currentIndex.toDouble(),
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

class CardItem {
  final String name;
  final Color color;

  CardItem({required this.name, required this.color});
}