import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../views/home/home_viewmodel.dart';

class TodoInput extends StatefulWidget {
  @override
  _TodoInputState createState() => _TodoInputState();
}

class _TodoInputState extends State<TodoInput> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: '새로운 할 일을 입력하세요',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                Provider.of<HomeViewModel>(context, listen: false).addTodo(_controller.text);
                _controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}