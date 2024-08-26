import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gagyebbyu_fe/storage/TokenStorage.dart';
import 'dart:convert';

// FundOverViewDto 클래스 정의
class FundOverViewDto {
  final int fundId;
  final String goal;
  final int targetAmount;
  final int currentAmount;
  final int isEmergencyUsed;
  final int emergencyCount;
  final DateTime startDate;
  final DateTime endDate;

  FundOverViewDto({
    required this.fundId,
    required this.goal,
    required this.targetAmount,
    required this.currentAmount,
    required this.isEmergencyUsed,
    required this.emergencyCount,
    required this.startDate,
    required this.endDate,
  });

  factory FundOverViewDto.fromJson(Map<String, dynamic> json) {
    return FundOverViewDto(
      fundId: json['fundId'],
      goal: json['goal'],
      targetAmount: json['targetAmount'],
      currentAmount: json['currentAmount'],
      isEmergencyUsed: json['isEmergencyUsed'],
      emergencyCount: json['emergencyCount'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }
}

class FundView extends StatefulWidget {
  @override
  _FundViewState createState() => _FundViewState();
}

class _FundViewState extends State<FundView> {
  late Future<FundOverViewDto> _fundOverviewFuture;
  final TokenStorage _tokenStorage = TokenStorage();

  @override
  void initState() {
    super.initState();
    // coupleId를 하드코딩으로 1로 설정
    _fundOverviewFuture = fetchFundOverview(1);
  }

  // API 요청 함수
  Future<FundOverViewDto> fetchFundOverview(int coupleId) async {
    final url = Uri.parse('http://10.0.2.2:8080/api/fund/$coupleId');
    final accessToken = await _tokenStorage.getAccessToken();
    print(url);
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      // 응답을 UTF-8로 디코딩
      final decodedBody = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(decodedBody);
        return FundOverViewDto.fromJson(jsonResponse);
      } else {
        print('Failed to load fund overview. Status code: ${response.statusCode}');
        print('Response body: $decodedBody');
        throw Exception('Failed to load fund overview');
      }
    } catch (e) {
      print('Error fetching fund overview: $e');
      throw Exception('Error fetching fund overview: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '펀드 관리',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<FundOverViewDto>(
        future: _fundOverviewFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('데이터를 불러오는데 실패했습니다.\n${snapshot.error}'));
          } else if (snapshot.hasData) {
            final fundData = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _buildGoalCard(fundData),
                  SizedBox(height: 16),
                  _buildEmergencyCard(fundData),
                  SizedBox(height: 16),
                  _buildDateCard(fundData),
                ],
              ),
            );
          } else {
            return Center(child: Text('표시할 데이터가 없습니다.'));
          }
        },
      ),
    );
  }

  Widget _buildGoalCard(FundOverViewDto data) {
    double progress = (data.currentAmount / data.targetAmount).clamp(0, 1);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('목표: ${data.goal}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Text('목표 금액: ${_formatCurrency(data.targetAmount)}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('현재 모은 금액: ${_formatCurrency(data.currentAmount)}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: Colors.grey[300],
              color: Colors.blueAccent,
            ),
            SizedBox(height: 8),
            Text(
              '달성률: ${(progress * 100).toStringAsFixed(2)}%',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyCard(FundOverViewDto data) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('비상금 사용 현황', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Row(
              children: [
                Text('사용 여부: ', style: TextStyle(fontSize: 16)),
                Text(
                  data.isEmergencyUsed > 0 ? '사용함' : '사용 안함',
                  style: TextStyle(
                    fontSize: 16,
                    color: data.isEmergencyUsed > 0 ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('비상금 사용 횟수: ${data.emergencyCount}회', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCard(FundOverViewDto data) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('펀드 기간', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Text('시작일: ${_formatDate(data.startDate)}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('종료일: ${_formatDate(data.endDate)}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('남은 기간: ${_calculateRemainingDays(data.endDate)}일', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(int amount) {
    return '${amount.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match.group(1)},')}원';
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  int _calculateRemainingDays(DateTime endDate) {
    final now = DateTime.now();
    final difference = endDate.difference(now).inDays;
    return difference > 0 ? difference : 0;
  }
}