import '../asset/asset_type.dart';

class AnalysisAssetCategoryDto {
  final AssetType label;
  final int amount;
  final double percentage;

  AnalysisAssetCategoryDto({required this.label, required this.amount, required this.percentage});

  factory AnalysisAssetCategoryDto.fromJson(Map<String, dynamic> json) {
    return AnalysisAssetCategoryDto(
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

class AnalysisAssetResultDto {
  final int startAge;
  final double coupleTotalAssets;
  final double averageAssets;

  AnalysisAssetResultDto({
    required this.startAge,
    required this.coupleTotalAssets,
    required this.averageAssets,
  });

  factory AnalysisAssetResultDto.fromJson(Map<String, dynamic> json) {
    return AnalysisAssetResultDto(
      startAge: json['startAge'] as int? ?? 0,
      coupleTotalAssets: (json['coupleTotalAssets'] as num?)?.toDouble() ?? 0.0,
      averageAssets: (json['averageAssets'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
