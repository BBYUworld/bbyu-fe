class CoupleExpense {
  final int totalAmount;
  final int targetAmount;
  final int amountDifference;
  final List<DailyExpense> expenses;
  final List<DailyDetailExpense> detailExpenses;

  CoupleExpense({
    required this.totalAmount,
    required this.targetAmount,
    required this.amountDifference,
    required this.expenses,
    required this.detailExpenses,
  });

  factory CoupleExpense.fromJson(Map<String, dynamic> json) {
    var expenseList = (json['expenses'] as List?) ?? [];
    var detailExpenseList = (json['detailExpenses'] as List?) ?? [];

    List<DailyExpense> expenseObjects = expenseList
        .map((expenseJson) => DailyExpense.fromJson(expenseJson))
        .toList();

    List<DailyDetailExpense> detailExpenseObjects = detailExpenseList
        .map((detailExpenseJson) => DailyDetailExpense.fromJson(detailExpenseJson))
        .toList();

    return CoupleExpense(
      totalAmount: json['totalAmount'] ?? 0,
      targetAmount: json['targetAmount'] ?? 0,
      amountDifference: json['amountDifference'] ?? 0,
      expenses: expenseObjects,
      detailExpenses: detailExpenseObjects,
    );
  }

  @override
  String toString() {
    return 'CoupleExpense(totalAmount: $totalAmount, targetAmount: $targetAmount, amountDifference: $amountDifference, expenses: ${expenses.map((e) => e.toString()).join(', ')}, detailExpenses: ${detailExpenses.map((e) => e.toString()).join(', ')})';
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

  @override
  String toString() {
    return 'DailyExpense(coupleId: $coupleId, date: $date, totalAmount: $totalAmount)';
  }
}

class DailyDetailExpense {
  final String name;
  final int amount;
  final String category;
  final DateTime date;
  final String memo;
  final String place;

  DailyDetailExpense({
    required this.name,
    required this.amount,
    required this.category,
    required this.date,
    required this.memo,
    required this.place,
  });

  factory DailyDetailExpense.fromJson(Map<String, dynamic> json) {
    return DailyDetailExpense(
      name: json['name'] ?? '',
      amount: json['amount'] ?? 0,
      category: json['category'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      memo: json['memo'] ?? '',
      place: json['place'] ?? '장소없음',
    );
  }

  @override
  String toString() {
    return 'DailyDetailExpense(name: $name, amount: $amount, category: $category, date: $date, memo: $memo, place: $place)';
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
      name: json['name'] ?? '',
      amount: json['amount'] ?? 0,
      category: json['category'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      memo: json['memo'] ?? '',
      place: json['place'] ?? '장소없음',
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

  @override
  String toString() {
    return 'ExpenseDay(name: $name, amount: $amount, category: $category, date: $date, memo: $memo, place: $place)';
  }
}
