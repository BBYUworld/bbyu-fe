import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/analysis/analysis_asset.dart';
import 'package:gagyebbyu_fe/storage/TokenStorage.dart';

final TokenStorage _tokenStorage = TokenStorage();

Future<List<AnalysisAssetCategoryDto>> fetchAssetCategories() async {
  final accessToken = await _tokenStorage.getAccessToken();
  final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/analysis/couple-asset'),
      headers: {
        'Content-Type' : 'application/json',
        'Authorization' : '$accessToken'
      }
  );

  print('Status code: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => AnalysisAssetCategoryDto.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load asset categories');
  }
}

Future<AssetChangeRateDto> fetchAssetChangeRate() async {
  final accessToken = await _tokenStorage.getAccessToken();
  final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/analysis/couple-asset/change-rate'),
      headers: {
        'Content-Type' : 'application/json',
        'Authorization' : '$accessToken'
      });

  if (response.statusCode == 200) {
    return AssetChangeRateDto.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load asset change rate');
  }
}

Future<AnalysisAssetResultDto> fetchAssetResult() async {
  final accessToken = await _tokenStorage.getAccessToken();
  final response = await http.get(
    Uri.parse('http://10.0.2.2:8080/api/analysis/couple-asset/result'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': '$accessToken'
    },
  );

  // 로그 추가
  print('Status code: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    print('Parsed coupleTotalAssets: ${jsonResponse['coupleTotalAssets']}'); // 로그 추가
    return AnalysisAssetResultDto.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to load asset result');
  }

}
