class BankProduct {
  final String accountTypeUniqueNo;
  final String bankCode;
  final String bankName;
  final String accountTypeCode;
  final String accountTypeName;
  final String accountName;
  final String accountDescription;
  final String accountType;

  BankProduct({
    required this.accountTypeUniqueNo,
    required this.bankCode,
    required this.bankName,
    required this.accountTypeCode,
    required this.accountTypeName,
    required this.accountName,
    required this.accountDescription,
    required this.accountType,
  });

  factory BankProduct.fromJson(Map<String, dynamic> json) {
    return BankProduct(
      accountTypeUniqueNo: json['accountTypeUniqueNo'],
      bankCode: json['bankCode'],
      bankName: json['bankName'],
      accountTypeCode: json['accountTypeCode'],
      accountTypeName: json['accountTypeName'],
      accountName: json['accountName'],
      accountDescription: json['accountDescription'],
      accountType: json['accountType'],
    );
  }
}