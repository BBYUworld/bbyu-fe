import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gagyebbyu_fe/storage/TokenStorage.dart';
import 'package:gagyebbyu_fe/models/couple_model.dart';
import 'package:gagyebbyu_fe/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:gagyebbyu_fe/storage/user_store.dart';
import 'package:gagyebbyu_fe/models/notification_model.dart';

class UserApiService {
  static const String baseUrl = 'http://10.0.2.2:8080';
  final TokenStorage _tokenStorage = TokenStorage();
  final BuildContext context;

  UserApiService(this.context);


  Future<UserDto?> findUserInfo(email) async{
    final url = Uri.parse('$baseUrl/user/find?email=$email');
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
      print('jsonResponse = $jsonResponse');
      return UserDto.fromJson(jsonResponse);
    }
    else{
      return null;
    }
  }
  
  Future<CoupleResponseDto?> findCouple() async {
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
      return null;
    }
  }

  Future<String> sendConnectNotification(int receiverId)async {
    final url = Uri.parse('$baseUrl/notify');
    final accessToken = await _tokenStorage.getAccessToken();
    final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$accessToken'
        },
        body: jsonEncode({
          'receiverId': receiverId.toString()
        })
    );
    if(response.statusCode == 200){
      return "success";
    }
    else{
      return "fail";
    }
  }

  Future<List<NotificationDto>> findAllNotification() async {
    final accessToken = await _tokenStorage.getAccessToken();
    final url = Uri.parse('$baseUrl/notify');
    final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$accessToken'
        }
    );

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final jsonResponse = json.decode(decodedBody) as List;
      print("response about notification = $jsonResponse");

      // JSON 리스트를 NotificationDto 객체 리스트로 변환
      return jsonResponse.map((item) => NotificationDto.fromJson(item)).toList();
    } else {
      // 에러 처리
      print('Failed to load notifications: ${response.statusCode}');
      throw Exception('Failed to load notifications');
    }
  }

  Future<String> deleteNotification(int notificationId) async{
    final url = Uri.parse('$baseUrl/notify');
    final accessToken = await _tokenStorage.getAccessToken();
    final response = await http.delete(
      url,
      headers: {
        'Content-Type' : 'application/json',
        'Authorization' : '$accessToken'
      }
    );
    if(response.statusCode == 200){
      return "success";
    }
    else{
      throw new Exception();
    }
  }
  Future<String> updateNotification(int notificationId) async{
    final url = Uri.parse('$baseUrl/notify');
    final accessToken = await _tokenStorage.getAccessToken();
    final response = await http.put(
      url,
      headers:{
        'Content-Type' : 'application/json',
        'Authorization' : '$accessToken'
      }
    );
    if(response.statusCode == 200){
      return "success";
    }
    else{
      throw new Exception();
    }
  }
  Future<int> createCoupleRequest(int senderId, int receiverId) async{
    final url = Uri.parse('$baseUrl/api/couple/request');
    final accessToken = await _tokenStorage.getAccessToken();
    final response = await http.post(
      url,
      headers:{
        'Content-Type' : 'application/json',
        'Authorization' : '$accessToken'
      },
      body: jsonEncode({
        'user1Id' : senderId.toString(),
        'nickname' : '커플입니다',
        'monthlyTargetAmount' : '0',
      })
    );
    if (response.statusCode == 201) { // CREATED 상태 코드
      // 응답 본문에서 coupleId를 추출합니다.
      final coupleId = json.decode(response.body) as int;
      return coupleId;
    } else {
      // 오류 처리
      throw Exception('Failed to create couple request: ${response.statusCode}');
    }
  }

  Future<int> getCoupleId(int senderId, int receiverId) async{
    await createCoupleRequest(senderId, receiverId);
    final url = Uri.parse('$baseUrl/api/couple/$senderId');
    final accessToken = await _tokenStorage.getAccessToken();
    final response = await http.get(
        url,
        headers:{
          'Content-Type' : 'application/json',
          'Authorization' : '$accessToken'
        }
    );
    int coupleId = 0;

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final coupleId = data['coupleId'] as int?;
      print("coupleId = $coupleId");
      if (coupleId != null) {
        return coupleId;
      } else {
        throw Exception('Couple ID is null');
      }
    } else {
      throw Exception('Failed to get couple ID: ${response.statusCode}');
    }
  }

  Future<bool> connectCouple(int senderId, int receiverId) async{
    int coupleId = await createCoupleRequest(senderId, receiverId);
    final url = Uri.parse('$baseUrl/api/couple/connect/$coupleId');
    final accessToken = await _tokenStorage.getAccessToken();
    final response = await http.post(
        url,
        headers:{
          'Content-Type' : 'application/json',
          'Authorization' : '$accessToken'
        },
      body: jsonEncode({
        'user2Id' : '$receiverId'
      })
    );

    if(response.statusCode == 200){
      return true;
    }
    else{
      return false;
    }
  }

  Future<void> getUnreadNotificationCnt(BuildContext context) async {
    final url = Uri.parse('$baseUrl/notify/count');
    final accessToken = await _tokenStorage.getAccessToken();
    final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$accessToken'
        }
    );

    if (response.statusCode == 200) {
      int count = int.parse(response.body);
      Provider.of<UserStore>(context, listen: false).setUnreadCnt(count);
    } else {
      throw Exception('Failed to get unread notification count');
    }
  }
}