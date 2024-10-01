import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/models/asset/asset_account.dart';
import 'package:gagyebbyu_fe/models/couple_model.dart';
import 'package:gagyebbyu_fe/models/asset/asset.dart';
import 'package:gagyebbyu_fe/services/api_service.dart';
import 'package:intl/intl.dart';

class CoupleAssetsScreen extends StatefulWidget {
  final CoupleResponseDto coupleDto;

  CoupleAssetsScreen({required this.coupleDto});

  @override
  _CoupleAssetsScreenState createState() => _CoupleAssetsScreenState();
}

class _CoupleAssetsScreenState extends State<CoupleAssetsScreen> {
  final Color _primaryColor = Color(0xFFFF6B6B);
  final Color _backgroundColor = Color(0xFFF9FAFB);
  final Color _cardColor = Colors.white;
  final Color _textColor = Color(0xFF191F28);
  final Color _subTextColor = Color(0xFF8B95A1);

  List<Asset> stocks = [];
  List<Asset> loans = [];
  List<AssetAccount> freeSavings = [];
  List<AssetAccount> otherAccounts = [];
  int stocksTotal = 0;
  int loansTotal = 0;
  int freeSavingsTotal = 0;
  int otherAccountsTotal = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAssets();
  }

  Future<void> _fetchAssets() async {
    try {
      final stocksData = await ApiService().fetchCoupleAssets('STOCK');
      final loansData = await ApiService().fetchCoupleAssets('LOAN');
      final accountsData = await ApiService().fetchCoupleAccount();

      setState(() {
        stocks = stocksData;
        loans = loansData;
        freeSavings = accountsData.where((account) => account.accountType == 'FREE_SAVINGS').toList();
        otherAccounts = accountsData.where((account) => account.accountType != 'FREE_SAVINGS').toList();

        stocksTotal = stocks.fold(0, (sum, asset) => sum + asset.amount);
        loansTotal = loans.fold(0, (sum, asset) => sum + asset.amount);
        freeSavingsTotal = freeSavings.fold(0, (sum, account) => sum + account.amount);
        otherAccountsTotal = otherAccounts.fold(0, (sum, account) => sum + account.amount);

        isLoading = false;
      });
    } catch (e) {
      print('Error fetching assets: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat('#,###');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text('${widget.coupleDto.nickname}의 총 자산',
            style: TextStyle(color: _textColor, fontWeight: FontWeight.bold)),
        backgroundColor: _backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: _textColor),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCoupleInfoCard(),
              SizedBox(height: 24),
              _buildAssetSection('자유적금', freeSavingsTotal, assetAccounts: freeSavings),
              _buildAssetSection('예금/적금', otherAccountsTotal, assetAccounts: otherAccounts),
              _buildAssetSection('주식', stocksTotal, assets: stocks),
              _buildAssetSection('대출', loansTotal, assets: loans),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoupleInfoCard() {
    return Card(
      color: _cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: _primaryColor.withOpacity(0.1), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(widget.coupleDto.nickname,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textColor)),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildUserInfo(widget.coupleDto.user1Name, 1234567),
                _buildUserInfo(widget.coupleDto.user2Name, 987654),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(String name, int amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: TextStyle(fontWeight: FontWeight.bold, color: _textColor)),
        SizedBox(height: 4),
        Text('${_formatCurrency(amount)}원',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _primaryColor)),
      ],
    );
  }

  Widget _buildAssetSection(String title, int totalAmount, {List<Asset>? assets, List<AssetAccount>? assetAccounts}) {
    var items = assets ?? assetAccounts ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textColor)),
              Text('${_formatCurrency(totalAmount)}원',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _primaryColor)),
            ],
          ),
        ),
        ...items.take(3).map((item) => _buildAssetItem(item.bankName, item.amount)),
        if (items.length > 3)
          TextButton(
            onPressed: () {
              // TODO: Implement 'See More' functionality
            },
            child: Text('더보기', style: TextStyle(color: _primaryColor)),
          ),
        if (items.isEmpty)
          Text('자산 정보가 없습니다.', style: TextStyle(color: _subTextColor)),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAssetItem(String bankName, int amount) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.2))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(bankName, style: TextStyle(fontWeight: FontWeight.w500, color: _textColor)),
              SizedBox(height: 4),
            ],
          ),
          Text('${_formatCurrency(amount)}원',
              style: TextStyle(fontWeight: FontWeight.w500, color: _textColor)),
        ],
      ),
    );
  }
}