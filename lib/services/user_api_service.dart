import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gagyebbyu_fe/storage/TokenStorage.dart';
import 'package:gagyebbyu_fe/models/couple_model.dart';


class UserApiService {
  static const String baseUrl = 'http://10.0.2.2:8080';
  final TokenStorage _tokenStorage = TokenStorage();

  Future<CoupleResponseDto> findCouple() async {
    final url = Uri.parse('$baseUrl/api/couple');
    final accessToken = await _tokenStorage.getAccessToken();
    final response = await http.get(
      url,
      headers: {
        'Content-Type' : 'application/json',
        'Authorization' : '$accessToken'
      }
    );
    if(response.statusCode == 200){
      final decodedBody = utf8.decode(response.bodyBytes);
      final jsonResponse = json.decode(decodedBody);
      return CoupleResponseDto.fromJson(jsonResponse);
    }
    else{
      throw Exception('Failed to load couple expense data');
    }
  }
}