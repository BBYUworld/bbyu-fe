class FundOverview {
  final String goal;
  final int targetAmount;

  FundOverview({
    required this.goal,
    required this.targetAmount,
  });

  factory FundOverview.fromJson(Map<String, dynamic> json) {
    return FundOverview(
      goal: json['goal'],
      targetAmount: json['targetAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fundTransactionId': goal,
      'targetAmount': targetAmount,
    };
  }
}