import 'package:flutter/material.dart';

import '../models/expense/expense_category.dart';

final Map<Category, Color> expenseColorMapping = {
  Category.Education: Color(0xFFE6FF00),          // 교육
  Category.Transportation: Color(0xFFFFA500),     // 교통_자동차 (Colors.orangeAccent)
  Category.Other: Color(0xFF808080),              // 기타소비 (Colors.grey)
  Category.LargeMart: Color(0xFF9300DA),          // 대형마트 (Colors.deepPurpleAccent)
  Category.Beauty: Color(0xFFFF4081),             // 미용 (Colors.pinkAccent)
  Category.Delivery: Color(0xFF1DE9B6),           // 배달 (Colors.tealAccent)
  Category.Insurance: Color(0xFFA52A2A),          // 보험 (Colors.brown)
  Category.DailyNecessities: Color(0xFF000000),   // 생필품 (Colors.blue)
  Category.LivingServices: Color(0xFF3F51B5),     // 생활서비스 (Colors.indigo)
  Category.TaxesAndFees: Color(0xFFFF5252),       // 세금_공과금 (Colors.redAccent)
  Category.ShoppingMall: Color(0xFFD700FB),       // 쇼핑몰
  Category.TravelAndAccommodation: Color(0xFF00BCD4), // 여행_숙박 (Colors.cyanAccent)
  Category.DiningOut: Color(0xFFFF5722),          // 외식 (Colors.deepOrange)
  Category.Healthcare: Color(0xFFFF0000),         // 의료_건강 (Colors.red)
  Category.AlcoholAndPub: Color(0xFFFFC107),      // 주류_펍 (Colors.amber)
  Category.HobbiesAndLeisure: Color(0xFF007305),  // 취미_여가 (Colors.green)
  Category.Cafe: Color(0xFFA52A2A),               // 카페 (Colors.brown)
  Category.Communication: Color(0xFFADD8E6),      // 통신 (Colors.lightBlue)
  Category.ConvenienceStore: Color(0xFFFFFF00),   // 편의점 (Colors.yellow)
};
