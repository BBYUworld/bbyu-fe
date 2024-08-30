import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gagyebbyu_fe/storage/TokenStorage.dart';
import '../account/CreateAccountScreen.dart';
import 'package:gagyebbyu_fe/views/account/ProductDetailScreenDialog.dart';
class AccountLinkScreen extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onComplete;
  final Map<String, dynamic> additionalInfo;
  final VoidCallback onCreateAccount;

  AccountLinkScreen({
    Key? key,
    required this.onComplete,
    required this.additionalInfo,
    required this.onCreateAccount,
  }) : super(key: key);

  @override
  _AccountLinkScreenState createState() => _AccountLinkScreenState();
}

class _AccountLinkScreenState extends State<AccountLinkScreen> with WidgetsBindingObserver {
  bool _isLoading = false;
  bool _dataLoaded = false;
  List<Map<String, dynamic>> _accounts = [];
  Set<int> _selectedAccountIndices = {};
  final TokenStorage _tokenStorage = TokenStorage();
  final Color _primaryColor = Color(0xFFF5E7E0);
  final Color _textColor = Color(0xFF4A4A4A);

  // 은행 이름과 이미지 파일 이름 매핑
  final Map<String, String> _bankImageMap = {
    '한국은행': '금융아이콘_PNG_한국.png',
    '산업은행': '금융아이콘_PNG_산업.png',
    '기업은행': '금융아이콘_PNG_IBK.png',
    '국민은행': '금융아이콘_PNG_KB.png',
    '농협은행': '금융아이콘_PNG_농협.png',
    '우리은행': '금융아이콘_PNG_우리.png',
    'SC제일은행': '금융아이콘_PNG_SC제일.png',
    '시티은행': '금융아이콘_PNG_시티.png',
    '대구은행': '금융아이콘_PNG_대구.png',
    '광주은행': '금융아이콘_PNG_광주.png',
    '제주은행': '금융아이콘_PNG_제주.png',
    '전북은행': '금융아이콘_PNG_전북.png',
    '경남은행': '금융아이콘_PNG_경남.png',
    '새마을금고': '금융아이콘_PNG_MG새마을금고.png',
    'KEB하나은행': '금융아이콘_PNG_하나.png',
    '신한은행': '금융아이콘_PNG_신한.png',
    '카카오뱅크': '금융아이콘_PNG_카카오뱅크.png',
    '싸피은행': '금융아이콘_PNG_싸피.png',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _linkAccount();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _linkAccount();
    }
  }

  void reload() {
    _linkAccount();
  }

  Future<void> _linkAccount() async {
    setState(() {
      _isLoading = true;
      _dataLoaded = false;
    });

    try {
      final url = Uri.parse("http://3.39.19.140:8080/user/account");
      final accessToken = await _tokenStorage.getAccessToken();
      final response = await http.get(
          url,
          headers: {
            'Content-Type': "application/json",
            'Authorization': "$accessToken"
          }
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final List<dynamic> accountsJson = json.decode(decodedBody);
        setState(() {
          _accounts = List<Map<String, dynamic>>.from(accountsJson);
          _dataLoaded = true;
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildDetailItem(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold, color: _textColor)),
          Expanded(child: Text(value.toString(), style: TextStyle(color: _textColor))),
        ],
      ),
    );
  }

  void _showAccountDetails(Map<String, dynamic> account) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TossStyleAccountDetailsDialog(account: account);
      },
    );
  }

  void _toggleAccountSelection(int index) {
    setState(() {
      if (_selectedAccountIndices.contains(index)) {
        _selectedAccountIndices.remove(index);
      } else {
        _selectedAccountIndices.add(index);
      }
    });
  }

  void _confirmAccountLinking() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('계좌 연결 확인', style: TextStyle(color: _textColor)),
          content: Text('${_selectedAccountIndices.length}개의 계좌를 연결하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: Text('취소', style: TextStyle(color: _textColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('확인', style: TextStyle(color: _textColor)),
              onPressed: () {
                Navigator.of(context).pop();
                List<Map<String, dynamic>> selectedAccounts = _selectedAccountIndices
                    .map((index) => _accounts[index])
                    .toList();
                widget.onComplete(selectedAccounts);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '계좌 연결',
          style: TextStyle(
            color: _textColor,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontFamily: 'Roboto',  // 기본 폰트 사용
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: _textColor),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(_textColor)))
          : _buildContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onCreateAccount,
        child: Icon(Icons.add, color: _textColor),
        backgroundColor: Colors.white,
        tooltip: '새로운 계좌 생성',
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        Expanded(
          child: _dataLoaded
              ? _accounts.isEmpty
              ? Center(child: Text('연결된 계좌가 없습니다.', style: TextStyle(color: _textColor)))
              : RefreshIndicator(
            onRefresh: _linkAccount,
            child: ListView.builder(
              itemCount: _accounts.length,
              itemBuilder: (context, index) {
                final account = _accounts[index];
                return _buildAccountCard(account, index);
              },
            ),
          )
              : Center(child: Text('계좌 정보를 확인 중입니다.', style: TextStyle(color: _textColor))),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _selectedAccountIndices.isNotEmpty ? _confirmAccountLinking : null,
            child: Text('${_selectedAccountIndices.length}개의 계좌 연결하기', style: TextStyle(color: _textColor)),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildAccountCard(Map<String, dynamic> account, int index) {
    bool isSelected = _selectedAccountIndices.contains(index);
    String bankName = account['bankName'];
    String imageName = _bankImageMap[bankName] ?? '금융아이콘_PNG_default.png';

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: isSelected ? _textColor : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () => _toggleAccountSelection(index),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Image.asset(
                  'assets/images/$imageName',
                  width: 40,
                  height: 40,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bankName,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textColor),
                    ),
                    SizedBox(height: 8),
                    Text(
                      account['accountNo'],
                      style: TextStyle(fontSize: 16, color: _textColor.withOpacity(0.8)),
                    ),
                    SizedBox(height: 4),
                    Text(
                      account['accountName'],
                      style: TextStyle(fontSize: 14, color: _textColor.withOpacity(0.6)),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.info, color: _textColor),
                    onPressed: () => _showAccountDetails(account),
                  ),
                  Checkbox(
                    value: isSelected,
                    onChanged: (_) => _toggleAccountSelection(index),
                    activeColor: _textColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}