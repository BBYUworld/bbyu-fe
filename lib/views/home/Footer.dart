import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/views/home/MainPage.dart';
import 'package:gagyebbyu_fe/views/fund/fund_view.dart';

class CustomFooter extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  CustomFooter({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pie_chart),
          label: '자산관리',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.card_giftcard),
          label: '상품',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: '펀딩',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '사용자',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.grey,  // 선택된 항목의 색상을 회색으로 변경
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        if (index == 0) {
          // 홈 버튼을 눌렀을 때 MainPage로 이동
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
          );
        } else if(index == 3){
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => FundView())
          );
        }else {
          onItemTapped(index);
        }
      },
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
    );
  }
}