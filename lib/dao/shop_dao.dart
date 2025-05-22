import 'package:cloud_firestore/cloud_firestore.dart';
import '../entity/shop.dart';

class ShopDao {
  final CollectionReference<Map<String, dynamic>> _col =
      FirebaseFirestore.instance.collection('shops');

  /// Получить все товары в магазине
  Future<List<Shop>> getAllShopItems() async {
    final snap = await _col.get();
    return snap.docs.map((doc) => Shop.fromFirestore(doc)).toList();
  }

  /// Добавить или заменить товар
  Future<void> insertShopItem(Shop shop) async {
    if (shop.id != null) {
      // если есть id — сохраняем под ним
      await _col.doc(shop.id).set(shop.toMap(), SetOptions(merge: true));
    } else {
      await _col.add(shop.toMap());
    }
  }
}
