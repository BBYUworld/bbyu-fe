class CoupleResponse {
  final int coupleId;
  final String nickname;
  final DateTime marriedAt;
  final int monthlyTargetAmount;
  final String user1Name;
  final String user2Name;
  final String user1RatingName;
  final String user2RatingName;
  final int marriedPeriod;

  CoupleResponse({
    required this.coupleId,
    required this.nickname,
    required this.marriedAt,
    required this.monthlyTargetAmount,
    required this.user1Name,
    required this.user2Name,
    required this.user1RatingName,
    required this.user2RatingName,
    required this.marriedPeriod,
  });

  factory CoupleResponse.fromJson(Map<String, dynamic> json) {
    return CoupleResponse(
      coupleId: json['coupleId'],
      nickname: json['nickname'],
      marriedAt: DateTime.parse(json['marriedAt']),
      monthlyTargetAmount: json['monthlyTargetAmount'],
      user1Name: json['user1Name'],
      user2Name: json['user2Name'],
      user1RatingName: json['user1RatingName'],
      user2RatingName: json['user2RatingName'],
      marriedPeriod: json['marriedPeriod'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'couple': coupleId,
      'nickname': nickname,
      'marriedAt': marriedAt.toIso8601String(),
      'monthlyTargetAmount': monthlyTargetAmount,
      'user1Name': user1Name,
      'user2Name': user2Name,
      'marriedPeriod': marriedPeriod,
      'user1RatingName': user1RatingName,
      'user2RatingName': user2RatingName
    };
  }
}
