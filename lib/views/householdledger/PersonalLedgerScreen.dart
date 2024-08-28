import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class PersonalLedgerScreen extends StatefulWidget {
  @override
  _PersonalLedgerScreenState createState() => _PersonalLedgerScreenState();
}

class _PersonalLedgerScreenState extends State<PersonalLedgerScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAccountInfo(),
        _buildCalendar(),
        _buildExpenseList(),
      ],
    );
  }

  Widget _buildAccountInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButton<String>(
            value: '신한 111-11111-1111',
            items: [
              DropdownMenuItem(value: '신한 111-11111-1111', child: Text('신한 111-11111-1111')),
            ],
            onChanged: (String? newValue) {},
          ),
          SizedBox(height: 8),
          Text('수입: + 302,000원', style: TextStyle(color: Colors.blue)),
          Text('지출: - 416,500원', style: TextStyle(color: Colors.red)),
          Text('총계: - 114,500원', style: TextStyle(color: Colors.red)),
          SizedBox(height: 8),
          Text('현재 GS25에서 지출이 가장 많아요.'),
          Text('전 월 대비 37,000원을 더 사용하셨어요.'),
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
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
    );
  }

  Widget _buildExpenseList() {
    return Expanded(
      child: ListView(
        children: [
          ListTile(
            title: Text('16일'),
            subtitle: Text('개인 지출 내역'),
          ),
          // 여기에 개인 지출 내역 항목들을 추가할 수 있습니다.
        ],
      ),
    );
  }
}