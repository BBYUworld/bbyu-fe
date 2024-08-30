import 'package:gagyebbyu_fe/models/asset/asset_type.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/analysis/analysis_asset.dart';
import 'package:gagyebbyu_fe/storage/TokenStorage.dart';

final TokenStorage _tokenStorage = TokenStorage();

Future<List<AssetCategoryDto>> fetchAssetCategory() async {
  final accessToken = await _tokenStorage.getAccessToken();
  final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/analysis/couple-asset'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$accessToken'
      });

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
      Uri.parse('http://3.39.19.140:8080/api/analysis/couple-asset/change-rate'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$accessToken'
      });

  if (response.statusCode == 200) {
    return AssetChangeRateDto.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load asset change rate');
  }
}

Future<AssetResultDto> fetchAssetResult() async {
  final accessToken = await _tokenStorage.getAccessToken();
  final response = await http.get(
    Uri.parse('http://10.0.2.2:8080/api/analysis/couple-asset/result'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
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
    Uri.parse('http://10.0.2.2:8080/api/analysis/couple-asset/annual'),
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
