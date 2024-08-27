import 'package:intl/intl.dart';

class Asset {
  final int assetId;
  final int userId;
  final int coupleId;
  final String type;
  final String bankName;
  final String bankCode;
  final int amount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isEnded;
  final bool isHidden;

  Asset({
    required this.assetId,
    required this.userId,
    required this.coupleId,
    required this.type,
    required this.bankName,
    required this.bankCode,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
    required this.isEnded,
    required this.isHidden,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'assetId': assetId,
      'userId': userId,
      'coupleId': coupleId,
      'type': type,
      'bankName': bankName,
      'bankCode': bankCode,
      'amount': amount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isEnded': isEnded,
      'isHidden': isHidden,
    };
  }
}

class AssetInfo {
  final List<Asset> assets;
  final int totalAmount;

  AssetInfo({
    required this.assets,
    required this.totalAmount,
  });

  factory AssetInfo.fromJson(List<dynamic> json) {
    var assetList = json.map((assetJson) => Asset.fromJson(assetJson)).toList();
    var totalAmount = assetList.fold(0, (sum, asset) => sum + asset.amount);

    return AssetInfo(
      assets: assetList,
      totalAmount: totalAmount,
    );
  }
}