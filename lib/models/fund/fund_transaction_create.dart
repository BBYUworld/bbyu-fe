class FundTransactionCreate{
  final int amount;
  final String type;

  FundTransactionCreate({
    required this.amount,
    required this.type,
  });

  factory FundTransactionCreate.fromJson(Map<String, dynamic> json){
    return FundTransactionCreate(
      amount: json['amount'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'type' : type,
    };
  }
}
