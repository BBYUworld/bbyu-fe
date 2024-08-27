class CoupleExpense {
  final int totalAmount;
  final int targetAmount;
  final int amountDifference;
  final List<DailyExpense> expenses;

  CoupleExpense({
    required this.totalAmount,
    required this.targetAmount,
    required this.amountDifference,
    required this.expenses,
  });

  factory CoupleExpense.fromJson(Map<String, dynamic> json) {
    var expenseList = json['expenses'] as List;
    List<DailyExpense> expenseObjects = expenseList
        .map((expenseJson) => DailyExpense.fromJson(expenseJson))
        .toList();

    return CoupleExpense(
      totalAmount: json['totalAmount'],
      targetAmount: json['targetAmount'],
      amountDifference: json['amountDifference'],
      expenses: expenseObjects,
    );
  }
  @override
  String toString() {
    return 'CoupleExpense(totalAmount: $totalAmount, targetAmount: $targetAmount, amountDifference: $amountDifference, expenses: ${expenses.map((e) => e.toString()).join(', ')})';
  }
}

class DailyExpense {
  final int coupleId;
  final String date;
  final int totalAmount;

  DailyExpense({
    required this.coupleId,
    required this.date,
    required this.totalAmount,
  });

  factory DailyExpense.fromJson(Map<String, dynamic> json) {
    return DailyExpense(
      coupleId: json['coupleId'] ?? 0,
      date: json['date'] ?? '',
      totalAmount: json['totalAmount'] ?? 0,
    );
  }

  get description => null;

  get category => null;
  
  @override
  String toString() {
    return 'DailyExpense(coupleId: $coupleId, date: $date, totalAmount: $totalAmount)';
  }
}


class ExpenseDay {
  final String name;
  final int amount;
  final String category;
  final DateTime date;
  final String memo;
  final String place;

  ExpenseDay({
    required this.name,
    required this.amount,
    required this.category,
    required this.date,
    required this.memo,
    required this.place,
  });

  factory ExpenseDay.fromJson(Map<String, dynamic> json) {
    return ExpenseDay(
      name: json['name'],
      amount: json['amount'],
      category: json['category'],
      date: DateTime.parse(json['date']),
      memo: json['memo'],
      place: json['place'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'memo': memo,
      'place': place,
    };
  }
}