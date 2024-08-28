class CoupleExpense {
  final int totalAmount; //현재 이번달에 내가 쓴 금액
  final int targetAmount; //내가 한 달에 쓰고자하는 목표 금액
  final int amountDifference; // 월간 타겟 소비금액에서 얼만큼 덜 썼는지
  final String category; //이번달에 내가 많이 쓴 카테고리
  final int totalAmountFromLastMonth; //저번달보다 얼마 더 썼는지 (-면 더 저번달보다 많이 쓴것임)
  final List<DailyExpense> expenses;
  final List<DailyDetailExpense> dayExpenses;

  CoupleExpense({
    required this.totalAmount,
    required this.targetAmount,
    required this.amountDifference,
    required this.category,
    required this.totalAmountFromLastMonth,
    required this.expenses,
    required this.dayExpenses,
  });

  factory CoupleExpense.fromJson(Map<String, dynamic> json) {
    var expenseList = (json['expenses'] as List?) ?? [];
    var detailExpenseList = (json['dayExpenses'] as List?) ?? [];

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
      category: json['category'] ?? '카테고리 없음',
      totalAmountFromLastMonth: json['totalAmountFromLastMonth'] ?? 0,
      expenses: expenseObjects,
      dayExpenses: detailExpenseObjects,
    );
  }

  @override
  String toString() {
    return 'CoupleExpense(totalAmount: $totalAmount, targetAmount: $targetAmount, amountDifference: $amountDifference, category: $category, totalAmountFromLastMonth: $totalAmountFromLastMonth, expenses: ${expenses.map((e) => e.toString()).join(', ')}, detailExpenses: ${dayExpenses.map((e) => e.toString()).join(', ')})';
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
  final int expenseId;
  final String name;
  final int amount;
  final String category;
  final DateTime date;
  late final String memo;
  final String place;

  DailyDetailExpense({
    required this.expenseId,
    required this.name,
    required this.amount,
    required this.category,
    required this.date,
    required this.memo,
    required this.place,
  });

  factory DailyDetailExpense.fromJson(Map<String, dynamic> json) {
    return DailyDetailExpense(
      expenseId: json['expenseId'] ?? 0,
      name: json['name'] ?? '',
      amount: json['amount'] ?? 0,
      category: json['category'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      memo: json['memo'] ?? '',
      place: json['place'] ?? '장소 없음',
    );
  }

  @override
  String toString() {
    return 'DailyDetailExpense(name: $name, amount: $amount, category: $category, date: $date, memo: $memo, place: $place)';
  }
}
