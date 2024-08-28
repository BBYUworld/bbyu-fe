import 'package:intl/intl.dart';

class Loan {
  final int loanId;
  final String bankCode;
  final String bankName;
  final String ratingName;
  final String loanName;
  final int loanPeriod;
  final int minBalance;
  final int maxBalance;
  final double interestRate;
  final String accountType;
  final String loanTypeCode;
  final String loanTypeName;
  final String repaymentCode;
  final String repaymentName;
  final DateTime startDate;

  Loan({
    required this.loanId,
    required this.bankCode,
    required this.bankName,
    required this.ratingName,
    required this.loanName,
    required this.loanPeriod,
    required this.minBalance,
    required this.maxBalance,
    required this.interestRate,
    required this.accountType,
    required this.loanTypeCode,
    required this.loanTypeName,
    required this.repaymentCode,
    required this.repaymentName,
    required this.startDate,
  });

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      loanId: json['loanId'],
      bankCode: json['bankCode'],
      bankName: json['bankName'],
      ratingName: json['ratingName'],
      loanName: json['loanName'],
      loanPeriod: json['loanPeriod'],
      minBalance: json['minBalance'],
      maxBalance: json['maxBalance'],
      interestRate: (json['interestRate'] as num).toDouble(),
      accountType: json['accountType'],
      loanTypeCode: json['loanTypeCode'],
      loanTypeName: json['loanTypeName'],
      repaymentCode: json['repaymentCode'],
      repaymentName: json['repaymentName'],
      startDate: DateTime.parse(json['startDate']),
    );
  }
}