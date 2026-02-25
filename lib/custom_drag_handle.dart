import 'package:flutter/material.dart';

class CustomDragHandleExample extends StatefulWidget {
  const CustomDragHandleExample({super.key});

  @override
  State<CustomDragHandleExample> createState() =>
      _CustomDragHandleExampleState();
}

class _CustomDragHandleExampleState extends State<CustomDragHandleExample> {
  final List<Map<String, dynamic>> _items = [
    {'id': '1', 'title': 'Item A', 'color': Colors.blue},
    {'id': '2', 'title': 'Item B', 'color': Colors.green},
    {'id': '3', 'title': 'Item C', 'color': Colors.orange},
    {'id': '4', 'title': 'Item D', 'color': Colors.purple},
  ];

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = _items.removeAt(oldIndex);
      _items.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Drag Handle')),
      body: ReorderableListView.builder(
        padding: const EdgeInsets.all(16),

        // ปิด default drag handles
        buildDefaultDragHandles: false,

        itemCount: _items.length,
        onReorder: _onReorder,

        itemBuilder: (context, index) {
          final item = _items[index];

          return Card(
            key: ValueKey(item['id']),
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: item['color'].withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  // Custom Drag Handle ด้านซ้าย
                  ReorderableDragStartListener(
                    index: index,
                    child: Container(
                      width: 48,
                      height: 64,
                      decoration: BoxDecoration(
                        color: item['color'].withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: Icon(Icons.drag_indicator, color: item['color']),
                    ),
                  ),

                  // Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'ลากที่แถบด้านซ้ายเพื่อจัดลำดับ',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
