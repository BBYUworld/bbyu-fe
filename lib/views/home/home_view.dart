import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/todo_item.dart';
import '../../widgets/todo_input.dart';
import 'home_viewmodel.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo 리스트')),
      body: Column(
        children: [
          TodoInput(),
          Expanded(
            child: Consumer<HomeViewModel>(
              builder: (context, viewModel, child) {
                return ListView.builder(
                  itemCount: viewModel.todos.length,
                  itemBuilder: (context, index) {
                    final todo = viewModel.todos[index];
                    return TodoItem(todo: todo);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}