import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gagyebbyu_fe/models/account/account_recommendation.dart';
import 'package:gagyebbyu_fe/models/user_account.dart';
import 'package:gagyebbyu_fe/services/api_service.dart';
import 'package:gagyebbyu_fe/services/ledger_api_service.dart';

class DetailPage extends StatefulWidget {
  final AccountDto accountDto;
  final bool isSavings; // 적금인지 여부를 나타내는 변수

  const DetailPage({Key? key, required this.accountDto, required this.isSavings}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late TextEditingController _amountInputController;
  List<Account> list = [];
  Account? selectedAccount;
  int? accountBalance; // Variable to hold the current account balance

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
          accountBalance = selectedAccount?.accountBalance; // Set the initial balance
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
    return '${formatter.format(amount)}원';
  }

  void _submitForm() async {
    if (_amountInputController.text.isNotEmpty) {
      final amount = int.tryParse(_amountInputController.text);
      if (amount != null && amount > 0 && amount <= 100000000) {
        print("Selected Account: ${selectedAccount?.bankName} - ${selectedAccount?.accountNo}");
        print("Entered Amount: $amount 원");
        print("${widget.accountDto.accountTypeUniqueNo}");

        try {
          String message;
          if (widget.isSavings) {
            // 적금일 때 API 요청
            message = await ApiService().createSavingAccount(
              selectedAccount!.accountNo,
              amount,
              widget.accountDto.accountTypeUniqueNo,
            );
          } else {
            // 예금일 때 API 요청
            message = await ApiService().createDepositAccount(
              selectedAccount!.accountNo,
              amount,
              widget.accountDto.accountTypeUniqueNo,
            );
          }

          if (message == "ok") {
            _showSuccessDialog();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("상품 가입에 실패하였습니다: $message")),
            );
          }
        } catch (e) {
          // Handle any errors that occur during the API call
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("상품 가입 중 오류가 발생했습니다. 다시 시도해주세요.")),
          );
        }
      } else {
        // Handle invalid amount
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("금액은 1만원에서 1억원 사이여야 합니다.")),
        );
      }
    } else {
      // Handle empty input
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("금액을 입력해주세요.")),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("상품 가입 완료"),
          content: Text("상품 가입이 성공적으로 완료되었습니다."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Optionally navigate back
              },
              child: Text("확인"),
            ),
          ],
        );
      },
    );
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
                  _buildInfoRow('최소 금액', _formatCurrency(widget.accountDto.minAmount * 10000)),
                  _buildInfoRow('최대 금액', _formatCurrency(widget.accountDto.maxAmount * 10000)),
                  _buildInfoRow('계좌 번호', '${widget.accountDto.accountTypeUniqueNo}'),
                ],
              ),
            ),
            SizedBox(height: 30),
            _buildDropdownField(),
            if (accountBalance != null) ...[
              _buildInfoRow('잔액', _formatCurrency(accountBalance!)), // Display the balance
            ],
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
            accountBalance = value?.accountBalance; // Update the balance when a new account is selected
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
          child: Text('상품 가입', style: TextStyle(color: Colors.white, fontSize: 16)),
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
