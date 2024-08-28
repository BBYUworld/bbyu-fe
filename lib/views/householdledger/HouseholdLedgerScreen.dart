import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/views/home/Fotter.dart';
import 'package:gagyebbyu_fe/views/householdledger/PersonalLedgerScreen.dart';
import 'package:gagyebbyu_fe/views/householdledger/JointLedgerScreen.dart';
import 'package:gagyebbyu_fe/services/ledger_api_service.dart';
import 'package:gagyebbyu_fe/models/user_account.dart';
import 'package:gagyebbyu_fe/models/couple_expense_model.dart';
import 'package:gagyebbyu_fe/views/householdledger/JointLedgerListScreen.dart';

class HouseholdLedgerScreen extends StatefulWidget {
  @override
  _HouseholdLedgerScreenState createState() => _HouseholdLedgerScreenState();
}

class _HouseholdLedgerScreenState extends State<HouseholdLedgerScreen> {
  int _selectedIndex = 0;
  int _currentPageIndex = 0;
  late LedgerApiService _apiService;
  late List<Account> userAccount;
  bool _isListView = true;
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
      final data = await _apiService.fetchCoupleAccountData();
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
      print(data);
      print(data.dayExpenses);
      print("@@@@@@@@@@@@");
      print("size = ${data.expenses.length}");
      setState(() {
        coupleExpense = data;
      });
    } catch (e) {
      print('Error fetching couple expense: $e');
    }
  }

  void _onMonthChanged(int year, int month) {
    fetchCoupleExpense(year, month);
  }

  Future<void> _onRefresh(int year, int month) async {
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
    if (coupleExpense != null) {
      return Column(
        children: [
          Expanded(
            child: _isListView
                ? JointLedgerListScreen(
              coupleExpense: coupleExpense,
              onRefresh: _onRefresh,
            )
                : JointLedgerScreen(
              onMonthChanged: _onMonthChanged,
              coupleExpense: coupleExpense,
              onRefresh: _onRefresh,
            ),
          ),
          _buildCustomFooter(),
        ],
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildCustomFooter() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFooterTab('내역', Icons.list, _isListView),
          _buildFooterTab('캘린더', Icons.calendar_today, !_isListView),
        ],
      ),
    );
  }

  Widget _buildFooterTab(String label, IconData icon, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          _isListView = label == '내역';
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.blue : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
