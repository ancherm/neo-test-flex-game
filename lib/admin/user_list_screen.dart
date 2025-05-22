import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../entity/user.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: const Text('Список пользователей')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(child: Text('Ошибка: ${snap.error}'));
          }
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snap.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('Пользователей пока нет'));
          }
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final d = docs[i];
              final user = User.fromFirestore(d);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ExpansionTile(
                  title: Text(user.name),
                  subtitle: Text(user.phone),
                  childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    ListTile(
                      title: const Text('Очки'),
                      trailing: Text(user.points.toString()),
                    ),
                    ListTile(
                      title: const Text('Пройдено тестов'),
                      trailing: Text(user.testsCompleted.toString()),
                    ),
                    ListTile(
                      title: const Text('Энергия'),
                      trailing: Text(user.energy.toString()),
                    ),

                    if (user.completedLevels.isNotEmpty) ...[
                      const Divider(),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Text('Пройденные уровни:', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      ...user.completedLevels.map((lvl) => ListTile(
                        dense: true,
                        leading: const Icon(Icons.check_circle_outline),
                        title: Text(lvl),
                      )),
                    ],

                    if (user.purchases != null && user.purchases!.isNotEmpty) ...[
                      const Divider(),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Text('Покупки:', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      ...user.purchases!.map((p) => ListTile(
                        dense: true,
                        leading: const Icon(Icons.shopping_cart),
                        title: Text('Item ID: ${p.shopItemId}'),
                        subtitle: Text('Дата: ${p.date.toLocal()}'),
                      )),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}