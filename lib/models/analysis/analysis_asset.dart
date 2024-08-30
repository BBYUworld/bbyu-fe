import 'dart:ffi';

import '../asset/asset_type.dart';

class AssetCategoryDto {
  final AssetType label;
  final int amount;
  final double percentage;

  AssetCategoryDto({required this.label, required this.amount, required this.percentage});

  factory AssetCategoryDto.fromJson(Map<String, dynamic> json) {
    return AssetCategoryDto(
      label: assetTypeFromString(json['label'] as String? ?? ''),
      amount: json['amount'] as int? ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }
}


class AssetChangeRateDto {
  final double totalChangeRate;

  AssetChangeRateDto({required this.totalChangeRate});

  factory AssetChangeRateDto.fromJson(Map<String, dynamic> json) {
    return AssetChangeRateDto(
      totalChangeRate: (json['totalChangeRate'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class AssetResultDto {
  final int startAge;
  final int startIncome;
  final int anotherAssetsAvg;
  final int currentAsset;
  final int lastYearAsset;

  AssetResultDto({
    required this.startAge,
    required this.startIncome,
    required this.anotherAssetsAvg,
    required this.currentAsset,
    required this.lastYearAsset,
  });

  factory AssetResultDto.fromJson(Map<String, dynamic> json) {
    return AssetResultDto(
      startAge: json['startAge'] as int? ?? 0,
      startIncome: json['startIncome'] as int? ?? 0,
      anotherAssetsAvg: json['anotherCoupleAssetAvg'] as int? ?? 0,
      currentAsset: json['currentAsset'] as int? ?? 0,
      lastYearAsset: json['lastYearAsset'] as int? ?? 0,
    );
  }
}

class AnnualAssetDto {
  final int year;
  final double accountAssets;
  final double stockAssets;
  final double realEstateAssets;
  final double loanAssets;
  final double totalAssets;

  AnnualAssetDto({
    required this.year,
    required this.accountAssets,
    required this.stockAssets,
    required this.realEstateAssets,
    required this.loanAssets,
    required this.totalAssets,
  });

  factory AnnualAssetDto.fromJson(Map<String, dynamic> json) {
    return AnnualAssetDto(
      year: json['year'],
      accountAssets: (json['accountAssets'] as num).toDouble(),   // 변경된 부분
      stockAssets: (json['stockAssets'] as num).toDouble(),       // 변경된 부분
      realEstateAssets: (json['realEstateAssets'] as num).toDouble(),
      loanAssets: (json['loanAssets'] as num).toDouble(),
      totalAssets: (json['totalAssets'] as num).toDouble(),
    );
  }
}


