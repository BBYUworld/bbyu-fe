class FundTransactionCreate{
  final int amount;
  final String type;
  final String accountNo;

  FundTransactionCreate({
    required this.amount,
    required this.type,
    required this.accountNo,
  });

  factory FundTransactionCreate.fromJson(Map<String, dynamic> json){
    return FundTransactionCreate(
      amount: json['amount'],
      type: json['type'],
      accountNo: json['accountNo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'type' : type,
      'accountNo' : accountNo,
    };
  }
}
