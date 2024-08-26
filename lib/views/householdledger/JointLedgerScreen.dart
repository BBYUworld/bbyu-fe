import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:gagyebbyu_fe/models/couple_expense_model.dart';

class JointLedgerScreen extends StatefulWidget {
  final Function(int year, int month) onMonthChanged;
  final CoupleExpense? coupleExpense;
  final Function(int year, int month) onRefresh;
  JointLedgerScreen({required this.onMonthChanged, this.coupleExpense, required this.onRefresh});

  @override
  _JointLedgerScreenState createState() => _JointLedgerScreenState();
}

class _JointLedgerScreenState extends State<JointLedgerScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  double _startScrollPosition = 0;
  bool _isRefreshing = false;
  Future<void> _handleRefresh() async {
    if (!_isRefreshing) {
      setState(() {
        _isRefreshing = true;
      });
      await widget.onRefresh(_focusedDay.year, _focusedDay.month);
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.onMonthChanged(_focusedDay.year, _focusedDay.month);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAccountInfo(),
            _buildCalendar(),
            _buildExpenseList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('지출 총액: - ${widget.coupleExpense?.totalAmount ?? 0}원',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
          Text('한달 목표 지출: ${widget.coupleExpense?.targetAmount ?? 0}원',
              style: TextStyle(fontSize: 18)),
          Text('차이: ${widget.coupleExpense?.amountDifference ?? 0}원',
              style: TextStyle(fontSize: 18, color: Colors.red)),
          SizedBox(height: 16),
          Text('총 지출: - ${_calculateTotalExpense()}원', style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2021, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onPageChanged: (focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
        });
        widget.onMonthChanged(focusedDay.year, focusedDay.month);
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        todayDecoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.rectangle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.rectangle,
        ),
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, events) {
          final expense = widget.coupleExpense?.expenses.firstWhere(
                (e) => isSameDay(DateTime.parse(e.date), day),
            orElse: () => DailyExpense(coupleId: 0, date: '', totalAmount: 0),
          );
          if (expense?.totalAmount != 0) {
            return Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                '- ${expense!.totalAmount.abs()}',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 10,
                ),
              ),
            );
          }
          return null;
        },
      ),
    );
  }

  Widget _buildExpenseList() {
    return Container(
      height: 300,  // 고정 높이 지정 또는 필요에 따라 조절
      child: ListView.builder(
        itemCount: widget.coupleExpense?.expenses.length ?? 0,
        itemBuilder: (context, index) {
          final expense = widget.coupleExpense!.expenses[index];
          return ListTile(
            title: Text(expense.date),
            subtitle: Text(
              '- ${expense.totalAmount.abs()}원',
              style: TextStyle(color: Colors.red),
            ),
          );
        },
      ),
    );
  }

  int _calculateTotalExpense() {
    return widget.coupleExpense?.expenses
        .fold(0, (sum, e) => sum! + (e.totalAmount.abs())) ?? 0;
  }
}