class Account {
  final String bankCode;
  final String bankName;
  final String userName;
  final String accountNo;
  final String accountName;
  final String accountTypeCode;
  final String accountTypeName;
  final String accountCreatedDate;
  final String accountExpiryDate;
  final int dailyTransferLimit;
  final int oneTimeTransferLimit;
  final int accountBalance;
  final String lastTransactionDate;
  final String currency;

  Account({
    required this.bankCode,
    required this.bankName,
    required this.userName,
    required this.accountNo,
    required this.accountName,
    required this.accountTypeCode,
    required this.accountTypeName,
    required this.accountCreatedDate,
    required this.accountExpiryDate,
    required this.dailyTransferLimit,
    required this.oneTimeTransferLimit,
    required this.accountBalance,
    required this.lastTransactionDate,
    required this.currency,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      bankCode: json['bankCode'],
      bankName: json['bankName'],
      userName: json['userName'],
      accountNo: json['accountNo'],
      accountName: json['accountName'],
      accountTypeCode: json['accountTypeCode'],
      accountTypeName: json['accountTypeName'],
      accountCreatedDate: json['accountCreatedDate'],
      accountExpiryDate: json['accountExpiryDate'],
      dailyTransferLimit: json['dailyTransferLimit'],
      oneTimeTransferLimit: json['oneTimeTransferLimit'],
      accountBalance: json['accountBalance'],
      lastTransactionDate: json['lastTransactionDate'],
      currency: json['currency'],
    );
  }
}