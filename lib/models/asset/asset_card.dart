import 'package:gagyebbyu_fe/models/asset/asset.dart';
import 'package:intl/intl.dart';

class AssetCard extends Asset {
  final String cardNumber;
  final String cardName;
  final String cardType;

  AssetCard({
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
    required this.cardNumber,
    required this.cardName,
    required this.cardType,
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

  factory AssetCard.fromJson(Map<String, dynamic> json) {
    return AssetCard(
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
      cardNumber: json['cardNumber'],
      cardName: json['cardName'],
      cardType: json['cardType'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data.addAll({
      'cardNumber': cardNumber,
      'cardName': cardName,
      'cardType': cardType,
    });
    return data;
  }
}

class AssetCardInfo {
  final List<AssetCard> cards;
  final int totalAmount;

  AssetCardInfo({
    required this.cards,
    required this.totalAmount,
  });

  factory AssetCardInfo.fromJson(List<dynamic> json) {
    var cardList = json.map((cardJson) => AssetCard.fromJson(cardJson)).toList();
    var totalAmount = cardList.fold(0, (sum, card) => sum + card.amount);

    return AssetCardInfo(
      cards: cardList,
      totalAmount: totalAmount,
    );
  }
}