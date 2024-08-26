import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/views/home/Fotter.dart';
import 'package:gagyebbyu_fe/views/householdledger/PersonalLedgerScreen.dart';
import 'package:gagyebbyu_fe/views/householdledger/JointLedgerScreen.dart';
import 'package:gagyebbyu_fe/services/ledger_api_service.dart';
import 'package:gagyebbyu_fe/models/user_account.dart';
import 'package:gagyebbyu_fe/models/couple_expense_model.dart';

class HouseholdLedgerScreen extends StatefulWidget {
  @override
  _HouseholdLedgerScreenState createState() => _HouseholdLedgerScreenState();
}

class _HouseholdLedgerScreenState extends State<HouseholdLedgerScreen> {
  int _selectedIndex = 0;
  int _currentPageIndex = 0;
  late LedgerApiService _apiService;
  late List<Account> userAccount;
  CoupleExpense? coupleExpense;


  @override
  void initState() {
    super.initState();
    _apiService = LedgerApiService();
    _fetchLedgerData();
  }

  Future<void> _fetchLedgerData() async {
    try {
      final data = await _apiService.fetchUserAccountData();
      setState(() {
        userAccount = data;
        print("user Account List = $userAccount");
      });
    } catch (e) {
      // 에러 처리
      print('Error fetching ledger data: $e');
      // 사용자에게 에러 메시지를 보여줄 수 있습니다.
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // 여기에 라우팅 로직을 추가할 수 있습니다.
  }
  Future<void> fetchCoupleExpense(int year, int month) async {
    try {
      final data = await _apiService.fetchCoupleExpense(year, month);
      setState(() {
        coupleExpense = data;
        print("Couple Expense Details:");
        print("Total Amount: ${coupleExpense?.totalAmount}");
        print("Target Amount: ${coupleExpense?.targetAmount}");
        print("Amount Difference: ${coupleExpense?.amountDifference}");
        print("Daily Expenses:");
        coupleExpense?.expenses.forEach((expense) {
          print("  Date: ${expense.date}, Amount: ${expense.totalAmount}");
        });
      });
    } catch (e) {
      print('Error fetching couple expense: $e');
    }
  }


  void _onMonthChanged(int year, int month) {
    print('Emit year = $year and Month = $month');
    fetchCoupleExpense(year, month);
  }

  Future<void> _onRefresh(int year, int month) async {
    print('Refreshing data for year = $year and month = $month');
    await fetchCoupleExpense(year, month);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('가계부'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _currentPageIndex = _currentPageIndex == 0 ? 1 : 0;
              });
            },
            child: Text(
              _currentPageIndex == 0 ? '공동' : '개인',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: _currentPageIndex == 0
          ? PersonalLedgerScreen()
          : JointLedgerScreen(
        onMonthChanged: _onMonthChanged,
        coupleExpense: coupleExpense,
        onRefresh: _onRefresh,
      ),
      bottomNavigationBar: CustomFooter(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}