class FundOverview {
  final int fundId;
  final String goal;
  final int targetAmount;
  final int currentAmount;
  final int isEmergencyUsed;
  final int emergencyCount;
  final DateTime startDate;
  final DateTime endDate;

  FundOverview({
    required this.fundId,
    required this.goal,
    required this.targetAmount,
    required this.currentAmount,
    required this.isEmergencyUsed,
    required this.emergencyCount,
    required this.startDate,
    required this.endDate,
  });

  factory FundOverview.fromJson(Map<String, dynamic> json) {
    return FundOverview(
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