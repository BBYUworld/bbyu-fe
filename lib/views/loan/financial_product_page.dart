import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF3182F6);
  static const Color secondaryColor = Color(0xFFF2F4F6);
  static const Color textColor = Color(0xFF191F28);
  static const Color subtextColor = Color(0xFF8B95A1);
  static const Color buttonTextColor = Color(0xFF4E5968);
}

class FinancialProductRecommendPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: '금융 상품 추천'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 24),
              PageTitle(),
              SizedBox(height: 8),
              PageDescription(),
              SizedBox(height: 40),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RecommendationButton(
                      text: '내 자산 기반 개인 상품 추천받기',
                      subtext: '나에게 맞는 금융 상품을 찾아보세요',
                      icon: Icons.account_balance_wallet,
                      routeName: '/asset',
                    ),
                    SizedBox(height: 16),
                    RecommendationButton(
                      text: '커플 대출 추천받기',
                      subtext: '함께하는 미래를 위한 최적의 대출 상품',
                      icon: Icons.favorite,
                      routeName: '/coupleloan',
                    ),
                  ],
                ),
              ),
              DisclaimerText(),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  CustomAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.textColor,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.textColor),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class PageTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '맞춤 금융 상품 추천',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.textColor,
      ),
    );
  }
}

class PageDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '당신의 상황에 맞는 최적의 금융 상품을 추천해 드립니다.',
      style: TextStyle(
        fontSize: 16,
        color: AppColors.subtextColor,
      ),
    );
  }
}

class RecommendationButton extends StatelessWidget {
  final String text;
  final String subtext;
  final IconData icon;
  final String routeName;

  RecommendationButton({
    required this.text,
    required this.subtext,
    required this.icon,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.buttonTextColor,
        backgroundColor: AppColors.secondaryColor,
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      onPressed: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Row(
        children: [
          Icon(icon, size: 28, color: AppColors.primaryColor),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtext,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.subtextColor,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.subtextColor),
        ],
      ),
    );
  }
}

class DisclaimerText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        '* 추천 결과는 실제 심사 결과와 다를 수 있습니다.',
        style: TextStyle(
          fontSize: 12,
          color: AppColors.subtextColor,
        ),
      ),
    );
  }
}