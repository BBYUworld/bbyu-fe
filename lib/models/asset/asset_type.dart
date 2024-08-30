enum AssetType {
  CARD,
  ACCOUNT,
  LOAN,
  STOCK,
  REAL_ESTATE
}

AssetType assetTypeFromString(String label) {
  return AssetType.values.firstWhere((e) => e.toString().split('.').last == label);
}
