import 'package:flutter/material.dart';

class TwoWayDismissible extends StatefulWidget {
  const TwoWayDismissible({super.key});

  @override
  State<TwoWayDismissible> createState() => _TwoWayDismissibleState();
}

class _TwoWayDismissibleState extends State<TwoWayDismissible> {
  final List<Map<String, dynamic>> _emails = [
    {'id': '1', 'from': 'boss@company.com', 'subject': 'ประชุมพรุ่งนี้'},
    {'id': '2', 'from': 'hr@company.com', 'subject': 'วันหยุดประจำปี'},
    {'id': '3', 'from': 'promo@shop.com', 'subject': 'ลดราคา 50%!'},
  ];

  void _handleDismiss(DismissDirection direction, int index) {
    final email = _emails[index];
    final action = direction == DismissDirection.startToEnd
        ? 'Archive'
        : 'Delete';

    setState(() {
      _emails.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action: ${email['subject']}'),
        backgroundColor: direction == DismissDirection.startToEnd
            ? Colors.green
            : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email Inbox')),
      body: ListView.builder(
        itemCount: _emails.length,
        itemBuilder: (context, index) {
          final email = _emails[index];

          return Dismissible(
            key: ValueKey(email['id']),

            // Background สำหรับ Swipe ขวา → (Archive)
            background: Container(
              color: Colors.green,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              child: const Row(
                children: [
                  Icon(Icons.archive, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Archive',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Secondary Background สำหรับ Swipe ซ้าย ← (Delete)
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.delete, color: Colors.white),
                ],
              ),
            ),

            onDismissed: (direction) => _handleDismiss(direction, index),

            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.email)),
                title: Text(email['subject']),
                subtitle: Text(email['from']),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          );
        },
      ),
    );
  }
}
