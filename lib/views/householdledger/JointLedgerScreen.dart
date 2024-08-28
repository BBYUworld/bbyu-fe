import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:gagyebbyu_fe/models/couple_expense_model.dart';
import 'package:gagyebbyu_fe/views/householdledger/daily_expense_detail_modal.dart';
import 'package:gagyebbyu_fe/widgets/expense/joint_ledger_header.dart'; // JointLedgerHeader import

class JointLedgerScreen extends StatefulWidget {
  final Function(int year, int month) onMonthChanged;
  final CoupleExpense? coupleExpense;
  final Function(int year, int month) onRefresh;

  JointLedgerScreen({
    required this.onMonthChanged,
    this.coupleExpense,
    required this.onRefresh,
  });

  @override
  _JointLedgerScreenState createState() => _JointLedgerScreenState();
}

class _JointLedgerScreenState extends State<JointLedgerScreen> {
  DateTime _focusedDay = DateTime.now();
  bool _isRefreshing = false;
  Map<DateTime, int> _dailyTotalExpenses = {};

  @override
  void initState() {
    super.initState();
    widget.onMonthChanged(_focusedDay.year, _focusedDay.month);
    _calculateDailyTotalExpenses();
  }

  @override
  void didUpdateWidget(JointLedgerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.coupleExpense != oldWidget.coupleExpense) {
      _calculateDailyTotalExpenses();
    }
  }

  void _calculateDailyTotalExpenses() {
    _dailyTotalExpenses = {};
    if (widget.coupleExpense != null) {
      for (var expense in widget.coupleExpense!.expenses) {
        final date = DateTime.parse(expense.date);
        final normalizedDate = DateTime(date.year, date.month, date.day);
        _dailyTotalExpenses[normalizedDate] =
            (_dailyTotalExpenses[normalizedDate] ?? 0) + expense.totalAmount;
      }
    }
    setState(() {});
  }

  Future<void> _handleRefresh() async {
    if (!_isRefreshing) {
      setState(() {
        _isRefreshing = true;
      });
      await widget.onRefresh(_focusedDay.year, _focusedDay.month);
      _calculateDailyTotalExpenses();
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  void _showDailyExpenseDetail(BuildContext context, DateTime date) {
    final expenses = widget.coupleExpense?.expenses
        .where((e) => isSameDay(DateTime.parse(e.date), date))
        .toList() ?? [];

    final detailExpenses = widget.coupleExpense?.dayExpenses
        .where((e) => isSameDay(e.date, date))
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
              child: DailyExpenseDetailModal(date: date, expenses: detailExpenses),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView(
        children: [
          JointLedgerHeader(
            coupleExpense: widget.coupleExpense,
            displayedYear: _focusedDay.year,
            displayedMonth: _focusedDay.month,
            onMonthChanged: (increment) {
              setState(() {
                _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + increment);
              });
              widget.onMonthChanged(_focusedDay.year, _focusedDay.month);
            },
          ),
          _buildCalendar(),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TableCalendar(
        firstDay: DateTime.utc(2021, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        rowHeight: 100,
        calendarFormat: CalendarFormat.month,
        availableGestures: AvailableGestures.horizontalSwipe,
        onPageChanged: (focusedDay) {
          setState(() {
            _focusedDay = focusedDay;
          });
          widget.onMonthChanged(focusedDay.year, focusedDay.month);
        },
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          todayTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextFormatter: (date, locale) =>
          '${date.year}년 ${date.month}월',
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: Colors.black,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: Colors.black,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: Colors.black),
          weekendStyle: TextStyle(color: Colors.red),
          dowTextFormatter: (date, locale) {
            return ['월', '화', '수', '목', '금', '토', '일'][date.weekday - 1];
          },
        ),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            final normalizedDay = DateTime(day.year, day.month, day.day);  // 시간 정보 제거
            final dailyTotal = _dailyTotalExpenses[normalizedDay] ?? 0;
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
                        fontWeight: isSameDay(day, DateTime.now())
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSameDay(day, DateTime.now())
                            ? Colors.blue
                            : Colors.black,
                      ),
                    ),
                    if (dailyTotal != 0)
                      Text(
                        '-${dailyTotal.abs()}',
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
}
