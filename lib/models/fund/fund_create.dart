class FundCreate {
  final String goal;
  final int targetAmount;

  FundCreate({
    required this.goal,
    required this.targetAmount,
  });

  factory FundCreate.fromJson(Map<String, dynamic> json) {
    return FundCreate(
      goal: json['goal'],
      targetAmount: json['targetAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'goal': goal,
      'targetAmount': targetAmount,
    };
  }
}