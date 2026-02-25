import 'package:flutter/material.dart';
import '../models/task.dart';

class DismissibleTaskList extends StatefulWidget {
  const DismissibleTaskList({super.key});

  @override
  State<DismissibleTaskList> createState() => _DismissibleTaskListState();
}

class _DismissibleTaskListState extends State<DismissibleTaskList> {
  final List<Task> _tasks = [
    Task(id: '1', title: 'เรียนรู้ ListView', description: 'Part 1'),
    Task(id: '2', title: 'เข้าใจ Key', description: 'Part 2'),
    Task(id: '3', title: 'ใช้ Dismissible', description: 'Part 3'),
    Task(id: '4', title: 'Drag and Drop', description: 'Part 4'),
  ];

  // เก็บ task ที่ถูกลบล่าสุด (สำหรับ Undo)
  Task? _lastDeletedTask;
  int? _lastDeletedIndex;

  void _deleteTask(int index) {
    setState(() {
      _lastDeletedTask = _tasks[index];
      _lastDeletedIndex = index;
      _tasks.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ลบ "${_lastDeletedTask!.title}" แล้ว'),
        action: SnackBarAction(label: 'Undo', onPressed: _undoDelete),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _undoDelete() {
    if (_lastDeletedTask != null && _lastDeletedIndex != null) {
      setState(() {
        _tasks.insert(_lastDeletedIndex!, _lastDeletedTask!);
        _lastDeletedTask = null;
        _lastDeletedIndex = null;
      });
    }
  }

  void _toggleComplete(int index) {
    setState(() {
      _tasks[index] = _tasks[index].copyWith(
        isCompleted: !_tasks[index].isCompleted,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Manager'), centerTitle: true),
      body: _tasks.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'ไม่มีงานค้างอยู่!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Dismissible(
                    // ใช้ ValueKey กับ task.id
                    key: ValueKey(task.id),

                    // Swipe ขวา → เพื่อ Toggle Complete
                    background: Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: Icon(
                        task.isCompleted ? Icons.replay : Icons.check,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),

                    // Swipe ซ้าย ← เพื่อลบ
                    secondaryBackground: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),

                    // ยืนยันก่อน dismiss
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        // Toggle Complete - ไม่ต้อง dismiss จริง
                        _toggleComplete(index);
                        return false; // return false เพื่อไม่ให้ item หายไป
                      }
                      // Delete - ให้ dismiss
                      return true;
                    },

                    onDismissed: (direction) {
                      // จะถูกเรียกเฉพาะเมื่อ confirmDismiss return true
                      _deleteTask(index);
                    },

                    child: Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: Checkbox(
                          value: task.isCompleted,
                          onChanged: (_) => _toggleComplete(index),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        title: Text(
                          task.title,
                          style: TextStyle(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: task.isCompleted ? Colors.grey : null,
                          ),
                        ),
                        subtitle: Text(
                          task.description,
                          style: TextStyle(
                            color: task.isCompleted
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                        ),
                        trailing: const Icon(Icons.drag_handle),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
