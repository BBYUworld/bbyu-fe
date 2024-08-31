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

  // Toss-style colors
  final Color _primaryColor = Color(0xFFFF6B6B);
  final Color _backgroundColor = Color(0xFFF9FAFB);
  final Color _cardColor = Colors.white;
  final Color _textColor = Color(0xFF191F28);
  final Color _subTextColor = Color(0xFF8B95A1);

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
            title: Text('사용자 상세 정보', style: TextStyle(color: _textColor, fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  _buildDetailItem('이름', userDto!.name ?? '이름 없음'),
                  _buildDetailItem('나이', userDto!.age?.toString() ?? '나이 정보 없음'),
                  _buildDetailItem('주소', userDto!.address ?? '주소 정보 없음'),
                  _buildDetailItem('월 수입', userDto!.monthlyIncome?.toString() ?? '수입 정보 없음'),
                  _buildDetailItem('전화번호', userDto!.phone ?? '전화번호 없음'),
                  _buildDetailItem('이메일', userDto!.email ?? '이메일 없음'),
                ],
              ),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            actions: <Widget>[
              TextButton(
                child: Text('닫기', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: TextStyle(color: _subTextColor, fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, style: TextStyle(color: _textColor))),
        ],
      ),
    );
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
          title: Text('성공', style: TextStyle(color: _textColor, fontWeight: FontWeight.bold)),
          content: Text('전송이 성공적으로 완료되었습니다.', style: TextStyle(color: _textColor)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actions: <Widget>[
            TextButton(
              child: Text('확인', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
              onPressed: () => Navigator.of(context).pop(),
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
          title: Text('확인', style: TextStyle(color: _textColor, fontWeight: FontWeight.bold)),
          content: Text('커플로 연결하실 사용자가 맞으십니까?', style: TextStyle(color: _textColor)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actions: <Widget>[
            TextButton(
              child: Text('취소', style: TextStyle(color: _subTextColor)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('확인', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
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
      return Center(child: Text("검색 결과가 없습니다.", style: TextStyle(color: _subTextColor)));
    }

    return Card(
      color: _cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: _primaryColor.withOpacity(0.1)),
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('이름: ${userDto!.name ?? '이름 없음'}',
                style: TextStyle(fontWeight: FontWeight.bold, color: _textColor)),
            SizedBox(height: 8.0),
            Text('이메일: ${userDto!.email ?? '이메일 없음'}',
                style: TextStyle(color: _subTextColor)),
            SizedBox(height: 16.0),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                child: Text('선택', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
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
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '배우자 검색',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: _subTextColor),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            SizedBox(height: 24),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '이메일로 검색',
                hintStyle: TextStyle(color: _subTextColor),
                prefixIcon: Icon(Icons.search, color: _subTextColor),
                filled: true,
                fillColor: _backgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: _primaryColor),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
              onSubmitted: (query) => _performSearch(query),
            ),
            SizedBox(height: 24),
            Expanded(
              child: _isSearching
                  ? Center(child: CircularProgressIndicator(color: _primaryColor))
                  : _buildSearchResult(),
            ),
          ],
        ),
      ),
    );
  }
}