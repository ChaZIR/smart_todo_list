import 'package:smart_todo_list/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Starts with an empty task list and opens task creation',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const SmartTodoApp());
    await tester.pumpAndSettle();
    expect(find.byType(FloatingActionButton), findsOneWidget);
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.byType(TextFormField), findsWidgets);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
