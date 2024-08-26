import 'package:flutter/material.dart';

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
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      onTap: onItemTapped,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
    );
  }
}