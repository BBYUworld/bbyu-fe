import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this for number formatting
import 'package:gagyebbyu_fe/models/couple_model.dart';
import 'package:gagyebbyu_fe/views/home/Footer.dart';
import 'package:gagyebbyu_fe/views/householdledger/HouseholdLedgerScreen.dart';
import 'package:gagyebbyu_fe/services/user_api_service.dart';
import 'package:gagyebbyu_fe/views/account/couple_account_screen.dart';
import 'package:gagyebbyu_fe/views/couple/search_modal.dart';
import 'package:gagyebbyu_fe/views/home/navbar.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  bool _isLoaded = false;
  late UserApiService userApiService;
  int? _coupleSum; // Initially null to avoid using uninitialized value
  CoupleResponseDto? _coupleDto;

  final Color primaryColor = Color(0xFFFF6B6B);
  final Color backgroundColor = Color(0xFFF9FAFB);
  final Color cardColor = Colors.white;
  final Color textColor = Color(0xFF191F28);
  final Color subtextColor = Color(0xFF8B95A1);

  @override
  void initState() {
    super.initState();
    userApiService = UserApiService(context);
    _loadData();
    _updateUnreadNotificationCount();
  }

  void _onFocusGained() {
    _updateUnreadNotificationCount();
    _loadData();
  }

  Future<void> _updateUnreadNotificationCount() async {
    try {
      await userApiService.getUnreadNotificationCnt(context);
    } catch (e) {
      print('Failed to update unread notification count: $e');
    }
  }

  Future<void> _loadData() async {
    try {
      _coupleDto = await userApiService.findCouple();
      if (_coupleDto != null) {
        _coupleSum = await userApiService.getCoupleAssetAccountSum();
        print("couple sum = $_coupleSum");
      }
    } catch (e) {
      print('Failed to load data: $e');
      _coupleSum = 0; // Set to 0 in case of failure
    } finally {
      setState(() {
        _isLoaded = true;
      });
    }
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat('#,###');
    return '${formatter.format(amount)}원';
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      onFocusChange: (hasFocus) {
        if (hasFocus) {
          _onFocusGained();
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: CustomAppBar(),
        body: SafeArea(
          child: _isLoaded
              ? SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCoupleCard(),
                  SizedBox(height: 24),
                  Text(
                    '금융 서비스',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  SizedBox(height: 16),
                  _buildMenuGrid(),
                ],
              ),
            ),
          )
              : Center(child: CircularProgressIndicator(color: primaryColor)),
        ),
        bottomNavigationBar: CustomFooter(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }

  Widget _buildCoupleCard() {
    return GestureDetector(
      onTap: () async {
        if (_coupleDto != null) {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CoupleAssetsScreen(coupleDto: _coupleDto!)),
          );
          _onFocusGained();
        } else {
          showSearchDialog(context);
        }
      },
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_coupleDto != null) ...[
                Text(
                  _coupleDto!.nickname,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_coupleDto!.user1Name, style: TextStyle(color: subtextColor)),
                        SizedBox(height: 4),
                        Text(
                          _formatCurrency(_coupleSum!), // Using the formatted sum
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(_coupleDto!.user2Name, style: TextStyle(color: subtextColor)),
                        SizedBox(height: 4),
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: backgroundColor,
                          child: Icon(Icons.person, size: 24, color: primaryColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ] else ...[
                Center(
                  child: Text(
                    "현재 연결된 커플 배우자가 없습니다.",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        _buildMenuCard('상품 추천', Icons.lightbulb_outline, () {
          Navigator.pushNamed(context, '/product');
        }),
        _buildMenuCard('펀딩', Icons.monetization_on_outlined, () {
          Navigator.pushNamed(context, '/fund');
        }),
        _buildMenuCard('가계부', Icons.account_balance_wallet_outlined, () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HouseholdLedgerScreen()),
          );
          _onFocusGained();
        }),
        _buildMenuCard('자산 리포트', Icons.bar_chart, () {
          Navigator.pushNamed(context, '/report');
        }),
      ],
    );
  }

  Widget _buildMenuCard(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: primaryColor),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            child: SearchModal(),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        );
      },
    );
  }
}
