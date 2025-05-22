import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_test_screen.dart';

class TestListScreen extends StatelessWidget {
  const TestListScreen({Key? key}) : super(key: key);

  Future<void> _deleteTest(String id) =>
      FirebaseFirestore.instance.collection('tests').doc(id).delete();

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: const Text('Список тестов')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('tests').snapshots(),
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(child: Text('Ошибка: ${snap.error}'));
          }
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // Локальная сортировка по testType и part
          final docs = List<QueryDocumentSnapshot<Map<String, dynamic>>>.from(snap.data!.docs)
            ..sort((a, b) {
              final da = a.data(), db = b.data();
              final cmpType = (da['testType'] as String).compareTo(db['testType'] as String);
              if (cmpType != 0) return cmpType;
              return (da['part'] as String).compareTo(db['part'] as String);
            });

          if (docs.isEmpty) {
            return const Center(child: Text('Нет тестов'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final d = docs[i];
              final data = d.data();
              return ListTile(
                title: Text(data['question'] as String),
                subtitle: Text('Тип: ${data['testType']}, Часть: ${data['part']}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => _deleteTest(d.id),
                ),
                onTap: () => Navigator.push(
                  ctx,
                  MaterialPageRoute(
                    builder: (_) => AddTestScreen(doc: d),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Добавить тест',
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          ctx,
          MaterialPageRoute(builder: (_) => const AddTestScreen()),
        ),
      ),
    );
  }
}
