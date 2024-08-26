import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/models/couple_model.dart';
import 'package:gagyebbyu_fe/views/home/Fotter.dart';
import 'package:gagyebbyu_fe/views/householdledger/HouseholdLedgerScreen.dart';
import 'package:gagyebbyu_fe/services/user_api_service.dart';
import 'package:gagyebbyu_fe/views/account/couple_account_screen.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  bool _isLoaded = false;
  late UserApiService userApiService;
  late CoupleResponseDto _coupleDto;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    userApiService = UserApiService();
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoaded) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    _coupleDto = await userApiService.findCouple(); // 서버에서 CoupleResponseDto 가져오기
    setState(() {
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoaded
            ? Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _coupleDto.nickname, // 닉네임 표시
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
                    _buildMenuCard('뷰 펀딩', Icons.search),
                    _buildMenuCard('뷰 상품 추천', Icons.message),
                    _buildMenuCard('가계부', Icons.attach_money),
                    _buildMenuCard('뷰 자산 리포트', Icons.description),
                  ],
                ),
              ),
            ],
          ),
        )
            : Center(child: CircularProgressIndicator()), // 로딩 중일 때 보여줄 위젯
      ),
      bottomNavigationBar: CustomFooter(
        selectedIndex: 0, // 항상 0으로 설정하여 선택 효과 제거
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildCoupleCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CoupleAssetsScreen(coupleDto: _coupleDto)),
        );
      },
      child: Container(
        height: 160,
        child: Card(
          color: Colors.pink[100],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(_coupleDto.nickname, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_coupleDto.user1Name, style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('1,234,567원', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(_coupleDto.user2Name, style: TextStyle(fontWeight: FontWeight.bold)),
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey[300],
                          child: Icon(Icons.person, size: 30),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(String title, IconData icon) {
    return AspectRatio(
      aspectRatio: 1.5, // 카드의 높이를 줄이기 위해 사용 (비율을 조절하여 높낮이를 변경)
      child: Card(
        child: InkWell(
          onTap: () {
            if (title == '가계부') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HouseholdLedgerScreen()),
              );
            }
          },
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
}
