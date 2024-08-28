import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/models/couple_model.dart';
import 'package:gagyebbyu_fe/views/home/Fotter.dart';
import 'package:gagyebbyu_fe/views/householdledger/HouseholdLedgerScreen.dart';
import 'package:gagyebbyu_fe/services/user_api_service.dart';
import 'package:gagyebbyu_fe/views/account/couple_account_screen.dart';
import 'package:gagyebbyu_fe/views/couple/search_modal.dart';
import 'package:gagyebbyu_fe/views/home/navbar.dart';
import 'package:gagyebbyu_fe/storage/user_store.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  bool _isLoaded = false;
  late UserApiService userApiService;
  CoupleResponseDto? _coupleDto;

  @override
  void initState() {
    super.initState();
    userApiService = UserApiService(context);
    _loadData();
    _updateUnreadNotificationCount();
  }

  void _onFocusGained() {
    _updateUnreadNotificationCount();
    _loadData(); // 필요한 경우 다른 데이터도 새로고침
  }

  Future<void> _updateUnreadNotificationCount() async {
    try {
      await userApiService.getUnreadNotificationCnt(context);
    } catch (e) {
      print('Failed to update unread notification count: $e');
    }
  }

  Future<void> _loadData() async {
    _coupleDto = await userApiService.findCouple();
    setState(() {
      _isLoaded = true;
    });
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
        appBar: CustomAppBar(),
        body: SafeArea(
          child: _isLoaded
              ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _coupleDto != null ? _coupleDto!.nickname : "커플 정보 없음",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                _buildCoupleCard(),
                SizedBox(height: 16),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildMenuCard('쀼 펀딩', Icons.search, () {
                        Navigator.pushNamed(context, '/fund');
                      }),

                      _buildMenuCard('뷰 상품 추천', Icons.message, () {}),
                      _buildMenuCard('가계부', Icons.attach_money, () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HouseholdLedgerScreen()),
                        );
                        _onFocusGained();
                      }),
                      _buildMenuCard('뷰 자산 리포트', Icons.description, () {}),
                      _buildMenuCard('병주\'s 대출 페이지', Icons.description, () {
                        Navigator.pushNamed(context, '/loan');
                      }),
                    ],
                  ),
                ),
              ],
            ),
          )
              : Center(child: CircularProgressIndicator()),
        ),
        bottomNavigationBar: CustomFooter(
          selectedIndex: 0,
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
        child: Card(
          color: Colors.pink[100],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  _coupleDto != null ? _coupleDto!.nickname : "현재 연결된 커플 배우자가 없습니다.",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                _coupleDto != null
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_coupleDto!.user1Name, style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('1,234,567원', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(_coupleDto!.user2Name, style: TextStyle(fontWeight: FontWeight.bold)),
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey[300],
                          child: Icon(Icons.person, size: 30),
                        ),
                      ],
                    ),
                  ],
                )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(String title, IconData icon, VoidCallback onTap) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40),
              SizedBox(height: 8),
              Text(title, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  void showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.5,
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