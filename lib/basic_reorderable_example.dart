import 'package:flutter/material.dart';

class BasicReorderableExample extends StatefulWidget {
  const BasicReorderableExample({super.key});

  @override
  State<BasicReorderableExample> createState() =>
      _BasicReorderableExampleState();
}

class _BasicReorderableExampleState extends State<BasicReorderableExample> {
  // รายการ items - ใช้ Map เพื่อเก็บ unique ID
  final List<Map<String, dynamic>> _items = [
    {'id': 'a', 'title': '🏆 Priority 1'},
    {'id': 'b', 'title': '🥈 Priority 2'},
    {'id': 'c', 'title': '🥉 Priority 3'},
    {'id': 'd', 'title': '📋 Priority 4'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Priority List')),
      body: ReorderableListView(
        // padding รอบ list
        padding: const EdgeInsets.all(16),

        // Callback เมื่อ reorder - สำคัญมาก!
        onReorder: (oldIndex, newIndex) {
          setState(() {
            // ⚠️ เมื่อย้ายลง newIndex จะมากกว่า oldIndex 1
            // ต้องลบ 1 ออกก่อนเพื่อให้ได้ตำแหน่งที่ถูกต้อง
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }

            // ย้าย item จากตำแหน่งเก่าไปตำแหน่งใหม่
            final item = _items.removeAt(oldIndex);
            _items.insert(newIndex, item);
          });
        },

        // รายการ children - ทุกตัวต้องมี Key!
        children: _items.map((item) {
          return Card(
            // Key จำเป็นสำหรับทุก child
            key: ValueKey(item['id']),
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(item['title']),
              subtitle: Text('ID: ${item['id']}'),
              // Drag handle จะแสดงอัตโนมัติด้านขวา
            ),
          );
        }).toList(),
      ),
    );
  }
}
