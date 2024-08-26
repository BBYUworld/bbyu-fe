class CoupleResponseDto {
  final String nickname;
  final DateTime marriedAt;
  final int monthlyTargetAmount;
  final String user1Name;
  final String user2Name;
  final int marriedPeriod;

  CoupleResponseDto({
    required this.nickname,
    required this.marriedAt,
    required this.monthlyTargetAmount,
    required this.user1Name,
    required this.user2Name,
    required this.marriedPeriod,
  });

  factory CoupleResponseDto.fromJson(Map<String, dynamic> json) {
    return CoupleResponseDto(
      nickname: json['nickname'],
      marriedAt: DateTime.parse(json['marriedAt']),
      monthlyTargetAmount: json['monthlyTargetAmount'],
      user1Name: json['user1Name'],
      user2Name: json['user2Name'],
      marriedPeriod: json['marriedPeriod'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'marriedAt': marriedAt.toIso8601String(),
      'monthlyTargetAmount': monthlyTargetAmount,
      'user1Name': user1Name,
      'user2Name': user2Name,
      'marriedPeriod': marriedPeriod,
    };
  }

  @override
  String toString() {
    return 'CoupleResponseDto{nickname: $nickname, marriedAt: $marriedAt, monthlyTargetAmount: $monthlyTargetAmount, user1Name: $user1Name, user2Name: $user2Name, marriedPeriod: $marriedPeriod}';
  }
}
