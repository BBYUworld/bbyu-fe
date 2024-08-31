import '../expense/expense_category.dart';

class ExpenseCategoryDto {
  final String label; // 변경: label을 String으로 유지
  final int amount;
  final double percentage;

  ExpenseCategoryDto({
    required this.label,
    required this.amount,
    required this.percentage,
  });

  factory ExpenseCategoryDto.fromJson(Map<String, dynamic> json) {
    return ExpenseCategoryDto(
      label: json['label'] as String? ?? '',
      amount: json['amount'] as int? ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }
}



class ExpenseResultDto {
  final String? category;  // category를 nullable로 변경
  final int startAge;
  final int startIncome;
  final int anotherCoupleMonthExpenseAvg;
  final int coupleMonthExpense;

  ExpenseResultDto({
    required this.category,  // required로 유지하되 null이 허용됨
    required this.startAge,
    required this.startIncome,
    required this.anotherCoupleMonthExpenseAvg,
    required this.coupleMonthExpense,
  });

  factory ExpenseResultDto.fromJson(Map<String, dynamic> json) {
    return ExpenseResultDto(
      category: json['category'] as String?,  // null 허용
      startAge: json['averageAge'] as int? ?? 0,
      startIncome: json['monthlyIncome'] as int? ?? 0,
      anotherCoupleMonthExpenseAvg: json['anotherCoupleMonthExpenseAvg'] as int? ?? 0,
      coupleMonthExpense: json['coupleMonthExpense'] as int? ?? 0,
    );
  }
}



