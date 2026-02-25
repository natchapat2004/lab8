import 'package:flutter/material.dart';
import '../models/task.dart';

class ReorderableDismissibleList extends StatefulWidget {
  const ReorderableDismissibleList({super.key});

  @override
  State<ReorderableDismissibleList> createState() =>
      _ReorderableDismissibleListState();
}

class _ReorderableDismissibleListState
    extends State<ReorderableDismissibleList> {
  final List<Task> _tasks = [
    Task(id: '1', title: 'Task 1', description: 'Description 1'),
    Task(id: '2', title: 'Task 2', description: 'Description 2'),
    Task(id: '3', title: 'Task 3', description: 'Description 3'),
  ];

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final task = _tasks.removeAt(oldIndex);
      _tasks.insert(newIndex, task);
    });
  }

  void _onDismissed(int index) {
    final task = _tasks[index];
    setState(() {
      _tasks.removeAt(index);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Deleted ${task.title}')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reorderable + Dismissible')),
      body: ReorderableListView.builder(
        padding: const EdgeInsets.all(16),
        buildDefaultDragHandles: false,
        itemCount: _tasks.length,
        onReorder: _onReorder,

        itemBuilder: (context, index) {
          final task = _tasks[index];

          // Key ต้องอยู่ที่ Dismissible (outermost widget)
          return Dismissible(
            key: ValueKey(task.id),
            direction: DismissDirection.endToStart,

            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.delete, color: Colors.white),
            ),

            onDismissed: (_) => _onDismissed(index),

            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                // Custom drag handle ด้านซ้าย
                leading: ReorderableDragStartListener(
                  index: index,
                  child: const Icon(Icons.drag_handle),
                ),
                title: Text(task.title),
                subtitle: Text(task.description),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _onDismissed(index),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
