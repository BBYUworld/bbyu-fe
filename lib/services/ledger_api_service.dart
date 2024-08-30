import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gagyebbyu_fe/storage/TokenStorage.dart';
import 'package:gagyebbyu_fe/models/user_account.dart';
import 'package:gagyebbyu_fe/models/couple_expense_model.dart';


class LedgerApiService {
  static const String baseUrl = 'http://10.0.2.2:8080';
  final TokenStorage _tokenStorage = TokenStorage();
  Future<Map<String, dynamic>> fetchLedgerData() async {
    final response = await http.get(Uri.parse('$baseUrl/ledger'));

    if (response.statusCode == 200) {
      final data = response.body;
      print('response Data = $data');
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load ledger data');
    }
  }

  Future<List<Account>> fetchUserAccountData() async{
    final accessToken = await _tokenStorage.getAccessToken();
    final response = await http.get(
        Uri.parse('$baseUrl/user/account'),
        headers: {
          'Content-Type' : 'application/json',
          'Authorization' : '$accessToken'
        }
    );
    if (response.statusCode == 200) {
      final decodedResponse = utf8.decode(response.bodyBytes);
      final List<dynamic> jsonData = json.decode(decodedResponse);
      List<Account> accounts = jsonData.map((json) => Account.fromJson(json)).toList();
      print('response Data = $jsonData');
      return accounts;
    } else {
      throw Exception('Failed to load account data');
    }
  }

  Future<List<Account>> fetchCoupleAccountData() async{
    final accessToken = await _tokenStorage.getAccessToken();
    final response = await http.get(
        Uri.parse('$baseUrl/user/couple/account'),
        headers: {
          'Content-Type' : 'application/json',
          'Authorization' : '$accessToken'
        }
    );
    if (response.statusCode == 200) {
      final decodedResponse = utf8.decode(response.bodyBytes);
      final List<dynamic> jsonData = json.decode(decodedResponse);
      List<Account> accounts = jsonData.map((json) => Account.fromJson(json)).toList();
      print('response Data = $jsonData');
      return accounts;
    } else {
      throw Exception('Failed to load account data');
    }
  }

  Future<CoupleExpense> fetchCoupleExpense(int year, int month) async {
    final accessToken = await _tokenStorage.getAccessToken();
    print("fetch Couple Expense Access Token : $accessToken");
    final response = await http.get(
        Uri.parse('$baseUrl/api/expense/month?month=$month&year=$year&sort=desc'),
        headers:{
          'Content-Type' : 'application/json',
          'Authorization' : '$accessToken'
        }
    );
    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final jsonResponse = json.decode(decodedBody);
      return CoupleExpense.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load couple expense data');
    }
  }

  Future<void> fetchUpdateMemo(String memo, int expenseId) async {
    final accessToken = await _tokenStorage.getAccessToken();
    final body = jsonEncode({
      'memo': memo,
    });
    print("fetch Couple Expense Access Token : $accessToken");
    final response = await http.post(
      Uri.parse('$baseUrl/api/expense/memo/$expenseId'),
      headers:{
        'Content-Type' : 'application/json',
        'Authorization' : '$accessToken'
      },
      body: body,
    );
    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final jsonResponse = json.decode(decodedBody);
    } else {
      throw Exception('Failed to load couple expense data');
    }
  }
}