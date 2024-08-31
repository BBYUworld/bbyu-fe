import 'package:flutter/material.dart';
import '../../models/expense/couple_expense_model.dart';
import '../../models/expense/expense_category.dart';
import '../../services/ledger_api_service.dart';

class EditExpenseModal extends StatefulWidget {
  final DailyDetailExpense expense;
  final LedgerApiService apiService;

  EditExpenseModal({required this.expense, required this.apiService});

  @override
  _EditExpenseModalState createState() => _EditExpenseModalState();
}

class _EditExpenseModalState extends State<EditExpenseModal> {
  late Category _category;
  late TextEditingController _memoController;
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _category = categoryFromString(widget.expense.category);
    _memoController = TextEditingController(text: widget.expense.memo);
    _amountController = TextEditingController(text: widget.expense.amount.toString());
  }

  @override
  void dispose() {
    _memoController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('내역 수정'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<Category>(
              value: _category,
              decoration: InputDecoration(labelText: '카테고리'),
              items: Category.values.map((Category category) {
                return DropdownMenuItem<Category>(
                  value: category,
                  child: Text(categoryToString(category)),
                );
              }).toList(),
              onChanged: (Category? newValue) {
                if (newValue != null) {
                  setState(() {
                    _category = newValue;
                  });
                }
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: '메모'),
              controller: _memoController,
            ),
            TextField(
              decoration: InputDecoration(labelText: '금액'),
              keyboardType: TextInputType.number,
              controller: _amountController,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text('취소'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('저장'),
          onPressed: () async {
            try {
              // 텍스트 필드의 값 가져오기
              final updatedMemo = _memoController.text;
              final updatedAmount = int.tryParse(_amountController.text) ?? widget.expense.amount;
              final updatedCategory = categoryToStringDown(_category);

              // 서버에 업데이트 요청
              await widget.apiService.fetchUpdateCategory(widget.expense.expenseId, updatedCategory);
              await widget.apiService.fetchUpdateMemo(widget.expense.expenseId, updatedMemo);
              await widget.apiService.fetchUpdateAmount(widget.expense.expenseId, updatedAmount);

              // 변경된 데이터를 반환
              Navigator.of(context).pop(
                widget.expense.copyWith(
                  category: updatedCategory,
                  memo: updatedMemo,
                  amount: updatedAmount,
                ),
              );
            } catch (error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('업데이트에 실패했습니다.')),
              );
            }
          },
        ),
      ],
    );
  }
}
