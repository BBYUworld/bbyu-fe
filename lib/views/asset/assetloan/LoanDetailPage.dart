import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/models/asset/asset_loan.dart';
import 'package:gagyebbyu_fe/services/api_service.dart';
import 'package:intl/intl.dart';

class LoanDetailPage extends StatefulWidget {
  final int assetId;

  LoanDetailPage({required this.assetId});

  @override
  _LoanDetailPageState createState() => _LoanDetailPageState();
}

class _LoanDetailPageState extends State<LoanDetailPage> {
  late Future<AssetLoan> futureLoanDetail;
  final currencyFormatter = NumberFormat.currency(locale: 'ko_KR', symbol: '₩');

  @override
  void initState() {
    super.initState();
    futureLoanDetail = ApiService().fetchLoanDetail(widget.assetId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('대출 상세 정보', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<AssetLoan>(
        future: futureLoanDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.blue[700]));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
          } else if (snapshot.hasData) {
            final loan = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(loan),
                  _buildLoanDetails(loan),
                  _buildRepaymentInfo(loan),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data available', style: TextStyle(color: Colors.grey)));
          }
        },
      ),
    );
  }

  Widget _buildHeader(AssetLoan loan) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(loan.loanName,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    SizedBox(height: 8),
                    Text(loan.bankName,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '대출중',
                  style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text('잔여 대출금', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          SizedBox(height: 4),
          Text(
            currencyFormatter.format(loan.remainedAmount * 10000),
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue[700]),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildLoanDetails(AssetLoan loan) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('대출 정보', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          _buildDetailRow('대출액', currencyFormatter.format(loan.amount*10000)),
          _buildDetailRow('금리', '${loan.interestRate.toStringAsFixed(2)}%'),
          _buildDetailRow('대출 시작일', DateFormat('yyyy년 MM월 dd일').format(loan.createdAt)),
        ],
      ),
    );
  }

  Widget _buildRepaymentInfo(AssetLoan loan) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('상환 정보', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          _buildDetailRow('상환액', currencyFormatter.format((loan.amount - loan.remainedAmount)*10000)),
          _buildDetailRow('잔여액', currencyFormatter.format(loan.remainedAmount*10000)),
          SizedBox(height: 20),
          _buildProgressBar(loan),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildProgressBar(AssetLoan loan) {
    double progress = (loan.amount - loan.remainedAmount) / loan.amount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('상환 진행률', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
          minHeight: 10,
        ),
        SizedBox(height: 8),
        Text('${(progress * 100).toStringAsFixed(1)}%',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue[700])),
      ],
    );
  }
}