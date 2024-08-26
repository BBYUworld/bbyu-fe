import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:gagyebbyu_fe/models/couple_expense_model.dart';
import 'package:gagyebbyu_fe/views/householdledger/daily_expense_detail_modal.dart';

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

  void _showDailyExpenseDetail(BuildContext context, DateTime date) {
    final expenses = widget.coupleExpense?.expenses
        .where((e) => isSameDay(DateTime.parse(e.date), date))
        .toList() ?? [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.5,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: DailyExpenseDetailModal(date: date, expenses: expenses),
            );
          },
        );
      },
    );
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
    return Container(
      height: 600,  // 캘린더의 높이를 600으로 설정
      child: TableCalendar(
        firstDay: DateTime.utc(2021, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: CalendarFormat.month,
        onPageChanged: (focusedDay) {
          setState(() {
            _focusedDay = focusedDay;
          });
          widget.onMonthChanged(focusedDay.year, focusedDay.month);
        },
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          todayDecoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
          ),
          todayTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          decoration: BoxDecoration(
            color: Colors.blue,  // 헤더의 배경색을 파란색으로 설정
          ),
          titleTextStyle: TextStyle(
            color: Colors.white,  // 헤더의 텍스트 색상을 흰색으로 설정
            fontSize: 20,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: Colors.black),  // 평일 텍스트 색상
          weekendStyle: TextStyle(color: Colors.red),  // 주말 텍스트 색상
          dowTextFormatter: (date, locale) {
            return ['월', '화', '수', '목', '금', '토', '일'][date.weekday - 1];  // 요일을 한글로 표시
          },
        ),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            final expense = widget.coupleExpense?.expenses.firstWhere(
                  (e) => isSameDay(DateTime.parse(e.date), day),
              orElse: () => DailyExpense(coupleId: 0, date: '', totalAmount: 0),
            );
            return GestureDetector(
              onTap: () => _showDailyExpenseDetail(context, day),
              child: Container(
                margin: const EdgeInsets.all(4.0),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Text(
                      day.day.toString(),
                      style: TextStyle(
                        fontWeight: isSameDay(day, DateTime.now()) ? FontWeight.bold : FontWeight.normal,
                        color: isSameDay(day, DateTime.now()) ? Colors.blue : Colors.black,
                      ),
                    ),
                    if (expense?.totalAmount != 0)
                      Text(
                        '-${expense!.totalAmount.abs()}',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 10,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  int _calculateTotalExpense() {
    return widget.coupleExpense?.expenses
        .fold(0, (sum, e) => sum! + (e.totalAmount.abs())) ?? 0;
  }
}
