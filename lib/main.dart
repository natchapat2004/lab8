import 'package:flutter/material.dart';
//import 'screens/task_list_screen.dart';
//import 'basic_dismissible_example.dart';
//import 'dismissible_with_confirm.dart';
//import 'reorderable_dismissible.dart';
import 'reorderable_builder_example.dart';

void main() {
  runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const ReorderableBuilderExample(),
    );
  }
}
