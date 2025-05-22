import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_shop_screen.dart';

class ShopListScreen extends StatelessWidget {
  const ShopListScreen({Key? key}) : super(key: key);

  Future<void> _deleteItem(String id) =>
      FirebaseFirestore.instance.collection('shops').doc(id).delete();

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: const Text('Список товаров')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('shops').snapshots(),
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(child: Text('Ошибка: ${snap.error}'));
          }
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snap.data!.docs;
          if (docs.isEmpty) {
            return const Center(child: Text('Товаров пока нет'));
          }
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final d = docs[i];
              final data = d.data();
              return ListTile(
                leading: SizedBox(
                  width: 50,
                  child: Image.network(
                    data['imageUrl'] as String,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                  ),
                ),
                title: Text(data['name'] as String),
                subtitle: Text('Стоимость: ${data['cost']}  |  Тип: ${data['type']}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => _deleteItem(d.id),
                ),
                onTap: () {
                  Navigator.push(
                    ctx,
                    MaterialPageRoute(
                      builder: (_) => AddShopScreen(doc: d),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Добавить товар',
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          ctx,
          MaterialPageRoute(builder: (_) => const AddShopScreen()),
        ),
      ),
    );
  }
}
