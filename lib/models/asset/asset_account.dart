import 'package:gagyebbyu_fe/models/asset/asset.dart';
import 'package:intl/intl.dart';

class AssetAccount extends Asset {
  final String accountNumber;
  final String accountType;
  final int oneTimeTransferLimit;
  final int dailyTransferLimit;
  final DateTime? maturityDate;
  final double interestRate;
  final int term;

  AssetAccount({
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
    required this.accountNumber,
    required this.accountType,
    required this.oneTimeTransferLimit,
    required this.dailyTransferLimit,
    this.maturityDate,
    required this.interestRate,
    required this.term,
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
      accountNumber: json['accountNumber'],
      accountType: json['accountType'],
      oneTimeTransferLimit: json['oneTimeTransferLimit'],
      dailyTransferLimit: json['dailyTransferLimit'],
      maturityDate: json['maturityDate'] != null ? DateTime.parse(json['maturityDate']) : null,
      interestRate: json['interestRate'],
      term: json['term'],
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