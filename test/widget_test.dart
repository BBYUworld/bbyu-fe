// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gagyebbyu_fe/models/todo_model.dart';
import 'package:provider/provider.dart';

import 'package:gagyebbyu_fe/app/app.dart';
import 'package:gagyebbyu_fe/views/home/home_view.dart';
import 'package:gagyebbyu_fe/views/home/home_viewmodel.dart';
import 'package:gagyebbyu_fe/widgets/todo_item.dart';


void main() {
  testWidgets('Todo app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that the app title is displayed
    expect(find.text('Todo 리스트'), findsOneWidget);

    // Verify that we have an input field
    expect(find.byType(TextField), findsOneWidget);

    // Verify that we have an add button
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('Add todo item test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => HomeViewModel(),
        child: MaterialApp(home: HomeView()),
      ),
    );

    // Enter text into the TextField
    await tester.enterText(find.byType(TextField), 'New Todo Item');

    // Tap the add button
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that the new todo item is in the list
    expect(find.text('New Todo Item'), findsOneWidget);
  });

  testWidgets('TodoItem widget test', (WidgetTester tester) async {
    final todo = Todo(id: '1', title: 'Test Todo');

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => HomeViewModel(),
        child: MaterialApp(
          home: Scaffold(
            body: TodoItem(todo: todo),
          ),
        ),
      ),
    );

    // Verify that the todo title is displayed
    expect(find.text('Test Todo'), findsOneWidget);

    // Verify that we have a checkbox
    expect(find.byType(Checkbox), findsOneWidget);

    // Verify that we have a delete button
    expect(find.byIcon(Icons.delete), findsOneWidget);
  });
}