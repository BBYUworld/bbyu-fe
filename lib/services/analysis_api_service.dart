import 'package:gagyebbyu_fe/models/analysis/analysis_expense.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/analysis/analysis_asset.dart';
import 'package:gagyebbyu_fe/storage/TokenStorage.dart';

final TokenStorage _tokenStorage = TokenStorage();
final String baseUrl = 'http://3.39.19.140:8080';

Future<List<AssetCategoryDto>> fetchAssetCategory() async {
  final accessToken = await _tokenStorage.getAccessToken();
  final response = await http.get(
    Uri.parse('$baseUrl/api/analysis/couple-asset'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
  );

  print('Status code: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => AssetCategoryDto.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load asset categories');
  }
}

Future<AssetChangeRateDto> fetchAssetChangeRate() async {
  final accessToken = await _tokenStorage.getAccessToken();
  final response = await http.get(
    Uri.parse('$baseUrl/api/analysis/couple-asset/change-rate'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
  );

  if (response.statusCode == 200) {
    return AssetChangeRateDto.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load asset change rate');
  }
}

Future<AssetResultDto> fetchAssetResult() async {
  final accessToken = await _tokenStorage.getAccessToken();
  final response = await http.get(
    Uri.parse('$baseUrl/api/analysis/couple-asset/result'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
  );

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return AssetResultDto.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to load asset result');
  }
}

Future<List<AnnualAssetDto>> fetchAnnualAssets() async {
  final accessToken = await _tokenStorage.getAccessToken();
  final response = await http.get(
    Uri.parse('$baseUrl/api/analysis/couple-asset/annual'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
  );

  if (response.statusCode == 200) {
    List<AnnualAssetDto> annualAssets = (jsonDecode(response.body) as List)
        .map((item) => AnnualAssetDto.fromJson(item))
        .toList();
    return annualAssets;
  } else {
    throw Exception('Failed to load annual assets');
  }
}

Future<List<ExpenseCategoryDto>> fetchExpenseCategory(int year, int month) async {
  final accessToken = await _tokenStorage.getAccessToken();
  final response = await http.get(
    Uri.parse('$baseUrl/api/analysis/couple-expense?year=$year&month=$month'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
  );

  print('Response Status Code: ${response.statusCode}');
  print('Response Body: ${response.body}');

  if (response.statusCode == 200) {
    if (response.body.isEmpty) {
      throw Exception('Empty response');
    }
    final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
    return data.map((json) => ExpenseCategoryDto.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load expense categories');
  }
}


Future<ExpenseResultDto> fetchExpenseResult(int year, int month) async {
  final accessToken = await _tokenStorage.getAccessToken();
  final response = await http.get(
    Uri.parse('$baseUrl/api/analysis/couple-expense/result?year=$year&month=$month'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
  );

  // 로그 출력: 상태 코드와 응답 본문 확인
  print('Response Status Code: ${response.statusCode}');
  print('Response Body: ${utf8.decode(response.bodyBytes)}');

  if (response.statusCode == 200) {
    return ExpenseResultDto.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else if (response.statusCode == 500) {
    // 서버 오류인 경우 사용자에게 알림
    print('Error: ${response.statusCode} - ${response.reasonPhrase}');
    print('Server Error Message: ${utf8.decode(response.bodyBytes)}');
    throw Exception('서버에 문제가 발생했습니다. 나중에 다시 시도해주세요.');
  } else {
    print('Error: ${response.statusCode} - ${response.reasonPhrase}');
    throw Exception('Failed to load couple expense result');
  }
}


