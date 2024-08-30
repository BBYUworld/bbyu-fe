class AccountRecommendation {
  final List<RecommendedAccount> depositAccounts;
  final List<RecommendedAccount> savingsAccounts;

  AccountRecommendation({
    required this.depositAccounts,
    required this.savingsAccounts,
  });

  factory AccountRecommendation.fromJson(Map<String, dynamic> json) {
    return AccountRecommendation(
      depositAccounts: (json['depositAccounts'] as List)
          .map((account) => RecommendedAccount.fromJson(account))
          .toList(),
      savingsAccounts: (json['savingsAccounts'] as List)
          .map((account) => RecommendedAccount.fromJson(account))
          .toList(),
    );
  }
}

class RecommendedAccount {
  final int id;
  final double pred;
  final AccountDto accountDto;

  RecommendedAccount({
    required this.id,
    required this.pred,
    required this.accountDto,
  });

  factory RecommendedAccount.fromJson(Map<String, dynamic> json) {
    return RecommendedAccount(
      id: json['deposit_id'] ?? json['savings_id'],
      pred: json['pred'],
      accountDto: AccountDto.fromJson(json['depositDto'] ?? json['savingsDto']),
    );
  }
}

class AccountDto {
  final int id;
  final double interestRate;
  final int termMonths;
  final int minAmount;
  final int maxAmount;
  final String interestPaymentMethod;
  final String name;
  final String bankName;
  final String description;
  final String accountTypeUniqueNo;

  AccountDto({
    required this.id,
    required this.interestRate,
    required this.termMonths,
    required this.minAmount,
    required this.maxAmount,
    required this.interestPaymentMethod,
    required this.name,
    required this.bankName,
    required this.description,
    required this.accountTypeUniqueNo
  });

  factory AccountDto.fromJson(Map<String, dynamic> json) {
    return AccountDto(
      id: json['depositId'] ?? json['savingsId'],
      interestRate: json['depositInterestRate'] ?? json['savingsInterestRate'],
      termMonths: json['termMonths'],
      minAmount: json['minDepositAmount'] ?? json['minSavingsAmount'],
      maxAmount: json['maxDepositAmount'] ?? json['maxSavingsAmount'],
      interestPaymentMethod: json['depositInterestPaymentMethod'] ?? json['savingsInterestPaymentMethod'],
      name: json['depositName'] ?? json['savingsName'],
      bankName: json['bankName'],
      description: json['description'],
      accountTypeUniqueNo: json['accountTypeUniqueNo']
    );
  }
}