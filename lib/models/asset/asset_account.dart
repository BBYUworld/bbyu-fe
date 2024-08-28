import 'package:gagyebbyu_fe/models/asset/asset.dart';
import 'package:intl/intl.dart';

class AssetAccount extends Asset {
  final String accountNumber;
  final String accountType;
  final int? oneTimeTransferLimit;
  final int? dailyTransferLimit;
  final DateTime? maturityDate;
  final double interestRate;
  final int? term;

  AssetAccount({
    required int assetId,
    required int userId,
    required int? coupleId, // nullable 처리
    required String type,
    required String bankName,
    required String bankCode,
    required int amount,
    required DateTime createdAt,
    required DateTime updatedAt,
    required bool isEnded,
    required bool isHidden,
    required this.accountNumber,
    required this.accountType,
    this.oneTimeTransferLimit,
    this.dailyTransferLimit,
    this.maturityDate,
    required this.interestRate,
    this.term,
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

  factory AssetAccount.fromJson(Map<String, dynamic> json) {
    return AssetAccount(
      assetId: json['assetId'] as int,
      userId: json['userId'] as int,
      coupleId: json['coupleId'] != null ? json['coupleId'] as int : null, // nullable 처리
      type: json['type'] as String,
      bankName: json['bankName'] as String,
      bankCode: json['bankCode'] as String,
      amount: json['amount'] as int,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isEnded: json['isEnded'] as bool,
      isHidden: json['isHidden'] as bool,
      accountNumber: json['accountNumber'] as String,
      accountType: json['accountType'] as String,
      oneTimeTransferLimit: json['oneTimeTransferLimit'] != null ? json['oneTimeTransferLimit'] as int : null,
      dailyTransferLimit: json['dailyTransferLimit'] != null ? json['dailyTransferLimit'] as int : null,
      maturityDate: json['maturityDate'] != null ? DateTime.parse(json['maturityDate']) : null,
      interestRate: (json['interestRate'] as num).toDouble(),
      term: json['term'] != null ? json['term'] as int : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data.addAll({
      'accountNumber': accountNumber,
      'accountType': accountType,
      'oneTimeTransferLimit': oneTimeTransferLimit,
      'dailyTransferLimit': dailyTransferLimit,
      'maturityDate': maturityDate?.toIso8601String(),
      'interestRate': interestRate,
      'term': term,
    });
    return data;
  }
}

class AssetAccountInfo {
  final List<AssetAccount> accounts;
  final int totalAmount;

  AssetAccountInfo({
    required this.accounts,
    required this.totalAmount,
  });

  factory AssetAccountInfo.fromJson(List<dynamic> json) {
    var accountList = json.map((accountJson) => AssetAccount.fromJson(accountJson)).toList();
    var totalAmount = accountList.fold(0, (sum, account) => sum + account.amount);

    return AssetAccountInfo(
      accounts: accountList,
      totalAmount: totalAmount,
    );
  }
}