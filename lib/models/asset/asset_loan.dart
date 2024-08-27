import 'package:gagyebbyu_fe/models/asset/asset.dart';
import 'package:intl/intl.dart';

class AssetLoan extends Asset {
  final String loanName;
  final double interestRate;
  final int remainedAmount;

  AssetLoan({
    required int assetId,
    required int userId,
    required int coupleId,
    required String type,
    required String bankName,
    required String bankCode,
    required int amount,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool isEnded,
    required bool isHidden,
    required this.loanName,
    required this.interestRate,
    required this.remainedAmount,
  }) : super(
    assetId: assetId,
    userId: userId,
    coupleId: coupleId,
    type: type,
    bankName: bankName,
    bankCode: bankCode,
    amount: amount,
    createdAt: createdAt,
    updatedAt: updatedAt,
    isEnded: isEnded,
    isHidden: isHidden,
  );

  factory AssetLoan.fromJson(Map<String, dynamic> json) {
    return AssetLoan(
      assetId: json['assetId'],
      userId: json['userId'],
      coupleId: json['coupleId'],
      type: json['type'],
      bankName: json['bankName'],
      bankCode: json['bankCode'],
      amount: json['amount'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isEnded: json['isEnded'],
      isHidden: json['isHidden'],
      loanName: json['loanName'],
      interestRate: json['interestRate'],
      remainedAmount: json['remainedAmount'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data.addAll({
      'loanName': loanName,
      'interestRate': interestRate,
      'remainedAmount': remainedAmount,
    });
    return data;
  }
}

class AssetLoanInfo {
  final List<AssetLoan> assetLoans;
  final int totalLoanAmount;

  AssetLoanInfo({
    required this.assetLoans,
    required this.totalLoanAmount,
  });

  factory AssetLoanInfo.fromJson(List<dynamic> json) {
    var loanList = json.map((loanJson) => AssetLoan.fromJson(loanJson)).toList();
    var totalAmount = loanList.fold(0, (sum, loan) => sum + loan.amount);

    return AssetLoanInfo(
      assetLoans: loanList,
      totalLoanAmount: totalAmount,
    );
  }
}