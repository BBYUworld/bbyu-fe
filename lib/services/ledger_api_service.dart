import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gagyebbyu_fe/storage/TokenStorage.dart';
import 'package:gagyebbyu_fe/models/user_account.dart';
import 'package:gagyebbyu_fe/models/expense/couple_expense_model.dart';

import '../models/expense/couple_expense_model.dart';


class LedgerApiService {
  static const String baseUrl = 'http://3.39.19.140:8080';
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

  Future<void> fetchUpdateMemo(int expenseId, String memo) async {
    final accessToken = await _tokenStorage.getAccessToken();
    final body = jsonEncode({
      'memo': memo,
    });

    final response = await http.post(
      Uri.parse('$baseUrl/api/expense/memo/$expenseId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print('Memo updated successfully');
    } else {
      print('Failed to update memo. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to update memo');
    }
  }

  Future<void> fetchUpdateAmount(int expenseId, int amount) async {
    final accessToken = await _tokenStorage.getAccessToken();
    final url = Uri.parse('$baseUrl/api/expense/$expenseId');
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({'amount': amount}),
    );

    if (response.statusCode == 200) {
      print('Amount updated successfully');
    } else {
      print('Failed to update amount. Status code: ${response.statusCode}');
      throw Exception('Failed to update amount');
    }
  }

  Future<void> fetchUpdateCategory(int expenseId, String category) async {
    final accessToken = await _tokenStorage.getAccessToken();
    final url = Uri.parse('$baseUrl/api/expense/category/$expenseId');
    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({'category': category}),
    );

    if (response.statusCode == 200) {
      print('Category updated successfully');
    } else {
      print('Failed to update category. Status code: ${response.statusCode}');
      throw Exception('Failed to update category');
    }
  }

}