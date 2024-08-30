import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/services/user_api_service.dart';
import 'package:gagyebbyu_fe/models/user_model.dart';

class SearchModal extends StatefulWidget {
  @override
  _SearchModalState createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> {
  final TextEditingController _searchController = TextEditingController();
  late UserApiService userApiService;
  UserDto? userDto;
  bool _isSearching = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userApiService = UserApiService(context);
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isSearching = true;
    });
    userDto = await userApiService.findUserInfo(query);
    setState(() {
      _isSearching = false;
    });
  }

  void _showUserDetails() {
    if (userDto != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('사용자 상세 정보'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('이름: ${userDto!.name ?? '이름 없음'}'),
                  Text('나이: ${userDto!.age?.toString() ?? '나이 정보 없음'}'),
                  Text('주소: ${userDto!.address ?? '주소 정보 없음'}'),
                  Text('월 수입: ${userDto!.monthlyIncome?.toString() ?? '수입 정보 없음'}'),
                  Text('전화번호: ${userDto!.phone ?? '전화번호 없음'}'),
                  Text('이메일: ${userDto!.email ?? '이메일 없음'}'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('닫기', style: TextStyle(color: Color(0xFF0066FF))),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _selectUser(int userId) async {
    final message = await userApiService.sendConnectNotification(userId);
    _showSuccessDialog(context);
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('성공'),
          content: Text('전송이 성공적으로 완료되었습니다.'),
          actions: <Widget>[
            TextButton(
              child: Text('확인', style: TextStyle(color: Color(0xFF0066FF))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showConfirmationDialog(int userId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('확인'),
          content: Text('커플로 연결하실 사용자가 맞으십니까?'),
          actions: <Widget>[
            TextButton(
              child: Text('취소', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('확인'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Color(0xFFF5E7E0), // 버튼의 색상을 변경
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _selectUser(userId);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchResult() {
    if (userDto == null) {
      return Center(child: Text("검색 결과가 없습니다."));
    }

    return Card(
      color: Colors.pink[100], // 카드의 배경색을 변경
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // 카드 크기를 줄이기 위한 여백 설정
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('이름: ${userDto!.name ?? '이름 없음'}', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),
            Text('이메일: ${userDto!.email ?? '이메일 없음'}'),
            SizedBox(height: 16.0),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                child: Text('선택'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Color(0xFFF5E7E0), // 버튼의 색상을 변경
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => _showConfirmationDialog(userDto!.userId ?? 0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo1-removebg-preview.png',
                  height: 50.0,
                  width: 50.0,
                ),
                SizedBox(width: 12.0),
                Text(
                  '배우자 검색',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.grey),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Color(0xFF0066FF)),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              ),
              onSubmitted: (query) {
                _performSearch(query);
              },
            ),
            SizedBox(height: 16),
            Divider(thickness: 2, color: Colors.grey[300]),
            SizedBox(height: 16),
            Expanded(
              child: _isSearching
                  ? Center(child: CircularProgressIndicator(color: Color(0xFF0066FF)))
                  : _buildSearchResult(),
            ),
          ],
        ),
      ),
    );
  }
}
