import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gagyebbyu_fe/models/account/account_recommendation.dart';
import 'package:gagyebbyu_fe/models/user_account.dart';
import 'package:gagyebbyu_fe/services/api_service.dart';
import 'package:gagyebbyu_fe/services/ledger_api_service.dart';

class DetailPage extends StatefulWidget {
  final AccountDto accountDto;

  const DetailPage({Key? key, required this.accountDto}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late TextEditingController _amountInputController;
  List<Account> list = [];
  Account? selectedAccount;

  final Color primaryColor = Color(0xFFFF6B6B);
  final Color textColor = Color(0xFF191F28);
  final Color subtextColor = Color(0xFF8B95A1);
  final Color cardColor = Colors.white;
  final Color backgroundColor = Color(0xFFF9FAFB);

  @override
  void initState() {
    super.initState();
    _amountInputController = TextEditingController();

    // Load user accounts
    _loadUserAccounts();
  }

  Future<void> _loadUserAccounts() async {
    try {
      List<Account> accounts = await LedgerApiService().fetchUserAccountData();
      setState(() {
        list = accounts;
        if (list.isNotEmpty) {
          selectedAccount = list[0]; // Select the first account by default
        }
      });
      print("list = $list");
    } catch (e) {
      print("Error fetching user accounts: $e");
    }
  }

  @override
  void dispose() {
    _amountInputController.dispose();
    super.dispose();
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat('#,###');
    return '${formatter.format(amount * 10000)}원';
  }

  void _submitForm() {
    if (_amountInputController.text.isNotEmpty) {
      final amount = int.tryParse(_amountInputController.text);
      if (amount != null && amount > 0 && amount <= 10000) {
        print("Selected Account: ${selectedAccount?.bankName} - ${selectedAccount?.accountNo}");
        print("Entered Amount: $amount 만원");
        print("${widget.accountDto.accountTypeUniqueNo}");
        String message = ApiService().createDepositAccount(selectedAccount!.accountNo, amount, widget.accountDto.accountTypeUniqueNo) as String;
      } else {
        // 잘못된 입력 값 처리
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("금액은 1만원에서 1억원 사이여야 합니다.")),
        );
      }
    } else {
      // 입력이 비어 있을 경우 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("금액을 입력해주세요.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('상품 계좌 생성하기', style: TextStyle(color: textColor)),
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: textColor),
        elevation: 0,
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCard(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.accountDto.name,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.accountDto.bankName,
                    style: TextStyle(fontSize: 16, color: subtextColor),
                  ),
                  Divider(height: 20, color: subtextColor),
                  _buildInfoRow('금리', '${widget.accountDto.interestRate}%'),
                  _buildInfoRow('기간', '${widget.accountDto.termMonths}개월'),
                  _buildInfoRow('최소 금액', _formatCurrency(widget.accountDto.minAmount)),
                  _buildInfoRow('최대 금액', _formatCurrency(widget.accountDto.maxAmount)),
                  _buildInfoRow('계좌 번호', '${widget.accountDto.accountTypeUniqueNo}'),
                ],
              ),
            ),
            SizedBox(height: 30),
            _buildDropdownField(),
            _buildInputField(_amountInputController, '금액 입력 (원 단위)'),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<Account>(
        value: selectedAccount,
        decoration: InputDecoration(
          labelText: '계좌 선택',
          labelStyle: TextStyle(color: subtextColor),
          filled: true,
          fillColor: cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: subtextColor.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: subtextColor.withOpacity(0.3)),
          ),
        ),
        items: list.map((account) {
          return DropdownMenuItem<Account>(
            value: account,
            child: Text('${account.bankName} - ${account.accountNo}'),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedAccount = value;
          });
        },
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: subtextColor),
          filled: true,
          fillColor: cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: subtextColor.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: subtextColor.withOpacity(0.3)),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text('서버로 전송', style: TextStyle(color: Colors.white, fontSize: 16)),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: subtextColor, fontSize: 14)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildCard(Widget child) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}
