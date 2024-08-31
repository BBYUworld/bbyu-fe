import 'package:flutter/material.dart';
import 'package:gagyebbyu_fe/views/home/Footer.dart';
import 'package:gagyebbyu_fe/views/householdledger/PersonalLedgerScreen.dart';
import 'package:gagyebbyu_fe/views/householdledger/JointLedgerScreen.dart';
import 'package:gagyebbyu_fe/services/ledger_api_service.dart';
import 'package:gagyebbyu_fe/models/user_account.dart';
import 'package:gagyebbyu_fe/models/expense/couple_expense_model.dart';
import 'package:gagyebbyu_fe/views/householdledger/JointLedgerListScreen.dart';
import 'package:gagyebbyu_fe/views/analysis/analysis_expense_main_page.dart';

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

  int currentYear = DateTime.now().year;
  int currentMonth = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    _apiService = LedgerApiService();
    _loadDataFuture = _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    await _fetchLedgerData();
    await _fetchCoupleExpense(currentYear, currentMonth);
  }

  Future<void> _fetchLedgerData() async {
    try {
      final data = await _apiService.fetchCoupleAccountData();
      setState(() {
        userAccount = data;
      });
    } catch (e) {
      print('Error fetching ledger data: $e');
    }
  }

  Future<void> _fetchCoupleExpense(int year, int month) async {
    try {
      final data = await _apiService.fetchCoupleExpense(year, month);
      setState(() {
        coupleExpense = data;
        currentYear = year;
        currentMonth = month;
      });
    } catch (e) {
      print('Error fetching couple expense: $e');
    }
  }

  void _onMonthChanged(int year, int month) {
    _fetchCoupleExpense(year, month);
  }

  Future<void> _onRefresh(int year, int month) async {
    await _fetchCoupleExpense(year, month);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
            child: _selectedIndex == 0
                ? JointLedgerListScreen(
              coupleExpense: coupleExpense,
              onRefresh: _onRefresh,  // _onRefresh 메소드 호출
              currentYear: currentYear,
              currentMonth: currentMonth,
              onMonthChanged: _onMonthChanged,  // _onMonthChanged 메소드 호출
            )
                : _selectedIndex == 1
                ? JointLedgerScreen(
              onMonthChanged: _onMonthChanged,  // _onMonthChanged 메소드 호출
              coupleExpense: coupleExpense,
              onRefresh: _onRefresh,  // _onRefresh 메소드 호출
              apiService: _apiService,
            )
                : AnalysisExpenseMainPage(
              coupleExpense: coupleExpense,
              onRefresh: _onRefresh,  // _onRefresh 메소드 호출
              currentYear: currentYear,
              currentMonth: currentMonth,
              onMonthChanged: _onMonthChanged,  // _onMonthChanged 메소드 호출
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
          _buildFooterTab('내역', Icons.list, _selectedIndex == 0),
          _buildFooterTab('캘린더', Icons.calendar_today, _selectedIndex == 1),
          _buildFooterTab('통계', Icons.pie_chart, _selectedIndex == 2),
        ],
      ),
    );
  }

  Widget _buildFooterTab(String label, IconData icon, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = label == '내역'
              ? 0
              : label == '캘린더'
              ? 1
              : 2;
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
