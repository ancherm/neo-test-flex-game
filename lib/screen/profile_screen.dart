import 'package:flutter/material.dart';
import '../app_database.dart';
import '../entity/purchase.dart';
import '../entity/shop.dart';
import '../entity/user.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatelessWidget {
  final AppDatabase database;

  ProfileScreen({required this.database});

  @override
  Widget build(BuildContext context) {
    // загружаем User, все Purchases и все Shop-товары
    final futureData = Future.wait([
      database.userDao.getUser(),                 
      database.purchaseDao.getAllPurchases(),     
      database.shopDao.getAllShopItems(),         
    ]);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Профиль',
          style: TextStyle(color: Colors.white)
        ),
        backgroundColor: const Color(0xFF150F1E),
        iconTheme: const IconThemeData(color: Colors.white),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futureData,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError || snap.data == null) {
            return Center(child: Text('Ошибка загрузки данных'));
          }

          final user      = snap.data![0] as User;
          final purchases = snap.data![1] as List<Purchase>;
          final shopItems = snap.data![2] as List<Shop>;

          // Для быстрого доступа: словарь id→Shop 
          final shopMap = { for (var item in shopItems) item.id!: item };

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Верхняя карточка профиля
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          child: Text(
                            user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          user.name,
                          style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Метрики: Очки, Энергия, Тесты
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildMetric('Очки', user.points.toString()),
                            _buildMetric('Энергия', user.energy.toString()),
                            _buildMetric('Тесты', user.testsCompleted.toString()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                // Заголовок раздела покупок
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Ваши покупки',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(height: 12),

                // Список покупок
                purchases.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'Покупки отсутствуют',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: purchases.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (ctx, i) {
                          final p = purchases[i];
                          final item = shopMap[p.shopItemId];
                          final date = DateFormat('dd.MM.yyyy HH:mm').format(p.date);
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            child: ListTile(
                              leading: item != null
                                  ? Image.asset(item.imageUrl, width: 40, height: 40)
                                  : const Icon(Icons.shopping_bag),
                              title: Text(item?.name ?? '—'),
                              subtitle: Text(date),
                            ),
                          );
                        },
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}
