import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
  void initState() {
    super.initState();
  }
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
                child: Text('닫기'),
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
    final message = await userApiService.connectCouple(userId);
  }

  Future<void> _showConfirmationDialog(int userId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // 사용자가 대화 상자 외부를 탭하여 닫는 것을 방지
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('확인'),
          content: Text('커플로 연결하실 사용자가 맞으십니까?'),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('확인'),
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: '배우자 검색',
                border: OutlineInputBorder(),
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
                  ? Center(child: CircularProgressIndicator())
                  : userDto != null
                  ? ListView(
                children: [
                  ListTile(
                    title: Text(userDto!.name ?? '이름 없음'),
                    subtitle: Text('나이: ${userDto!.age?.toString() ?? '나이 정보 없음'}, 주소: ${userDto!.address ?? '주소 정보 없음'}'),
                    trailing: ElevatedButton(
                      child: Text('선택'),
                      onPressed: () => _showConfirmationDialog(userDto!.userId ?? 0),
                    ),
                    onTap: _showUserDetails,
                  ),
                ],
              )
                  : Center(child: Text("검색 결과가 없습니다.")),
            ),
          ],
        ),
      ),
    );
  }
}