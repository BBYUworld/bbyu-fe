class ExpenseEntry {
  final String description;
  final String category;
  final double amount;
  final bool isIncome;

  ExpenseEntry({
    required this.description,
    required this.category,
    required this.amount,
    required this.isIncome,
  });
}