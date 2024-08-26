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
  late Future<void> _loadDataFuture;

  @override
  void initState() {
    super.initState();
    _apiService = LedgerApiService();
    _loadDataFuture = _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    await _fetchLedgerData();
    await fetchCoupleExpense(DateTime.now().year, DateTime.now().month);
  }

  Future<void> _fetchLedgerData() async {
    try {
      final data = await _apiService.fetchUserAccountData();
      setState(() {
        userAccount = data;
        print("user Account List = $userAccount");
      });
    } catch (e) {
      print('Error fetching ledger data: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
      body: FutureBuilder(
        future: _loadDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return _buildBody();
          }
        },
      ),
      bottomNavigationBar: CustomFooter(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildBody() {
    if (_currentPageIndex == 0) {
      return PersonalLedgerScreen();
    } else if (_currentPageIndex == 1 && coupleExpense != null) {
      return JointLedgerScreen(
        onMonthChanged: _onMonthChanged,
        coupleExpense: coupleExpense,
        onRefresh: _onRefresh,
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }
}