class CoupleLoanRecommendation {
  final int user1Id;
  final int user2Id;
  final String user1Name;
  final String user2Name;
  final String user1Gender;
  final String user2Gender;
  final List<CoupleLoanRecommend> coupleLoanRecommends;

  CoupleLoanRecommendation({
    required this.user1Id,
    required this.user2Id,
    required this.user1Name,
    required this.user2Name,
    required this.user1Gender,
    required this.user2Gender,
    required this.coupleLoanRecommends,
  });

  factory CoupleLoanRecommendation.fromJson(Map<String, dynamic> json) {
    return CoupleLoanRecommendation(
      user1Id: json['user1Id'],
      user2Id: json['user2Id'],
      user1Name: json['user1Name'],
      user2Name: json['user2Name'],
      user1Gender: json['user1Gender'],
      user2Gender: json['user2Gender'],
      coupleLoanRecommends: (json['coupleLoanRecommends'] as List)
          .map((i) => CoupleLoanRecommend.fromJson(i))
          .toList(),
    );
  }
}

class CoupleLoanRecommend {
  final double totalPayment;
  final LoanRecommend recommendUser1;
  final LoanRecommend recommendUser2;

  CoupleLoanRecommend({
    required this.totalPayment,
    required this.recommendUser1,
    required this.recommendUser2,
  });

  factory CoupleLoanRecommend.fromJson(Map<String, dynamic> json) {
    return CoupleLoanRecommend(
      totalPayment: json['totalPayment'],
      recommendUser1: LoanRecommend.fromJson(json['recommendUser1']),
      recommendUser2: LoanRecommend.fromJson(json['recommendUser2']),
    );
  }
}

class LoanRecommend {
  final int loanId;
  final double interestRate;
  final int loanLimit;
  final String bankName;
  final String loanName;
  final String ratingName;
  final int loanTermMonths;
  final int creditScoreRequirement;
  final double ratio;
  final double dsr;
  final double stressDsr;

  LoanRecommend({
    required this.loanId,
    required this.interestRate,
    required this.loanLimit,
    required this.bankName,
    required this.loanName,
    required this.ratingName,
    required this.loanTermMonths,
    required this.creditScoreRequirement,
    required this.ratio,
    required this.dsr,
    required this.stressDsr,
  });

  factory LoanRecommend.fromJson(Map<String, dynamic> json) {
    return LoanRecommend(
      loanId: json['loanId'],
      interestRate: json['interestRate'],
      loanLimit: json['loanLimit'],
      bankName: json['bankName'],
      loanName: json['loanName'],
      ratingName: json['ratingName'],
      loanTermMonths: json['loanTermMonths'],
      creditScoreRequirement: json['creditScoreRequirement'],
      ratio: json['ratio'],
      dsr: json['dsr'],
      stressDsr: json['stressDsr'],
    );
  }
}