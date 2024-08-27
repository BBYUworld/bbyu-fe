import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/models/couple_model.dart';
import 'package:gagyebbyu_fe/views/home/Fotter.dart';
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
  CoupleResponseDto? _coupleDto;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    userApiService = UserApiService(context);
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
    _coupleDto = await userApiService.findCouple();
    setState(() {
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        if (_coupleDto != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CoupleAssetsScreen(coupleDto: _coupleDto!)),
          );
        } else {
          // 커플 배우자가 없을 때의 이벤트 처리
          showSearchDialog(context); // 중앙에 위치한 검색창 띄우기
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
                    : SizedBox.shrink(), // 커플 정보가 없을 때는 비어있는 상태 유지
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

  // 중앙에 위치한 검색창 다이얼로그 띄우기
  void showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.7, // 화면 너비의 70%
            height: MediaQuery.of(context).size.height * 0.5, // 화면 높이의 50%
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
