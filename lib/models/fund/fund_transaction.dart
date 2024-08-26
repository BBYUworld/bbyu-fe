class FundTransaction {
  final int fundTransactionId;
  final int currentAmount;
  final String name;
  final int amount;
  final String type;
  final DateTime date;

  FundTransaction({
    required this.fundTransactionId,
    required this.currentAmount,
    required this.name,
    required this.amount,
    required this.type,
    required this.date,
  });

  factory FundTransaction.fromJson(Map<String, dynamic> json) {
    return FundTransaction(
      fundTransactionId: json['fundTransactionId'],
      currentAmount: json['currentAmount'],
      name: json['name'],
      amount: json['amount'],
      type: json['type'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fundTransactionId': fundTransactionId,

      'name': name,
      'amount': amount,
      'type': type,
      'date': date.toIso8601String(),
    };
  }
}
